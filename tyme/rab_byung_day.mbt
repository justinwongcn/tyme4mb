///|
// rab_byung_day_names 藏历日名称
pub fn rab_byung_day_names() -> Array[String] {
  [
    "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八",
    "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六",
    "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四",
    "廿五", "廿六", "廿七", "廿八", "廿九", "三十",
  ]
}

///|
// RabByungDay 藏历日，仅支持藏历1950年十二月初一（公历1951年1月8日）至藏历2050年十二月三十（公历2051年2月11日）
pub struct RabByungDay {
  day_unit : DayUnit
  // 是否闰日
  leap : Bool
}

///|
extend RabByungDay with Culture::{get_name}

///|
extend RabByungDay with Show::{to_string}

///|
// validate 校验
pub fn RabByungDay::validate(
  year : Int,
  month : Int,
  day : Int,
) -> Result[Unit, String] {
  if day == 0 || day < -30 || day > 30 {
    return Err(
      "illegal day " +
      day.to_string() +
      " in %!s(int=" +
      month.to_string() +
      ")",
    )
  }
  let m = match RabByungMonth::from_ym(year, month) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let leap = day < 0
  let mut d = day
  if d < 0 {
    d = -d
  }
  let miss_days = m.get_miss_days()
  let leap_days = m.get_leap_days()
  if leap {
    if !arr_contains(leap_days, d) {
      return Err("illegal leap day " + d.to_string() + " in " + m.to_string())
    }
  } else if arr_contains(miss_days, d) {
    return Err("illegal day " + d.to_string() + " in " + m.to_string())
  }
  Ok(())
}

///|
// new 从年月日构造
pub fn RabByungDay::new(
  year : Int,
  month : Int,
  day : Int,
) -> Result[RabByungDay, String] {
  match RabByungDay::validate(year, month, day) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  let mut d = day
  if d < 0 {
    d = -d
  }
  Ok(RabByungDay::{
    day_unit: DayUnit::new(MonthUnit::new(YearUnit::new(year), month), d),
    leap: day < 0,
  })
}

///|
// from_ymd 从年月日构造
pub fn RabByungDay::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> Result[RabByungDay, String] {
  RabByungDay::new(year, month, day)
}

///|
// get_year 年
pub fn RabByungDay::get_year(self : RabByungDay) -> Int {
  self.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn RabByungDay::get_month(self : RabByungDay) -> Int {
  self.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn RabByungDay::get_day(self : RabByungDay) -> Int {
  self.day_unit.get_day()
}

///|
// from_solar_day 从公历日构造
pub fn RabByungDay::from_solar_day(
  solar_day : SolarDay,
) -> Result[RabByungDay, String] {
  let start = SolarDay::from_ymd(1951, 1, 8).unwrap()
  let mut days = solar_day.subtract(start)
  let mut m = match RabByungMonth::from_ym(1950, 12) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let mut count = m.get_day_count()
  while days >= count {
    days = days - count
    match m.next(1) {
      Ok(nm) => m = nm
      Err(e) => return Err(e)
    }
    count = m.get_day_count()
  }
  let mut day = days + 1
  let special = m.get_special_days()
  for i = 0; i < special.length(); i = i + 1 {
    let d = special[i]
    if d < 0 {
      if day >= -d {
        day = day + 1
      }
    } else if d > 0 {
      if day == d + 1 {
        day = -d
        break
      } else if day > d + 1 {
        day = day - 1
      }
    }
  }
  RabByungDay::new(m.get_year(), m.get_month_with_leap(), day)
}

///|
// get_rab_byung_month 藏历月
pub fn RabByungDay::get_rab_byung_month(self : RabByungDay) -> RabByungMonth {
  match RabByungMonth::from_ym(self.get_year(), self.get_month()) {
    Ok(m) => m
    Err(_) =>
      RabByungMonth::{
        month_unit: MonthUnit::new(
          YearUnit::new(self.get_year()),
          self.get_month(),
        ),
        leap: false,
      }
  }
}

///|
// is_leap 是否闰日
pub fn RabByungDay::is_leap(self : RabByungDay) -> Bool {
  self.leap
}

///|
// get_day_with_leap 带闰标记的日
pub fn RabByungDay::get_day_with_leap(self : RabByungDay) -> Int {
  if self.leap {
    return -self.get_day()
  }
  self.get_day()
}

///|
// subtract 相减
pub fn RabByungDay::subtract(self : RabByungDay, target : RabByungDay) -> Int {
  self.get_solar_day().subtract(target.get_solar_day())
}

///|
// get_solar_day 公历日
pub fn RabByungDay::get_solar_day(self : RabByungDay) -> SolarDay {
  let start = SolarDay::from_ymd(1951, 1, 7).unwrap()
  let mut m = RabByungMonth::from_ym(1950, 12).unwrap()
  let cm = self.get_rab_byung_month()
  let mut n = 0
  while !cm.equals(m) {
    n = n + m.get_day_count()
    m = m.next(1).unwrap()
  }
  let mut t = self.get_day()
  let special = m.get_special_days()
  for i = 0; i < special.length(); i = i + 1 {
    let sd = special[i]
    if sd < 0 {
      if t > -sd {
        t = t - 1
      }
    } else if sd > 0 {
      if t > sd {
        t = t + 1
      }
    }
  }
  if self.leap {
    t = t + 1
  }
  start.next(n + t)
}

///|
// next 推移
pub fn RabByungDay::next(
  self : RabByungDay,
  n : Int,
) -> Result[RabByungDay, String] {
  RabByungDay::from_solar_day(self.get_solar_day().next(n))
}

///|
// equals 是否相等
pub fn RabByungDay::equals(self : RabByungDay, target : RabByungDay) -> Bool {
  self.to_string() == target.to_string()
}

///|
impl Culture for RabByungDay with fn get_name(self : RabByungDay) -> String {
  let name = rab_byung_day_names()[self.get_day() - 1]
  if self.leap {
    return "闰" + name
  }
  name
}

///|
impl Show for RabByungDay with fn to_string(self : RabByungDay) -> String {
  self.get_rab_byung_month().to_string() + self.get_name()
}
