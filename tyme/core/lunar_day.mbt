///|
// lunar_day_names 农历日名称
pub fn lunar_day_names() -> Array[String] {
  [
    "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八",
    "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六",
    "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四",
    "廿五", "廿六", "廿七", "廿八", "廿九", "三十",
  ]
}

///|
// LunarDay 农历日
pub struct LunarDay {
  day_unit : DayUnit
}

///|
extend LunarDay with Culture::{get_name}

///|
extend LunarDay with Show::{to_string}

///|
extend LunarDay with Tyme::{next}

///|
// validate 校验
pub fn LunarDay::validate(
  year : Int,
  month : Int,
  day : Int,
) -> Result[Unit, String] {
  if day < 1 {
    return Err("illegal lunar day: " + day.to_string())
  }
  let m = match LunarMonth::from_ym(year, month) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if day > m.get_day_count() {
    return Err("illegal day " + day.to_string() + " in " + m.to_string())
  }
  Ok(())
}

///|
// from_ymd 从年月日构造
pub fn LunarDay::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> Result[LunarDay, String] {
  match LunarDay::validate(year, month, day) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  Ok({
    day_unit: DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
  })
}

///|
// get_year 年
pub fn LunarDay::get_year(self : LunarDay) -> Int {
  self.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn LunarDay::get_month(self : LunarDay) -> Int {
  self.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn LunarDay::get_day(self : LunarDay) -> Int {
  self.day_unit.get_day()
}

///|
// get_lunar_month 农历月
pub fn LunarDay::get_lunar_month(self : LunarDay) -> LunarMonth {
  match LunarMonth::from_ym(self.get_year(), self.get_month()) {
    Ok(m) => m
    Err(_) =>
      {
        month_unit: MonthUnit::new(
          YearUnit::new(self.get_year()),
          self.get_month(),
        ),
        leap: false,
      }
  }
}

///|
// get_week 星期
pub fn LunarDay::get_week(self : LunarDay) -> Week {
  self.get_solar_day().get_week()
}

///|
// get_sixty_cycle 干支
pub fn LunarDay::get_sixty_cycle(self : LunarDay) -> SixtyCycle {
  SixtyCycle::from_index(
    self
    .get_lunar_month()
    .get_first_julian_day()
    .next(self.get_day() - 12)
    .get_day()
    .to_int(),
  )
}

///|
// get_nine_star 九星
pub fn LunarDay::get_nine_star(self : LunarDay) -> NineStar {
  self.get_solar_day().get_nine_star()
}

///|
// get_jupiter_direction 太岁方位
pub fn LunarDay::get_jupiter_direction(self : LunarDay) -> Direction {
  let index = self.get_sixty_cycle().get_index()
  if index % 12 < 6 {
    return Element::from_index(index / 12).get_direction()
  }
  self.get_lunar_month().get_lunar_year().get_jupiter_direction()
}

///|
// get_six_star 六曜
pub fn LunarDay::get_six_star(self : LunarDay) -> SixStar {
  let mut m = self.get_month()
  if m < 0 {
    m = -m
  }
  SixStar::from_index((m + self.get_day() - 2) % 6)
}

///|
// get_solar_day 公历日
pub fn LunarDay::get_solar_day(self : LunarDay) -> SolarDay {
  self
  .get_lunar_month()
  .get_first_julian_day()
  .next(self.get_day() - 1)
  .get_solar_day_unchecked()
}

///|
// get_twenty_eight_star 二十八宿
pub fn LunarDay::get_twenty_eight_star(self : LunarDay) -> TwentyEightStar {
  let arr = [10, 18, 26, 6, 14, 22, 2]
  TwentyEightStar::from_index(arr[self.get_solar_day().get_week().get_index()]).next(
    -7 * self.get_sixty_cycle().get_earth_branch().get_index(),
  )
}

///|
// get_minor_ren 小六壬
pub fn LunarDay::get_minor_ren(self : LunarDay) -> MinorRen {
  self.get_lunar_month().get_minor_ren().next(self.get_day() - 1)
}

///|
// is_before 是否在指定农历日之前
pub fn LunarDay::is_before(self : LunarDay, target : LunarDay) -> Bool {
  self.day_unit.get_compare_index() < target.day_unit.get_compare_index()
}

///|
// is_after 是否在指定农历日之后
pub fn LunarDay::is_after(self : LunarDay, target : LunarDay) -> Bool {
  self.day_unit.get_compare_index() > target.day_unit.get_compare_index()
}

///|
// equals 是否相等
pub fn LunarDay::equals(self : LunarDay, target : LunarDay) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year_sixty_cycle 年干支（已标记 Deprecated，2026-08-03 随 SixtyCycleDay 回填）
pub fn LunarDay::get_year_sixty_cycle(self : LunarDay) -> SixtyCycle {
  self.get_sixty_cycle_day().get_year()
}

///|
// get_month_sixty_cycle 月干支（已标记 Deprecated）
pub fn LunarDay::get_month_sixty_cycle(self : LunarDay) -> SixtyCycle {
  self.get_sixty_cycle_day().get_month()
}

///|
// get_duty 建除十二值神
pub fn LunarDay::get_duty(self : LunarDay) -> Duty {
  self.get_sixty_cycle_day().get_duty()
}

///|
// get_twelve_star 黄道黑道十二神
pub fn LunarDay::get_twelve_star(self : LunarDay) -> TwelveStar {
  self.get_sixty_cycle_day().get_twelve_star()
}

///|
// get_fetus_day 逐日胎神
pub fn LunarDay::get_fetus_day(self : LunarDay) -> FetusDay {
  FetusDay::from_lunar_day(self)
}

///|
// get_phase_day 月相第几天
pub fn LunarDay::get_phase_day(self : LunarDay) -> PhaseDay {
  let today = self.get_solar_day()
  let m = self.get_lunar_month().next(1)
  let mut p = Phase::from_index(m.get_year(), m.get_month_with_leap(), 0)
  let mut d = p.get_solar_day()
  while d.is_after(today) {
    p = p.next(-1)
    d = p.get_solar_day()
  }
  PhaseDay::new(p, today.subtract(d))
}

///|
// get_phase 月相
pub fn LunarDay::get_phase(self : LunarDay) -> Phase {
  self.get_phase_day().get_phase()
}

///|
// get_sixty_cycle_day 干支日
pub fn LunarDay::get_sixty_cycle_day(self : LunarDay) -> SixtyCycleDay {
  self.get_solar_day().get_sixty_cycle_day()
}

///|
// get_festival 农历传统节日，如果当天不是农历传统节日，返回 None
pub fn LunarDay::get_festival(self : LunarDay) -> LunarFestival? {
  LunarFestival::from_ymd(self.get_year(), self.get_month(), self.get_day())
}

///|
// get_hours 当天的农历时辰列表
pub fn LunarDay::get_hours(self : LunarDay) -> Array[LunarHour] {
  let l : Array[LunarHour] = []
  let t = LunarHour::from_ymd_hms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    0,
    0,
    0,
  ).unwrap()
  l.push(t)
  for i = 0; i < 24; i = i + 2 {
    l.push(
      LunarHour::from_ymd_hms(
        self.get_year(),
        self.get_month(),
        self.get_day(),
        i + 1,
        0,
        0,
      ).unwrap(),
    )
  }
  l
}

///|
// get_gods 神煞列表(吉神宜趋，凶神宜忌)
pub fn LunarDay::get_gods(self : LunarDay) -> Result[Array[God], String] {
  self.get_sixty_cycle_day().get_gods()
}

///|
// get_recommends 宜
pub fn LunarDay::get_recommends(
  self : LunarDay,
) -> Result[Array[Taboo], String] {
  self.get_sixty_cycle_day().get_recommends()
}

///|
// get_avoids 忌
pub fn LunarDay::get_avoids(self : LunarDay) -> Result[Array[Taboo], String] {
  self.get_sixty_cycle_day().get_avoids()
}

///|
// get_three_pillars 三柱
pub fn LunarDay::get_three_pillars(self : LunarDay) -> ThreePillars {
  self.get_sixty_cycle_day().get_three_pillars()
}

///|
pub impl Culture for LunarDay with fn get_name(self : LunarDay) -> String {
  lunar_day_names()[self.get_day() - 1]
}

///|
pub impl Show for LunarDay with fn to_string(self : LunarDay) -> String {
  self.get_lunar_month().to_string() + self.get_name()
}

///|
pub impl Tyme for LunarDay with fn next(self : LunarDay, n : Int) -> LunarDay {
  self.get_solar_day().next(n).get_lunar_day()
}
