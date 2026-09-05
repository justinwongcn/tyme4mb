///|
// hijri_month_names 回历月名称
pub fn hijri_month_names() -> Array[String] {
  [
    "穆哈兰姆月", "色法尔月", "赖比尔·敖外鲁月", "赖比尔·阿色尼月",
    "主马达·敖外鲁月", "主马达·阿色尼月", "赖哲卜月", "舍尔邦月",
    "赖买丹月", "闪瓦鲁月", "都尔喀尔德月", "都尔黑哲月",
  ]
}

///|
// HijriMonth 回历月
pub struct HijriMonth {
  month_unit : MonthUnit
}

///|
pub extend HijriMonth with Culture::{get_name}

///|
pub extend HijriMonth with Show::{to_string}

///|
pub fn HijriMonth::new(month_unit : MonthUnit) -> HijriMonth {
  { month_unit, }
}

///|
// get_year 年
pub fn HijriMonth::get_year(self : HijriMonth) -> Int {
  self.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn HijriMonth::get_month(self : HijriMonth) -> Int {
  self.month_unit.get_month()
}

///|
// validate 校验
pub fn HijriMonth::validate(year : Int, month : Int) -> Result[Unit, String] {
  if month < 1 || month > 12 {
    return Err("illegal hijri month: " + month.to_string())
  }
  HijriYear::validate(year)
}

///|
// from_ym 从年月构造
pub fn HijriMonth::from_ym(
  year : Int,
  month : Int,
) -> Result[HijriMonth, String] {
  match HijriMonth::validate(year, month) {
    Ok(_) => Ok({ month_unit: MonthUnit::new(YearUnit::new(year), month), })
    Err(e) => Err(e)
  }
}

///|
// get_hijri_year 回历年
pub fn HijriMonth::get_hijri_year(self : HijriMonth) -> HijriYear {
  match HijriYear::from_year(self.get_year()) {
    Ok(y) => y
    Err(_) => HijriYear::new(YearUnit::new(self.get_year()))
  }
}

///|
// get_day_count 天数（单数月30天，双数月29天，闰年第12月30天)
pub fn HijriMonth::get_day_count(self : HijriMonth) -> Int {
  let mut d = 30
  if self.get_month() % 2 == 0 {
    d = 29
  }
  if self.get_month() == 12 && self.get_hijri_year().is_leap() {
    d = d + 1
  }
  d
}

///|
// get_index_in_year 位于当年的索引(0-11)
pub fn HijriMonth::get_index_in_year(self : HijriMonth) -> Int {
  self.get_month() - 1
}

///|
// get_days 本月回历日列表
pub fn HijriMonth::get_days(self : HijriMonth) -> Array[HijriDay] {
  let l : Array[HijriDay] = []
  let size = self.get_day_count()
  for i = 1; i <= size; i = i + 1 {
    match HijriDay::from_ymd(self.get_year(), self.get_month(), i) {
      Ok(d) => l.push(d)
      Err(_) => ()
    }
  }
  l
}

///|
// get_first_day 本月第1天
pub fn HijriMonth::get_first_day(self : HijriMonth) -> HijriDay {
  match HijriDay::from_ymd(self.get_year(), self.get_month(), 1) {
    Ok(d) => d
    Err(_) =>
      HijriDay::new(
        DayUnit::new(
          MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
          1,
        ),
      )
  }
}

///|
pub impl Culture for HijriMonth with fn get_name(self : HijriMonth) -> String {
  hijri_month_names()[self.get_index_in_year()]
}

///|
pub impl Show for HijriMonth with fn to_string(self : HijriMonth) -> String {
  self.get_hijri_year().to_string() + self.get_name()
}

///|
pub impl Tyme for HijriMonth with fn next(self : HijriMonth, n : Int) -> HijriMonth {
  let i = self.get_month() - 1 + n
  match
    HijriMonth::from_ym(
      (self.get_year() * 12 + i) / 12,
      AbstractCulture::index_of(i, 12) + 1,
    ) {
    Ok(m) => m
    Err(_) => self
  }
}

///|
pub extend HijriMonth with Tyme::{next}
