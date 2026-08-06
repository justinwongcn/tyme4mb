// J2000 2000年儒略日数(2000-1-1 12:00:00 UTC)

///|
pub const J2000 : Int = 2451545

///|
// JulianDay 儒略日
pub struct JulianDay {
  abstract_tyme : AbstractTyme
  day : Double
}

///|
extend JulianDay with Culture::{get_name}

///|
extend JulianDay with Tyme::{next}

///|
// from_julian_day 从儒略日构造
pub fn JulianDay::from_julian_day(day : Double) -> JulianDay {
  { abstract_tyme: AbstractTyme::new(), day }
}

///|
// from_ymdhms 从年月日时分秒构造
pub fn JulianDay::from_ymdhms(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> JulianDay {
  let d = day.to_double() +
    ((second.to_double() / 60.0 + minute.to_double()) / 60.0 + hour.to_double()) /
    24.0
  let mut y = year
  let mut m = month
  let mut n = 0
  let g = y * 372 + m * 31 + d.to_int() >= 588829
  if m <= 2 {
    m = m + 12
    y = y - 1
  }
  if g {
    n = (y.to_double() * 0.01).to_int()
    n = 2 - n + (n.to_double() * 0.25).to_int()
  }
  let jd = (365.25 * (y + 4716).to_double()).to_int().to_double() +
    (30.6001 * (m + 1).to_double()).to_int().to_double() +
    d +
    n.to_double() -
    1524.5
  JulianDay::from_julian_day(jd)
}

///|
// get_day 儒略日
pub fn JulianDay::get_day(self : JulianDay) -> Double {
  self.day
}

///|
// subtract 儒略日相减
pub fn JulianDay::subtract(self : JulianDay, target : JulianDay) -> Double {
  self.day - target.get_day()
}

///|
// get_week 星期
pub fn JulianDay::get_week(self : JulianDay) -> Week {
  Week::from_index((self.day + 0.5).to_int() + 7000001)
}

///|
// get_solar_time 公历时刻
pub fn JulianDay::get_solar_time(self : JulianDay) -> Result[SolarTime, String] {
  let mut d = (self.day + 0.5).to_int()
  let mut f = self.day + 0.5 - d.to_double()
  if d >= 2299161 {
    let c = ((d.to_double() - 1867216.25) / 36524.25).to_int()
    d = d + 1 + c - (c.to_double() * 0.25).to_int()
  }
  d = d + 1524
  let mut y = ((d.to_double() - 122.1) / 365.25).to_int()
  d = d - (365.25 * y.to_double()).to_int()
  let mut m = (d.to_double() / 30.601).to_int()
  d = d - (30.601 * m.to_double()).to_int()
  if m > 13 {
    m = m - 12
  } else {
    y = y - 1
  }
  m = m - 1
  y = y - 4715
  f = f * 24.0
  let hour = f.to_int()
  f = f - hour.to_double()
  f = f * 60.0
  let minute = f.to_int()
  f = f - minute.to_double()
  f = f * 60.0
  let second = @math.round(f).to_int()
  if second < 60 {
    SolarTime::from_ymdhms(y, m, d, hour, minute, second)
  } else {
    match SolarTime::from_ymdhms(y, m, d, hour, minute, second - 60) {
      Ok(t) => Ok(t.next(60))
      Err(e) => Err(e)
    }
  }
}

///|
// get_solar_time_unchecked 供包内已验证年份生成的儒略日使用
fn JulianDay::get_solar_time_unchecked(self : JulianDay) -> SolarTime {
  self.get_solar_time().unwrap()
}

///|
// get_solar_day 公历日
pub fn JulianDay::get_solar_day(self : JulianDay) -> Result[SolarDay, String] {
  match self.get_solar_time() {
    Err(e) => Err(e)
    Ok(solar_time) =>
      SolarDay::from_ymd(
        solar_time.get_year(),
        solar_time.get_month(),
        solar_time.get_day(),
      )
  }
}

///|
// get_solar_day_unchecked 包内已知合法 JulianDay 的快速转换
fn JulianDay::get_solar_day_unchecked(self : JulianDay) -> SolarDay {
  self.get_solar_time_unchecked().get_solar_day()
}

// 注：GetSolarTime / GetSolarDay 已于 2026-08-02 随 SCC 破环补齐，
// 二者与 SolarTime.get_solar_day / SolarDay.next 同回合译出。

///|
pub impl Culture for JulianDay with fn get_name(self : JulianDay) -> String {
  "\{self.day}"
}

///|
pub impl Show for JulianDay with fn to_string(self : JulianDay) -> String {
  self.get_name()
}

///|
pub impl Tyme for JulianDay with fn next(self : JulianDay, n : Int) -> JulianDay {
  JulianDay::from_julian_day(self.day + n.to_double())
}
