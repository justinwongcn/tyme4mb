///|
// lunar_month_names 农历月名称
pub fn lunar_month_names() -> Array[String] {
  [
    "正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
    "九月", "十月", "十一月", "十二月",
  ]
}

///|
// LunarMonth 农历月
pub struct LunarMonth {
  month_unit : MonthUnit
  // 是否闰月
  leap : Bool
}

///|
extend LunarMonth with Culture::{get_name}

///|
extend LunarMonth with Show::{to_string}

///|
extend LunarMonth with Tyme::{next}

///|
// validate 校验
pub fn LunarMonth::validate(year : Int, month : Int) -> Result[Unit, String] {
  if month == 0 || month > 12 || month < -12 {
    return Err("illegal lunar month: " + month.to_string())
  }
  if month < 0 {
    let y = match LunarYear::from_year(year) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if -month != y.get_leap_month() {
      return Err("illegal leap month \{-month} in lunar year \{year}")
    }
  }
  Ok(())
}

///|
// from_ym 从年月构造
pub fn LunarMonth::from_ym(
  year : Int,
  month : Int,
) -> Result[LunarMonth, String] {
  match LunarMonth::validate(year, month) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  let mut m = month
  let mut leap = false
  if m < 0 {
    leap = true
    m = -m
  }
  Ok({ month_unit: MonthUnit::new(YearUnit::new(year), m), leap })
}

