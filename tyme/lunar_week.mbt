///|
// LunarWeek 农历周
pub struct LunarWeek {
  week_unit : WeekUnit
}

///|
extend LunarWeek with Culture::{get_name}

///|
extend LunarWeek with Show::{to_string}

///|
// validate 校验
pub fn LunarWeek::validate(
  year : Int,
  month : Int,
  index : Int,
  start : Int
) -> Result[Unit, String] {
  match WeekUnit::validate(year, month, index, start) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match LunarMonth::from_ym(year, month) {
    Err(e) => return Err(e)
    Ok(m) =>
      if index >= m.get_week_count(start) {
        return Err(
          "illegal lunar week index: " + index.to_string() + " in month: " + m.to_string(),
        )
      }
  }
  Ok(())
}

///|
// from_ym 从年月索引与起始星期构造
pub fn LunarWeek::from_ym(
  year : Int,
  month : Int,
  index : Int,
  start : Int
) -> Result[LunarWeek, String] {
  match LunarWeek::validate(year, month, index, start) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  Ok(
    LunarWeek::{
      week_unit : WeekUnit::new(
        MonthUnit::new(YearUnit::new(year), month),
        index,
        start,
      ),
    },
  )
}

///|
// get_year 年
pub fn LunarWeek::get_year(self : LunarWeek) -> Int {
  self.week_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn LunarWeek::get_month(self : LunarWeek) -> Int {
  self.week_unit.month_unit.get_month()
}

///|
// get_index 索引，0-5
pub fn LunarWeek::get_index(self : LunarWeek) -> Int {
  self.week_unit.get_index()
}

///|
// get_start 起始星期
pub fn LunarWeek::get_start(self : LunarWeek) -> Week {
  self.week_unit.get_start()
}

///|
// get_lunar_month 农历月
pub fn LunarWeek::get_lunar_month(self : LunarWeek) -> LunarMonth {
  LunarMonth::from_ym(self.get_year(), self.get_month()).unwrap()
}

///|
impl Culture for LunarWeek with get_name(self : LunarWeek) -> String {
  week_unit_names()[self.week_unit.index]
}

///|
impl Show for LunarWeek with to_string(self : LunarWeek) -> String {
  self.get_lunar_month().to_string() + self.get_name()
}

///|
// get_first_day 本周第1天
pub fn LunarWeek::get_first_day(self : LunarWeek) -> LunarDay {
  let first_day = LunarDay::from_ymd(self.get_year(), self.get_month(), 1).unwrap()
  first_day.next(
    self.week_unit.index * 7 -
    AbstractCulture::index_of(first_day.get_week().loop_tyme.get_index() - self.week_unit.start, 7),
  )
}

///|
// next 推移
pub fn LunarWeek::next(self : LunarWeek, n : Int) -> LunarWeek {
  let mut d = self.week_unit.index + n
  let mut m = self.get_lunar_month()
  if n > 0 {
    let mut week_count = m.get_week_count(self.week_unit.start)
    while d >= week_count {
      d = d - week_count
      m = m.next(1)
      if m.get_first_day().get_week().loop_tyme.index != self.week_unit.start {
        d = d + 1
      }
      week_count = m.get_week_count(self.week_unit.start)
    }
  } else if n < 0 {
    while d < 0 {
      if m.get_first_day().get_week().loop_tyme.index != self.week_unit.start {
        d = d - 1
      }
      m = m.next(-1)
      d = d + m.get_week_count(self.week_unit.start)
    }
  }
  LunarWeek::from_ym(m.get_year(), m.get_month_with_leap(), d, self.week_unit.start).unwrap()
}

///|
// get_days 本周农历日列表
pub fn LunarWeek::get_days(self : LunarWeek) -> Array[LunarDay] {
  let l : Array[LunarDay] = []
  let d = self.get_first_day()
  l.push(d)
  for i = 1; i < 7; i = i + 1 {
    l.push(d.next(i))
  }
  l
}

///|
// equals 是否相等
pub fn LunarWeek::equals(self : LunarWeek, target : LunarWeek) -> Bool {
  self.get_first_day().equals(target.get_first_day())
}
