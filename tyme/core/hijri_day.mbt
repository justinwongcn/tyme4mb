///|
// hijri_day_names 回历日名称
pub fn hijri_day_names() -> Array[String] {
  [
    "1日", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日",
    "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日",
    "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日",
    "29日", "30日",
  ]
}

///|
// HijriDay 回历日
pub struct HijriDay {
  day_unit : DayUnit
}

///|
pub extend HijriDay with Culture::{get_name}

///|
pub extend HijriDay with Show::{to_string}

///|
pub fn HijriDay::new(day_unit : DayUnit) -> HijriDay {
  { day_unit, }
}

///|
// get_year 年
pub fn HijriDay::get_year(self : HijriDay) -> Int {
  self.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn HijriDay::get_month(self : HijriDay) -> Int {
  self.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn HijriDay::get_day(self : HijriDay) -> Int {
  self.day_unit.get_day()
}

///|
// validate 校验
pub fn HijriDay::validate(
  year : Int,
  month : Int,
  day : Int,
) -> Result[Unit, String] {
  let m = match HijriMonth::from_ym(year, month) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if day < 1 || day > m.get_day_count() {
    return Err("illegal hijri day: \{year}-\{month}-\{day}")
  }
  Ok(())
}

///|
// from_ymd 从年月日构造
pub fn HijriDay::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> Result[HijriDay, String] {
  match HijriDay::validate(year, month, day) {
    Ok(_) =>
      Ok({
        day_unit: DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
      })
    Err(e) => Err(e)
  }
}

///|
// get_hijri_month 回历月
pub fn HijriDay::get_hijri_month(self : HijriDay) -> HijriMonth {
  match HijriMonth::from_ym(self.get_year(), self.get_month()) {
    Ok(m) => m
    Err(_) =>
      HijriMonth::new(
        MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
      )
  }
}

///|
// get_compare_index 用于比较大小的索引
pub fn HijriDay::get_compare_index(self : HijriDay) -> Int {
  self.day_unit.get_compare_index()
}

///|
// is_before 是否在指定回历日之前
pub fn HijriDay::is_before(self : HijriDay, target : HijriDay) -> Bool {
  self.get_compare_index() < target.get_compare_index()
}

///|
// is_after 是否在指定回历日之后
pub fn HijriDay::is_after(self : HijriDay, target : HijriDay) -> Bool {
  self.get_compare_index() > target.get_compare_index()
}

///|
// get_index_in_year 位于当年的索引
pub fn HijriDay::get_index_in_year(self : HijriDay) -> Int {
  match HijriDay::from_ymd(self.get_year(), 1, 1) {
    Ok(d) => self.subtract(d)
    Err(_) => 0
  }
}

///|
// subtract 回历日期相减，获得相差天数
pub fn HijriDay::subtract(self : HijriDay, target : HijriDay) -> Int {
  self.get_julian_day().subtract(target.get_julian_day()).to_int()
}

///|
// get_julian_day 儒略日
pub fn HijriDay::get_julian_day(self : HijriDay) -> JulianDay {
  JulianDay::from_julian_day(
    (AbstractCulture::floor_div(11 * self.get_year() + 3, 30) +
    354 * self.get_year() +
    30 * self.get_month() -
    AbstractCulture::floor_div(self.get_month() - 1, 2) +
    self.get_day() +
    1948055).to_double(),
  )
}

///|
// get_solar_day 公历日
pub fn HijriDay::get_solar_day(self : HijriDay) -> SolarDay {
  let d = SolarDay::from_ymd(622, 7, 16).unwrap()
  let h = HijriDay::from_ymd(1, 1, 1).unwrap()
  d.next(self.subtract(h))
}

///|
// equals 是否相等
pub fn HijriDay::equals(self : HijriDay, target : HijriDay) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub impl Culture for HijriDay with fn get_name(self : HijriDay) -> String {
  hijri_day_names()[self.get_day() - 1]
}

///|
pub impl Show for HijriDay with fn to_string(self : HijriDay) -> String {
  self.get_hijri_month().to_string() + self.get_name()
}

///|
pub impl Tyme for HijriDay with fn next(self : HijriDay, n : Int) -> HijriDay {
  self.get_solar_day().next(n).get_hijri_day()
}

///|
pub extend HijriDay with Tyme::{next}