///|
// get_year 年
pub fn LunarMonth::get_year(self : LunarMonth) -> Int {
  self.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn LunarMonth::get_month(self : LunarMonth) -> Int {
  self.month_unit.get_month()
}

///|
// get_lunar_year 农历年
pub fn LunarMonth::get_lunar_year(self : LunarMonth) -> LunarYear {
  match LunarYear::from_year(self.get_year()) {
    Ok(y) => y
    Err(_) => { year_unit: YearUnit::new(self.get_year()) }
  }
}

///|
// get_month_with_leap 月，当月为闰月时，返回负数
pub fn LunarMonth::get_month_with_leap(self : LunarMonth) -> Int {
  if self.leap {
    return -self.get_month()
  }
  self.get_month()
}

///|
// get_new_moon 朔
fn LunarMonth::get_new_moon(self : LunarMonth) -> Double {
  // 冬至
  let dong_zhi_jd = SolarTerm::from_index(self.get_year(), 0).get_cursory_julian_day()
  // 冬至前的初一，今年首朔的日月黄经差
  let mut w = calc_shuo(dong_zhi_jd)
  if w > dong_zhi_jd {
    w = w - 29.53
  }
  // 正常情况正月初一为第3个朔日，但有些特殊的
  let mut offset = 2
  if self.get_year() > 8 && self.get_year() < 24 {
    offset = 1
  } else if self.get_year() != 239 && self.get_year() != 240 {
    let y = LunarYear::from_year(self.get_year() - 1).unwrap()
    if y.get_leap_month() > 10 {
      offset = 3
    }
  }
  // 本月初一
  w + 29.5306 * (offset + self.get_index_in_year()).to_double()
}

///|
// get_day_count 天数(大月30天，小月29天)
pub fn LunarMonth::get_day_count(self : LunarMonth) -> Int {
  let w = self.get_new_moon()
  (calc_shuo(w + 29.5306) - calc_shuo(w)).to_int()
}

///|
// get_index_in_year 位于当年的索引(0-12)
pub fn LunarMonth::get_index_in_year(self : LunarMonth) -> Int {
  let mut index = self.get_month() - 1
  if self.leap {
    index = index + 1
  } else {
    let leap_month = self.get_lunar_year().get_leap_month()
    if leap_month > 0 && self.get_month() > leap_month {
      index = index + 1
    }
  }
  index
}

///|
// get_season 农历季节
pub fn LunarMonth::get_season(self : LunarMonth) -> LunarSeason {
  LunarSeason::from_index(self.get_month() - 1)
}

///|
// get_first_julian_day 初一的儒略日
pub fn LunarMonth::get_first_julian_day(self : LunarMonth) -> JulianDay {
  JulianDay::from_julian_day(J2000.to_double() + calc_shuo(self.get_new_moon()))
}

///|
// is_leap 是否闰月
pub fn LunarMonth::is_leap(self : LunarMonth) -> Bool {
  self.leap
}

///|
// get_week_count 周数
pub fn LunarMonth::get_week_count(self : LunarMonth, start : Int) -> Int {
  (
    AbstractCulture::index_of(
      self.get_first_julian_day().get_week().get_index() - start,
      7,
    ) +
    self.get_day_count() +
    6
  ) /
  7
}

///|
// get_sixty_cycle 干支
pub fn LunarMonth::get_sixty_cycle(self : LunarMonth) -> SixtyCycle {
  SixtyCycle::from_index(self.get_year() * 12 + self.get_month() - 47)
}

///|
// get_nine_star 九星
pub fn LunarMonth::get_nine_star(self : LunarMonth) -> NineStar {
  let mut index = self.get_sixty_cycle().get_earth_branch().get_index()
  if index < 2 {
    index = index + 3
  }
  NineStar::from_index(
    27 -
    self.get_lunar_year().get_sixty_cycle().get_earth_branch().get_index() %
    3 *
    3 -
    index,
  )
}

///|
// get_jupiter_direction 太岁方位
pub fn LunarMonth::get_jupiter_direction(self : LunarMonth) -> Direction {
  let sixty_cycle = self.get_sixty_cycle()
  let n = [7, -1, 1, 3][sixty_cycle.get_earth_branch().next(-2).get_index() % 4]
  if n != -1 {
    return Direction::from_index(n)
  }
  sixty_cycle.get_heaven_stem().get_direction()
}

///|
// get_minor_ren 小六壬
pub fn LunarMonth::get_minor_ren(self : LunarMonth) -> MinorRen {
  MinorRen::from_index((self.get_month() - 1) % 6)
}

///|
// get_fetus 逐月胎神，闰月无逐月胎神
pub fn LunarMonth::get_fetus(self : LunarMonth) -> FetusMonth? {
  FetusMonth::from_lunar_month(self)
}

///|
// get_weeks 本月的农历周列表
pub fn LunarMonth::get_weeks(
  self : LunarMonth,
  start : Int,
) -> Array[LunarWeek] {
  let l : Array[LunarWeek] = []
  let size = self.get_week_count(start)
  let m = self.get_month_with_leap()
  for i = 0; i < size; i = i + 1 {
    l.push(LunarWeek::from_ym(self.get_year(), m, i, start).unwrap())
  }
  l
}

///|
// next 推移
pub impl Tyme for LunarMonth with fn next(self : LunarMonth, n : Int) -> LunarMonth {
  if n == 0 {
    return match
      LunarMonth::from_ym(self.get_year(), self.get_month_with_leap()) {
      Ok(m) => m
      Err(_) => self
    }
  }
  let mut m = self.get_index_in_year() + 1 + n
  let mut y = self.get_lunar_year()
  if n > 0 {
    let mut month_count = y.get_month_count()
    while m > month_count {
      m = m - month_count
      y = y.next(1)
      month_count = y.get_month_count()
    }
  } else {
    while m <= 0 {
      y = y.next(-1)
      m = m + y.get_month_count()
    }
  }
  let mut leap = false
  let leap_month = y.get_leap_month()
  if leap_month > 0 {
    if m == leap_month + 1 {
      leap = true
    }
    if m > leap_month {
      m = m - 1
    }
  }
  if leap {
    m = -m
  }
  match LunarMonth::from_ym(y.get_year(), m) {
    Ok(month) => month
    Err(_) => self
  }
}

///|
// get_days 本月的农历日列表
pub fn LunarMonth::get_days(self : LunarMonth) -> Array[LunarDay] {
  let l : Array[LunarDay] = []
  let size = self.get_day_count()
  let m = self.get_month_with_leap()
  for i = 0; i < size; i = i + 1 {
    match LunarDay::from_ymd(self.get_year(), m, i + 1) {
      Ok(d) => l.push(d)
      Err(_) => ()
    }
  }
  l
}

///|
// get_first_day 初一
pub fn LunarMonth::get_first_day(self : LunarMonth) -> LunarDay {
  match LunarDay::from_ymd(self.get_year(), self.get_month_with_leap(), 1) {
    Ok(d) => d
    Err(_) =>
      {
        day_unit: DayUnit::new(
          MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
          1,
        ),
      }
  }
}

///|
pub impl Culture for LunarMonth with fn get_name(self : LunarMonth) -> String {
  let s = lunar_month_names()[self.get_month() - 1]
  if self.leap {
    return "闰" + s
  }
  s
}

///|
pub impl Show for LunarMonth with fn to_string(self : LunarMonth) -> String {
  self.get_lunar_year().to_string() + self.get_name()
}
