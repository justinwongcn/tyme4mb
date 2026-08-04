///|
// LunarHour 农历时辰
pub struct LunarHour {
  second_unit : SecondUnit
}

///|
extend LunarHour with Culture::{get_name}

///|
extend LunarHour with Show::{to_string}

///|
extend LunarHour with Tyme::{next}

///|
// validate 校验
pub fn LunarHour::validate(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[Unit, String] {
  match SecondUnit::validate(year, month, day, hour, minute, second) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  LunarDay::validate(year, month, day)
}

///|
// from_ymd_hms 从年月日时分秒构造
pub fn LunarHour::from_ymd_hms(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[LunarHour, String] {
  match LunarHour::validate(year, month, day, hour, minute, second) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  Ok(LunarHour::{
    second_unit: SecondUnit::new(
      DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
      hour,
      minute,
      second,
    ),
  })
}

///|
// get_year 年
pub fn LunarHour::get_year(self : LunarHour) -> Int {
  self.second_unit.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn LunarHour::get_month(self : LunarHour) -> Int {
  self.second_unit.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn LunarHour::get_day(self : LunarHour) -> Int {
  self.second_unit.day_unit.get_day()
}

///|
// get_hour 时
pub fn LunarHour::get_hour(self : LunarHour) -> Int {
  self.second_unit.hour
}

///|
// get_minute 分
pub fn LunarHour::get_minute(self : LunarHour) -> Int {
  self.second_unit.minute
}

///|
// get_second 秒
pub fn LunarHour::get_second(self : LunarHour) -> Int {
  self.second_unit.second
}

///|
// get_lunar_day 农历日
pub fn LunarHour::get_lunar_day(self : LunarHour) -> LunarDay {
  match LunarDay::from_ymd(self.get_year(), self.get_month(), self.get_day()) {
    Ok(d) => d
    Err(_) =>
      LunarDay::{
        day_unit: DayUnit::new(
          MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
          self.get_day(),
        ),
      }
  }
}

///|
// get_index_in_day 位于当天的索引
pub fn LunarHour::get_index_in_day(self : LunarHour) -> Int {
  (self.second_unit.hour + 1) / 2
}

///|
// get_compare_index 用于比较大小的索引
pub fn LunarHour::get_compare_index(self : LunarHour) -> Int64 {
  self.second_unit.get_compare_index()
}

///|
// is_before 是否在指定农历时辰之前
pub fn LunarHour::is_before(self : LunarHour, target : LunarHour) -> Bool {
  self.get_compare_index() < target.get_compare_index()
}

///|
// is_after 是否在指定农历时辰之后
pub fn LunarHour::is_after(self : LunarHour, target : LunarHour) -> Bool {
  self.get_compare_index() > target.get_compare_index()
}

///|
// get_sixty_cycle 干支
pub fn LunarHour::get_sixty_cycle(self : LunarHour) -> SixtyCycle {
  let earth_branch_index = self.get_index_in_day() % 12
  let mut d = self.get_lunar_day().get_sixty_cycle()
  if self.second_unit.hour >= 23 {
    d = d.next(1)
  }
  let name = HeavenStem::from_index(
      d.get_heaven_stem().get_index() % 5 * 2 + earth_branch_index,
    ).get_name() +
    EarthBranch::from_index(earth_branch_index).get_name()
  SixtyCycle::from_name(name).unwrap()
}

///|
// get_twelve_star 黄道黑道十二神
pub fn LunarHour::get_twelve_star(self : LunarHour) -> TwelveStar {
  TwelveStar::from_index(
    self.get_sixty_cycle().get_earth_branch().get_index() +
    (
      8 -
      self.get_sixty_cycle_hour().get_day().get_earth_branch().get_index() % 6
    ) *
    2,
  )
}

///|
// get_nine_star 九星
pub fn LunarHour::get_nine_star(self : LunarHour) -> NineStar {
  let d = self.get_lunar_day()
  let solar = d.get_solar_day()
  let dong_zhi = SolarTerm::from_index(solar.get_year(), 0)
  let earth_branch_index = self.get_index_in_day() % 12
  let mut index = 8 -
    3 * (d.get_sixty_cycle().get_earth_branch().get_index() % 3)
  if !solar.is_before(dong_zhi.get_julian_day().get_solar_day()) &&
    solar.is_before(dong_zhi.next(12).get_julian_day().get_solar_day()) {
    index = 8 + earth_branch_index - index
  } else {
    index = index - earth_branch_index
  }
  NineStar::from_index(index)
}

///|
// get_solar_time 公历时刻
pub fn LunarHour::get_solar_time(self : LunarHour) -> SolarTime {
  let d = self.get_lunar_day().get_solar_day()
  SolarTime::from_ymdhms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    self.second_unit.hour,
    self.second_unit.minute,
    self.second_unit.second,
  ).unwrap()
}

///|
// get_sixty_cycle_hour 干支时辰
pub fn LunarHour::get_sixty_cycle_hour(self : LunarHour) -> SixtyCycleHour {
  self.get_solar_time().get_sixty_cycle_hour()
}

///|
// get_year_sixty_cycle 年干支（已标记 Deprecated）
pub fn LunarHour::get_year_sixty_cycle(self : LunarHour) -> SixtyCycle {
  self.get_sixty_cycle_hour().get_year()
}

///|
// get_month_sixty_cycle 月干支（已标记 Deprecated）
pub fn LunarHour::get_month_sixty_cycle(self : LunarHour) -> SixtyCycle {
  self.get_sixty_cycle_hour().get_month()
}

///|
// get_day_sixty_cycle 日干支（已标记 Deprecated）
pub fn LunarHour::get_day_sixty_cycle(self : LunarHour) -> SixtyCycle {
  self.get_sixty_cycle_hour().get_day()
}

///|
// get_recommends 宜
pub fn LunarHour::get_recommends(
  self : LunarHour,
) -> Result[Array[Taboo], String] {
  Taboo::get_hour_recommends(
    self.get_sixty_cycle_hour().get_day(),
    self.get_sixty_cycle(),
  )
}

///|
// get_avoids 忌
pub fn LunarHour::get_avoids(self : LunarHour) -> Result[Array[Taboo], String] {
  Taboo::get_hour_avoids(
    self.get_sixty_cycle_hour().get_day(),
    self.get_sixty_cycle(),
  )
}

///|
// get_minor_ren 小六壬
pub fn LunarHour::get_minor_ren(self : LunarHour) -> MinorRen {
  self.get_lunar_day().get_minor_ren().next(self.get_index_in_day())
}

///|
// get_eight_char 八字
pub fn LunarHour::get_eight_char(self : LunarHour) -> EightChar {
  eight_char_provider.get_eight_char(self)
}

///|
impl Culture for LunarHour with fn get_name(self : LunarHour) -> String {
  "\{EarthBranch::from_index(self.get_index_in_day()).get_name()}时"
}

///|
impl Show for LunarHour with fn to_string(self : LunarHour) -> String {
  self.get_lunar_day().to_string() + self.get_sixty_cycle().get_name() + "时"
}

///|
impl Tyme for LunarHour with fn next(self : LunarHour, n : Int) -> LunarHour {
  if n == 0 {
    return LunarHour::from_ymd_hms(
      self.get_year(),
      self.get_month(),
      self.get_day(),
      self.second_unit.hour,
      self.second_unit.minute,
      self.second_unit.second,
    ).unwrap()
  }
  let h = self.second_unit.hour + n * 2
  let d = self.get_lunar_day().next(AbstractCulture::floor_div(h, 24))
  LunarHour::from_ymd_hms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    AbstractCulture::index_of(h, 24),
    self.second_unit.minute,
    self.second_unit.second,
  ).unwrap()
}

///|
// equals 是否相等
pub fn LunarHour::equals(self : LunarHour, target : LunarHour) -> Bool {
  self.to_string() == target.to_string()
}
