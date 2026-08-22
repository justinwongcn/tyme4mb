// solar_day_names 公历日名称

///|
pub fn solar_day_names() -> Array[String] {
  [
    "1日", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日",
    "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日",
    "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日",
    "29日", "30日", "31日",
  ]
}

///|
// SolarDay 公历日
pub struct SolarDay {
  day_unit : DayUnit
}

///|
extend SolarDay with Culture::{get_name}

///|
extend SolarDay with Show::{to_string}

///|
pub fn SolarDay::new(day_unit : DayUnit) -> SolarDay {
  { day_unit, }
}

///|
// validate 校验
pub fn SolarDay::validate(
  year : Int,
  month : Int,
  day : Int,
) -> Result[Unit, String] {
  let mut illegal = day < 1
  if !illegal {
    if year == 1582 && month == 10 {
      illegal = (day > 4 && day < 15) || day > 31
    } else {
      match SolarMonth::from_ym(year, month) {
        Ok(m) => illegal = day > m.get_day_count()
        Err(e) => return Err(e)
      }
    }
  }
  if illegal {
    return Err("illegal solar day: \{year}-\{month}-\{day}")
  }
  Ok(())
}

///|
// from_ymd 从年月日构造
pub fn SolarDay::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> Result[SolarDay, String] {
  match SolarDay::validate(year, month, day) {
    Ok(_) =>
      Ok({
        day_unit: DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
      })
    Err(e) => Err(e)
  }
}

///|
// get_solar_month 公历月
pub fn SolarDay::get_solar_month(self : SolarDay) -> SolarMonth {
  match SolarMonth::from_ym(self.get_year(), self.get_month()) {
    Ok(m) => m
    Err(_) =>
      SolarMonth::new(
        MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
      )
  }
}

///|
// get_index_in_year 位于当年的索引
pub fn SolarDay::get_index_in_year(self : SolarDay) -> Int {
  match SolarDay::from_ymd(self.get_year(), 1, 1) {
    Ok(d) => self.subtract(d)
    Err(_) => 0
  }
}

///|
// equals 是否相等
pub fn SolarDay::equals(self : SolarDay, target : SolarDay) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year 年
pub fn SolarDay::get_year(self : SolarDay) -> Int {
  self.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn SolarDay::get_month(self : SolarDay) -> Int {
  self.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn SolarDay::get_day(self : SolarDay) -> Int {
  self.day_unit.get_day()
}

///|
// get_julian_day 儒略日
pub fn SolarDay::get_julian_day(self : SolarDay) -> JulianDay {
  JulianDay::from_ymdhms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    0,
    0,
    0,
  )
}

///|
// get_week 星期
pub fn SolarDay::get_week(self : SolarDay) -> Week {
  self.get_julian_day().get_week()
}

///|
// get_solar_week 公历周（参数 start：起始星期，1234560 分别代表星期一至星期天）
pub fn SolarDay::get_solar_week(
  self : SolarDay,
  start : Int,
) -> Result[SolarWeek, String] {
  let first = self.get_solar_month().get_first_day()
  let x = first.get_week().next(-start).get_index()
  let week_index = (self.get_day() + x + 6) / 7 - 1
  SolarWeek::from_ym(self.get_year(), self.get_month(), week_index, start)
}

///|
// get_constellation 星座
pub fn SolarDay::get_constellation(self : SolarDay) -> Constellation {
  let days = [19, 18, 20, 19, 20, 21, 22, 22, 22, 23, 22, 21]
  let m = self.get_month() - 1
  let mut offset = 0
  if self.get_day() > days[m] {
    offset = 1
  }
  Constellation::from_index(9 + m + offset)
}

///|
// get_compare_index 用于比较大小的索引
pub fn SolarDay::get_compare_index(self : SolarDay) -> Int {
  self.day_unit.get_compare_index()
}

///|
// is_before 是否在指定公历日之前
pub fn SolarDay::is_before(self : SolarDay, target : SolarDay) -> Bool {
  self.get_compare_index() < target.get_compare_index()
}

///|
// is_after 是否在指定公历日之后
pub fn SolarDay::is_after(self : SolarDay, target : SolarDay) -> Bool {
  self.get_compare_index() > target.get_compare_index()
}

///|
// subtract 公历日期相减，获得相差天数
pub fn SolarDay::subtract(self : SolarDay, target : SolarDay) -> Int {
  self.get_julian_day().subtract(target.get_julian_day()).to_int()
}

///|
// next 偏移 n 天
pub fn SolarDay::next(self : SolarDay, n : Int) -> SolarDay {
  self.get_julian_day().next(n).get_solar_day_unchecked()
}

///|
// get_term 节气
pub fn SolarDay::get_term(self : SolarDay) -> SolarTerm {
  self.get_term_day().get_solar_term()
}

///|
// get_term_day 节气第几天
pub fn SolarDay::get_term_day(self : SolarDay) -> SolarTermDay {
  let mut y = self.get_year()
  let mut i = self.get_month() * 2
  if i == 24 {
    y = y + 1
    i = 0
  }
  let mut term = SolarTerm::from_index(y, i + 1)
  let mut day = term.get_solar_day()
  while self.is_before(day) {
    term = term.next(-1)
    day = term.get_solar_day()
  }
  SolarTermDay::new(term, self.subtract(day))
}

///|
// get_phenology_day 七十二候
pub fn SolarDay::get_phenology_day(self : SolarDay) -> PhenologyDay {
  let d = self.get_term_day()
  let day_index = d.get_day_index()
  let mut index = day_index / 5
  if index > 2 {
    index = 2
  }
  let term = d.get_solar_term()
  PhenologyDay::new(
    Phenology::from_index(
      term.get_year(),
      term.loop_tyme.get_index() * 3 + index,
    ),
    day_index - index * 5,
  )
}

///|
// get_phenology 候
pub fn SolarDay::get_phenology(self : SolarDay) -> Phenology {
  self.get_phenology_day().get_phenology()
}

///|
// get_nine_day 数九天
pub fn SolarDay::get_nine_day(self : SolarDay) -> NineDay? {
  let mut start = SolarTerm::from_index(self.get_year() + 1, 0).get_solar_day()
  if self.is_before(start) {
    start = SolarTerm::from_index(self.get_year(), 0).get_solar_day()
  }
  let end = start.next(81)
  if self.is_before(start) || !self.is_before(end) {
    return None
  }
  let days = self.subtract(start)
  Some(NineDay::new(Nine::from_index(days / 9), days % 9))
}

///|
pub impl Culture for SolarDay with fn get_name(self : SolarDay) -> String {
  solar_day_names()[self.get_day() - 1]
}

///|
pub impl Show for SolarDay with fn to_string(self : SolarDay) -> String {
  self.get_solar_month().to_string() + self.get_name()
}
