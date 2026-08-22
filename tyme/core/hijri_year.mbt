///|
// HijriYear 回历年
pub struct HijriYear {
  year_unit : YearUnit
}

///|
pub extend HijriYear with Culture::{get_name}

///|
pub extend HijriYear with Show::{to_string}

///|
pub fn HijriYear::new(year_unit : YearUnit) -> HijriYear {
  { year_unit, }
}

///|
// get_year 年
pub fn HijriYear::get_year(self : HijriYear) -> Int {
  self.year_unit.get_year()
}

///|
// validate 校验
pub fn HijriYear::validate(year : Int) -> Result[Unit, String] {
  if year < -640 || year > 9666 {
    return Err("illegal hijri year: " + year.to_string())
  }
  Ok(())
}

///|
// from_year 从年构造
pub fn HijriYear::from_year(year : Int) -> Result[HijriYear, String] {
  match HijriYear::validate(year) {
    Ok(_) => Ok({ year_unit: YearUnit::new(year) })
    Err(e) => Err(e)
  }
}

///|
// get_day_count 天数（平年354天，闰年355天）
pub fn HijriYear::get_day_count(self : HijriYear) -> Int {
  if self.is_leap() {
    return 355
  }
  354
}

///|
// is_leap 是否闰年(1个闰周为30年，1个闰周中第2、5、7、10、13、16、18、21、24、26、29年为闰年)
pub fn HijriYear::is_leap(self : HijriYear) -> Bool {
  let i = AbstractCulture::index_of(self.get_year() - 1, 30)
  i == 1 ||
  i == 4 ||
  i == 6 ||
  i == 9 ||
  i == 12 ||
  i == 15 ||
  i == 17 ||
  i == 20 ||
  i == 23 ||
  i == 25 ||
  i == 28
}

///|
// get_months 月份列表，1年有12个月。
pub fn HijriYear::get_months(self : HijriYear) -> Array[HijriMonth] {
  let l : Array[HijriMonth] = []
  for i = 1; i < 13; i = i + 1 {
    match HijriMonth::from_ym(self.get_year(), i) {
      Ok(m) => l.push(m)
      Err(_) => ()
    }
  }
  l
}

///|
// get_first_month 首月
pub fn HijriYear::get_first_month(self : HijriYear) -> HijriMonth {
  match HijriMonth::from_ym(self.get_year(), 1) {
    Ok(m) => m
    Err(_) => HijriMonth::new(MonthUnit::new(YearUnit::new(self.get_year()), 1))
  }
}

///|
pub impl Culture for HijriYear with fn get_name(self : HijriYear) -> String {
  "\{self.get_year()}年"
}

///|
pub impl Show for HijriYear with fn to_string(self : HijriYear) -> String {
  self.get_name()
}

///|
pub impl Tyme for HijriYear with fn next(self : HijriYear, n : Int) -> HijriYear {
  match HijriYear::from_year(self.get_year() + n) {
    Ok(y) => y
    Err(_) => self
  }
}

///|
pub extend HijriYear with Tyme::{next}
