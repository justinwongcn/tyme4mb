///|
// SolarWeek 公历周
pub struct SolarWeek {
  week_unit : WeekUnit
}

///|
extend SolarWeek with Culture::{get_name}

///|
// validate 校验
pub fn SolarWeek::validate(
  year : Int,
  month : Int,
  index : Int,
  start : Int,
) -> Result[Unit, String] {
  match WeekUnit::validate(year, month, index, start) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match SolarMonth::from_ym(year, month) {
    Err(e) => return Err(e)
    Ok(m) =>
      if index >= m.get_week_count(start) {
        return Err(
          "illegal solar week index: " +
          index.to_string() +
          " in month: " +
          m.to_string(),
        )
      }
  }
  Ok(())
}

///|
// from_ym 从年月索引与起始星期构造
pub fn SolarWeek::from_ym(
  year : Int,
  month : Int,
  index : Int,
  start : Int,
) -> Result[SolarWeek, String] {
  match SolarWeek::validate(year, month, index, start) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  Ok({
    week_unit: WeekUnit::new(
      MonthUnit::new(YearUnit::new(year), month),
      index,
      start,
    ),
  })
}

///|
// get_year 年
pub fn SolarWeek::get_year(self : SolarWeek) -> Int {
  self.week_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn SolarWeek::get_month(self : SolarWeek) -> Int {
  self.week_unit.month_unit.get_month()
}

///|
// get_index 索引，0-5
pub fn SolarWeek::get_index(self : SolarWeek) -> Int {
  self.week_unit.get_index()
}

///|
// get_start 起始星期
pub fn SolarWeek::get_start(self : SolarWeek) -> Week {
  self.week_unit.get_start()
}

///|
// get_solar_month 公历月
pub fn SolarWeek::get_solar_month(self : SolarWeek) -> SolarMonth {
  SolarMonth::new(self.week_unit.month_unit)
}

///|
// get_index_in_year 位于当年的索引(0-11)
pub fn SolarWeek::get_index_in_year(self : SolarWeek) -> Int {
  let mut i = 0
  let first_day = self.get_first_day()
  let mut w = SolarWeek::from_ym(self.get_year(), 1, 0, self.week_unit.start).unwrap()
  while !w.get_first_day().equals(first_day) {
    i = i + 1
    w = w.next(1)
  }
  i
}

///|
// get_first_day 本周第1天
pub fn SolarWeek::get_first_day(self : SolarWeek) -> SolarDay {
  let first_day = SolarDay::from_ymd(self.get_year(), self.get_month(), 1).unwrap()
  first_day.next(
    self.week_unit.get_index() * 7 -
    AbstractCulture::index_of(
      first_day.get_week().get_index() - self.week_unit.start,
      7,
    ),
  )
}

///|
// next 偏移n个周
pub fn SolarWeek::next(self : SolarWeek, n : Int) -> SolarWeek {
  let mut d = self.week_unit.get_index() + n
  let mut m = self.get_solar_month()
  if n > 0 {
    let mut week_count = m.get_week_count(self.week_unit.start)
    while d >= week_count {
      d = d - week_count
      m = m.next(1)
      if m.get_first_day().get_week().get_index() != self.week_unit.start {
        d = d + 1
      }
      week_count = m.get_week_count(self.week_unit.start)
    }
  } else if n < 0 {
    while d < 0 {
      if m.get_first_day().get_week().get_index() != self.week_unit.start {
        d = d - 1
      }
      m = m.next(-1)
      d = d + m.get_week_count(self.week_unit.start)
    }
  }
  SolarWeek::from_ym(m.get_year(), m.get_month(), d, self.week_unit.start).unwrap()
}

///|
// get_days 本周公历日列表
pub fn SolarWeek::get_days(self : SolarWeek) -> Array[SolarDay] {
  let d = self.get_first_day()
  let l : Array[SolarDay] = [d]
  for i = 1; i < 7; i = i + 1 {
    l.push(d.next(i))
  }
  l
}

///|
// equals 相等
pub fn SolarWeek::equals(self : SolarWeek, target : SolarWeek) -> Bool {
  self.get_first_day().equals(target.get_first_day())
}

///|
pub impl Culture for SolarWeek with fn get_name(self : SolarWeek) -> String {
  week_unit_names()[self.week_unit.get_index()]
}

///|
pub impl Show for SolarWeek with fn to_string(self : SolarWeek) -> String {
  self.get_solar_month().to_string() + self.get_name()
}
