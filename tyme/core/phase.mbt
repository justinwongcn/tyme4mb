///|
// Phase 月相
pub struct Phase {
  loop_tyme : LoopTyme
  lunar_year : Int
  lunar_month : Int
}

///|
// phase_names 月相名称
pub fn phase_names() -> Array[String] {
  [
    "新月", "蛾眉月", "上弦月", "盈凸月", "满月", "亏凸月", "下弦月",
    "残月",
  ]
}

///|
// from_index 从年月索引构造
pub fn Phase::from_index(
  lunar_year : Int,
  lunar_month : Int,
  index : Int,
) -> Phase {
  let m = LunarMonth::from_ym(lunar_year, lunar_month).unwrap()
  let month = m.next(index / phase_names().length())
  {
    loop_tyme: LoopTyme::from_index(phase_names(), index),
    lunar_year: month.get_year(),
    lunar_month: month.get_month_with_leap(),
  }
}

///|
// from_name 从名称构造
pub fn Phase::from_name(
  lunar_year : Int,
  lunar_month : Int,
  name : String,
) -> Result[Phase, String] {
  let p = match LoopTyme::from_name(phase_names(), name) {
    Err(e) => return Err(e)
    Ok(v) => v
  }
  Ok({ loop_tyme: p, lunar_year, lunar_month, })
}

///|
// next 推移
pub fn Phase::next(self : Phase, n : Int) -> Phase {
  let size = self.loop_tyme.get_size()
  let mut i = self.loop_tyme.get_index() + n
  if i < 0 {
    i = i - size
  }
  i = i / size
  let mut month = LunarMonth::from_ym(self.lunar_year, self.lunar_month).unwrap()
  if i != 0 {
    month = month.next(i)
  }
  Phase::from_index(
    month.get_year(),
    month.get_month_with_leap(),
    self.loop_tyme.next_index(n),
  )
}

///|
fn Phase::get_start_solar_time(self : Phase) -> SolarTime {
  let n = @math.floor(
    (self.lunar_year - 2000).to_double() * 365.2422 / 29.53058886,
  ).to_int()
  let mut i = 0
  let jd = J2000.to_double() + OneThird
  let d = LunarDay::from_ymd(self.lunar_year, self.lunar_month, 1)
    .unwrap()
    .get_solar_day()
  while true {
    let t = msa_lon_t((n + i).to_double() * Pi2) * 36525.0
    if !JulianDay::from_julian_day(jd + t - dt_t(t))
      .get_solar_day_unchecked()
      .is_before(d) {
      break
    }
    i = i + 1
  }
  let arr : Array[Int] = [0, 90, 180, 270]
  let t = msa_lon_t(
      (
        (n + i).to_double() +
        arr[self.loop_tyme.get_index() / 2].to_double() / 360.0
      ) *
      Pi2,
    ) *
    36525.0
  JulianDay::from_julian_day(jd + t - dt_t(t)).get_solar_time_unchecked()
}

///|
// get_solar_time 月相公历时刻
pub fn Phase::get_solar_time(self : Phase) -> SolarTime {
  let t = self.get_start_solar_time()
  if self.loop_tyme.get_index() % 2 == 1 {
    return t.next(1)
  }
  t
}

///|
// get_solar_day 月相公历日
pub fn Phase::get_solar_day(self : Phase) -> SolarDay {
  let d = self.get_start_solar_time().get_solar_day()
  if self.loop_tyme.get_index() % 2 == 1 {
    return d.next(1)
  }
  d
}

///|
// get_index 索引
pub fn Phase::get_index(self : Phase) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_name 名称
pub fn Phase::get_name(self : Phase) -> String {
  phase_names()[self.loop_tyme.get_index()]
}

///|
// get_lunar_year 农历年
pub fn Phase::get_lunar_year(self : Phase) -> Int {
  self.lunar_year
}

///|
// get_lunar_month 农历月
pub fn Phase::get_lunar_month(self : Phase) -> Int {
  self.lunar_month
}

///|
pub impl Culture for Phase with fn get_name(self : Phase) -> String {
  self.get_name()
}

///|
pub impl Show for Phase with fn to_string(self : Phase) -> String {
  self.get_name()
}

///|
pub impl Tyme for Phase with fn next(self : Phase, n : Int) -> Phase {
  self.next(n)
}

///|
pub extend Phase with Show::{to_string}
