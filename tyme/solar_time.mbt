// two_digits 两位补零

///|
fn two_digits(n : Int) -> String {
  if n < 10 {
    "0" + n.to_string()
  } else {
    n.to_string()
  }
}

///|
// SolarTime 公历时刻
pub struct SolarTime {
  second_unit : SecondUnit
}

///|
extend SolarTime with Culture::{get_name}

///|
extend SolarTime with Show::{to_string}

///|
pub fn SolarTime::new(second_unit : SecondUnit) -> SolarTime {
  { second_unit, }
}

///|
// equals 是否相等
pub fn SolarTime::equals(self : SolarTime, target : SolarTime) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year 年
pub fn SolarTime::get_year(self : SolarTime) -> Int {
  self.second_unit.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn SolarTime::get_month(self : SolarTime) -> Int {
  self.second_unit.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn SolarTime::get_day(self : SolarTime) -> Int {
  self.second_unit.day_unit.get_day()
}

///|
// get_hour 时
pub fn SolarTime::get_hour(self : SolarTime) -> Int {
  self.second_unit.get_hour()
}

///|
// get_minute 分
pub fn SolarTime::get_minute(self : SolarTime) -> Int {
  self.second_unit.get_minute()
}

///|
// get_second 秒
pub fn SolarTime::get_second(self : SolarTime) -> Int {
  self.second_unit.get_second()
}

///|
// get_julian_day 儒略日
pub fn SolarTime::get_julian_day(self : SolarTime) -> JulianDay {
  JulianDay::from_ymdhms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    self.get_hour(),
    self.get_minute(),
    self.get_second(),
  )
}

///|
// get_compare_index 用于比较大小的索引
pub fn SolarTime::get_compare_index(self : SolarTime) -> Int64 {
  self.second_unit.get_compare_index()
}

///|
// is_before 是否在指定公历时刻之前
pub fn SolarTime::is_before(self : SolarTime, target : SolarTime) -> Bool {
  self.get_compare_index() < target.get_compare_index()
}

///|
// is_after 是否在指定公历时刻之后
pub fn SolarTime::is_after(self : SolarTime, target : SolarTime) -> Bool {
  self.get_compare_index() > target.get_compare_index()
}

///|
// validate 校验
pub fn SolarTime::validate(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[Unit, String] {
  match SecondUnit::validate(year, month, day, hour, minute, second) {
    Ok(_) => SolarDay::validate(year, month, day)
    Err(e) => Err(e)
  }
}

///|
// from_ymdhms 从年月日时分秒构造
pub fn SolarTime::from_ymdhms(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[SolarTime, String] {
  match SolarTime::validate(year, month, day, hour, minute, second) {
    Ok(_) =>
      Ok(SolarTime::{
        second_unit: SecondUnit::new(
          DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
          hour,
          minute,
          second,
        ),
      })
    Err(e) => Err(e)
  }
}

///|
// get_solar_day 公历日
pub fn SolarTime::get_solar_day(self : SolarTime) -> SolarDay {
  match SolarDay::from_ymd(self.get_year(), self.get_month(), self.get_day()) {
    Ok(d) => d
    Err(_) => SolarDay::new(self.second_unit.day_unit)
  }
}

///|
// next 偏移 n 秒
pub fn SolarTime::next(self : SolarTime, n : Int) -> SolarTime {
  if n == 0 {
    match
      SolarTime::from_ymdhms(
        self.get_year(),
        self.get_month(),
        self.get_day(),
        self.get_hour(),
        self.get_minute(),
        self.get_second(),
      ) {
      Ok(t) => t
      Err(_) => SolarTime::new(self.second_unit)
    }
  } else {
    let ts = self.get_hour() * 3600 +
      self.get_minute() * 60 +
      self.get_second() +
      n
    let s = AbstractCulture::index_of(ts, 86400)
    let d = self.get_solar_day().next(AbstractCulture::floor_div(ts, 86400))
    match
      SolarTime::from_ymdhms(
        d.get_year(),
        d.get_month(),
        d.get_day(),
        s / 3600,
        s % 3600 / 60,
        s % 60,
      ) {
      Ok(t) => t
      Err(_) => SolarTime::new(self.second_unit)
    }
  }
}

///|
// subtract 公历时刻相减，获得相差秒数
// 注：此处乘以 86400 必须用 Int64 防止 32 位静默溢出
pub fn SolarTime::subtract(self : SolarTime, target : SolarTime) -> Int64 {
  self.get_solar_day().subtract(target.get_solar_day()).to_int64() * 86400L +
  self.second_unit.get_seconds_in_day().to_int64() -
  target.second_unit.get_seconds_in_day().to_int64()
}

///|
// get_term 节气
pub fn SolarTime::get_term(self : SolarTime) -> SolarTerm {
  let mut term = self.get_solar_day().get_term()
  if self.is_before(term.get_julian_day().get_solar_time()) {
    term = term.next(-1)
  }
  term
}

///|
// get_phenology 候
pub fn SolarTime::get_phenology(self : SolarTime) -> Phenology {
  let mut p = self.get_solar_day().get_phenology()
  if self.is_before(p.get_julian_day().get_solar_time()) {
    p = p.next(-1)
  }
  p
}

///|
// get_phase 月相（先经农历时辰→农历日→农历月，取次月首朔推算）
pub fn SolarTime::get_phase(self : SolarTime) -> Phase {
  let month = self.get_lunar_hour().get_lunar_day().get_lunar_month().next(1)
  let mut p = Phase::from_index(
    month.get_year(),
    month.get_month_with_leap(),
    0,
  )
  while p.get_solar_time().is_after(self) {
    p = p.next(-1)
  }
  p
}

///|
// get_lunar_hour 农历时辰（先经 GetSolarDay().GetLunarDay() 做公历→农历转换）
pub fn SolarTime::get_lunar_hour(self : SolarTime) -> LunarHour {
  let d = self.get_solar_day().get_lunar_day()
  LunarHour::from_ymd_hms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    self.get_hour(),
    self.get_minute(),
    self.get_second(),
  ).unwrap()
}

///|
// get_sixty_cycle_hour 干支时辰
pub fn SolarTime::get_sixty_cycle_hour(self : SolarTime) -> SixtyCycleHour {
  SixtyCycleHour::from_solar_time(self)
}

///|
impl Culture for SolarTime with fn get_name(self : SolarTime) -> String {
  two_digits(self.get_hour()) +
  ":" +
  two_digits(self.get_minute()) +
  ":" +
  two_digits(self.get_second())
}

///|
impl Show for SolarTime with fn to_string(self : SolarTime) -> String {
  self.get_solar_day().to_string() + " " + self.get_name()
}
