///|
// SolarYear 公历年
pub struct SolarYear {
  year_unit : YearUnit
}

///|
extend SolarYear with Culture::{get_name}

///|
extend SolarYear with Show::{to_string}

///|
extend SolarYear with Tyme::{next}

///|
pub fn SolarYear::new(year_unit : YearUnit) -> SolarYear {
  { year_unit, }
}

///|
// equals 是否相等
pub fn SolarYear::equals(self : SolarYear, target : SolarYear) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year 年
pub fn SolarYear::get_year(self : SolarYear) -> Int {
  self.year_unit.get_year()
}

///|
// validate 校验
pub fn SolarYear::validate(year : Int) -> Result[Unit, String] {
  if year < 1 || year > 9999 {
    return Err("illegal solar year: " + year.to_string())
  }
  Ok(())
}

///|
// from_year 从年构造
pub fn SolarYear::from_year(year : Int) -> Result[SolarYear, String] {
  match SolarYear::validate(year) {
    Ok(_) => Ok(SolarYear::{ year_unit: YearUnit::new(year) })
    Err(e) => Err(e)
  }
}

///|
// is_leap 是否闰年（1582年以前用儒略历，能被4整除即为闰年；以后用格里历）
pub fn SolarYear::is_leap(self : SolarYear) -> Bool {
  let y = self.get_year()
  if y < 1600 {
    return y % 4 == 0
  }
  (y % 4 == 0 && y % 100 != 0) || y % 400 == 0
}

///|
// get_day_count 天数（1582年355天，平年365天，闰年366天）
pub fn SolarYear::get_day_count(self : SolarYear) -> Int {
  let y = self.get_year()
  if y == 1582 {
    return 355
  }
  if self.is_leap() {
    return 366
  }
  365
}

///|
// get_months 月份列表
pub fn SolarYear::get_months(self : SolarYear) -> Array[SolarMonth] {
  let l : Array[SolarMonth] = []
  for i = 1; i < 13; i = i + 1 {
    match SolarMonth::from_ym(self.get_year(), i) {
      Ok(m) => l.push(m)
      Err(_) => ()
    }
  }
  l
}

///|
// get_seasons 季度列表
pub fn SolarYear::get_seasons(self : SolarYear) -> Array[SolarSeason] {
  let l : Array[SolarSeason] = []
  for i = 0; i < 4; i = i + 1 {
    l.push(SolarSeason::from_index(self.get_year(), i).unwrap())
  }
  l
}

///|
// get_half_years 半年列表
pub fn SolarYear::get_half_years(self : SolarYear) -> Array[SolarHalfYear] {
  let l : Array[SolarHalfYear] = []
  for i = 0; i < 2; i = i + 1 {
    l.push(SolarHalfYear::from_index(self.get_year(), i).unwrap())
  }
  l
}

///|
// get_rab_byung_year 藏历年
pub fn SolarYear::get_rab_byung_year(
  self : SolarYear,
) -> Result[RabByungYear, String] {
  RabByungYear::from_year(self.get_year())
}

// 注（部分功能优先，2026-08-03 02:15 更新）：
// 已补译：get_months（SolarMonth）、get_seasons（SolarSeason）、
//   get_half_years（SolarHalfYear）、get_rab_byung_year（RabByungYear，
//   2026-08-03 随 RabByungYear 译出回填）

///|
impl Culture for SolarYear with fn get_name(self : SolarYear) -> String {
  self.get_year().to_string() + "年"
}

///|
impl Show for SolarYear with fn to_string(self : SolarYear) -> String {
  self.get_name()
}

///|
impl Tyme for SolarYear with fn next(self : SolarYear, n : Int) -> SolarYear {
  match SolarYear::from_year(self.get_year() + n) {
    Ok(y) => y
    Err(_) => self
  }
}
