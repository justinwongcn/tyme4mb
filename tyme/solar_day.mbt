// solar_day_names 公历日名称
///|
pub fn solar_day_names() -> Array[String] {
  ["1日", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日", "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日", "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日", "29日", "30日", "31日"]
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
  { day_unit }
}

///|
// validate 校验
pub fn SolarDay::validate(
  year : Int,
  month : Int,
  day : Int
) -> Result[Unit, String] {
  let mut illegal = day < 1
  if not(illegal) {
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
  day : Int
) -> Result[SolarDay, String] {
  match SolarDay::validate(year, month, day) {
    Ok(_) =>
      Ok(SolarDay::{
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
  JulianDay::from_ymdhms(self.get_year(), self.get_month(), self.get_day(), 0, 0, 0)
}

///|
// get_week 星期
pub fn SolarDay::get_week(self : SolarDay) -> Week {
  self.get_julian_day().get_week()
}

///|
// get_solar_week 公历周（参数 start：起始星期，1234560 分别代表星期一至星期天）
pub fn SolarDay::get_solar_week(self : SolarDay, start : Int) -> SolarWeek {
  let first = SolarDay::from_ymd(self.get_year(), self.get_month(), 1).unwrap()
  let x = first.get_week().next(-start).get_index()
  let week_index = (self.get_day() + x + 6) / 7 - 1
  SolarWeek::from_ym(self.get_year(), self.get_month(), week_index, start).unwrap()
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
  self.get_julian_day().next(n).get_solar_day()
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
    Phenology::from_index(term.get_year(), term.loop_tyme.get_index() * 3 + index),
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
pub fn SolarDay::get_nine_day(self : SolarDay) -> Option[NineDay] {
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
// hide_heaven_stem_day_data 人元司令分野数据表
// 对应 SolarDay.GetHideHeavenStemDay 内的字符串字面量，原样保留
fn hide_heaven_stem_day_data() -> String {
  "93705542220504xx1513904541632524533533105544806564xx7573304542018584xx95"
}

///|
// get_hide_heaven_stem_day 人元司令分野
pub fn SolarDay::get_hide_heaven_stem_day(self : SolarDay) -> HideHeavenStemDay {
  let day_counts = [3, 5, 7, 9, 10, 30]
  let mut term = self.get_term()
  if term.is_qi() {
    term = term.next(-1)
  }
  let mut day_index = self.subtract(term.get_solar_day())
  let start_index = (term.loop_tyme.get_index() - 1) * 3
  let data = hide_heaven_stem_day_data()
  let zero = '0'.to_int()
  let mut days = 0
  let mut heaven_stem_index = 0
  let mut type_index = 0
  while type_index < 3 {
    let i = type_index * 2
    let d = data.unsafe_charcode_at(start_index + i)
    let mut count = 0
    if d != 'x'.to_int() {
      heaven_stem_index = d - zero
      let day_count_index = data.unsafe_charcode_at(start_index + i + 1) - zero
      count = day_counts[day_count_index]
      days = days + count
    }
    if day_index <= days {
      day_index = day_index - (days - count)
      break
    }
    type_index = type_index + 1
  }
  let hide_heaven_stem_type = if type_index == 1 {
    Middle
  } else if type_index == 2 {
    Main
  } else {
    Residual
  }
  HideHeavenStemDay::new(
    HideHeavenStem::from_index(heaven_stem_index, hide_heaven_stem_type),
    day_index,
  )
}

// 注（部分功能优先 / 破除 SCC，2026-08-02 22:10 更新）：
// 已补译：validate / from_ymd / get_solar_month / to_string / equals / get_index_in_year / next
//   / get_term / get_term_day / get_phenology_day / get_phenology / get_nine_day
//   / get_hide_heaven_stem_day
// 仍延后的方法及其真实卡点：
//   （get_solar_week 早已实现于本文件上方，2026-08-03 复核移除陈旧条目）
//   （get_legal_holiday 已于 2026-08-03 随 LegalHoliday 译完回填）
//   （get_hijri_day 已于 2026-08-03 随 HijriDay 译完回填）
//   （get_rab_byung_day 已于 2026-08-03 随 RabByungDay 译完回填）
//   （get_lunar_day 已于 2026-08-03 随 LunarDay 译完回填）
//   （get_nine_star 已于 2026-08-03 随 LunarDay 译完回填）
//   （get_sixty_cycle_day 已于 2026-08-03 随 SixtyCycleDay 译完回填）
//   （get_dog_day / get_plum_rain_day / get_festival / get_phase_day / get_phase 已于 2026-08-03 随 Event 族 / SolarFestival / Phase / PhaseDay 译完回填）

///|
// get_sixty_cycle_day 干支日
pub fn SolarDay::get_sixty_cycle_day(self : SolarDay) -> SixtyCycleDay {
  SixtyCycleDay::from_solar_day(self)
}

///|
// get_festival 公历现代节日，如果当天不是公历现代节日，返回 None
pub fn SolarDay::get_festival(self : SolarDay) -> Option[SolarFestival] {
  SolarFestival::from_ymd(self.get_year(), self.get_month(), self.get_day())
}

///|
// get_phase_day 月相第几天
pub fn SolarDay::get_phase_day(self : SolarDay) -> PhaseDay {
  let month = self.get_lunar_day().get_lunar_month().next(1)
  let mut p = Phase::from_index(month.get_year(), month.get_month_with_leap(), 0)
  let mut d = p.get_solar_day()
  while d.is_after(self) {
    p = p.next(-1)
    d = p.get_solar_day()
  }
  PhaseDay::new(p, self.subtract(d))
}

///|
// get_phase 月相
pub fn SolarDay::get_phase(self : SolarDay) -> Phase {
  self.get_phase_day().get_phase()
}

///|
// get_dog_day 三伏天，如果当天不是三伏天，返回 None
pub fn SolarDay::get_dog_day(self : SolarDay) -> Option[DogDay] {
  // 初伏，夏至后第3个庚日
  let e = Event::builder().term_heaven_stem(12, 6, 20).build().unwrap()
  let d0 = match e.get_solar_day(self.get_year()) {
    None => return None
    Some(v) => v
  }
  // 中伏，夏至后第4个庚日
  let e = Event::builder().term_heaven_stem(12, 6, 30).build().unwrap()
  let d1 = match e.get_solar_day(self.get_year()) {
    None => return None
    Some(v) => v
  }
  // 末伏，立秋后第1个庚日
  let e = Event::builder().term_heaven_stem(15, 6, 0).build().unwrap()
  let d2 = match e.get_solar_day(self.get_year()) {
    None => return None
    Some(v) => v
  }
  if self.is_before(d0) || self.is_after(d2.next(9)) {
    return None
  }
  if not(self.is_before(d2)) {
    return Some(DogDay::new(Dog::from_index(2), self.subtract(d2)))
  }
  if self.is_before(d1) {
    return Some(DogDay::new(Dog::from_index(0), self.subtract(d0)))
  }
  Some(DogDay::new(Dog::from_index(1), self.subtract(d1)))
}

///|
// get_plum_rain_day 梅雨天，如果当天不是梅雨天，返回 None
pub fn SolarDay::get_plum_rain_day(self : SolarDay) -> Option[PlumRainDay] {
  // 入梅，芒种后第1个丙日
  let e = Event::builder().term_heaven_stem(11, 2, 0).build().unwrap()
  let start = match e.get_solar_day(self.get_year()) {
    None => return None
    Some(v) => v
  }
  // 出梅，小暑后第1个未日
  let e = Event::builder().term_earth_branch(13, 7, 0).build().unwrap()
  let end = match e.get_solar_day(self.get_year()) {
    None => return None
    Some(v) => v
  }
  if self.is_before(start) || self.is_after(end) {
    return None
  }
  if self.equals(end) {
    return Some(PlumRainDay::new(PlumRain::from_index(1), 0))
  }
  Some(PlumRainDay::new(PlumRain::from_index(0), self.subtract(start)))
}

///|
// get_lunar_day 农历日
pub fn SolarDay::get_lunar_day(self : SolarDay) -> LunarDay {
  let m = LunarMonth::from_ym(self.get_year(), self.get_month()).unwrap()
  let mut days = self.subtract(m.get_first_julian_day().get_solar_day())
  let mut mm = m
  while days < 0 {
    mm = mm.next(-1)
    days = days + mm.get_day_count()
  }
  match LunarDay::from_ymd(mm.get_year(), mm.get_month_with_leap(), days + 1) {
    Ok(d) => d
    Err(_) =>
      LunarDay::{
        day_unit: DayUnit::new(
          MonthUnit::new(YearUnit::new(mm.get_year()), mm.get_month()),
          days + 1,
        ),
      }
  }
}

///|
// get_nine_star 九星
pub fn SolarDay::get_nine_star(self : SolarDay) -> NineStar {
  let winter_solstice = SolarTerm::from_index(self.get_year(), 0).get_solar_day()
  let summer_solstice = SolarTerm::from_index(self.get_year(), 12).get_solar_day()
  let next_winter_solstice = SolarTerm::from_index(self.get_year() + 1, 0).get_solar_day()
  // 距冬至最近的甲子日
  let w = winter_solstice.next(
    winter_solstice.get_lunar_day().get_sixty_cycle().loop_tyme.steps_close_to(0),
  )
  // 距夏至最近的甲子日
  let s = summer_solstice.next(
    summer_solstice.get_lunar_day().get_sixty_cycle().loop_tyme.steps_close_to(0),
  )
  // 距下个冬至最近的甲子日
  let n = next_winter_solstice.next(
    next_winter_solstice.get_lunar_day().get_sixty_cycle().loop_tyme.steps_close_to(0),
  )
  // 43210012345678876543210012345
  //      w        s        n
  //     冬至     夏至      冬至
  if self.is_before(w) {
    return NineStar::from_index(w.subtract(self) - 1)
  }
  if self.is_before(s) {
    return NineStar::from_index(self.subtract(w))
  }
  if self.is_before(n) {
    return NineStar::from_index(n.subtract(self) - 1)
  }
  NineStar::from_index(self.subtract(n))
}

///|
// get_rab_byung_day 藏历日
pub fn SolarDay::get_rab_byung_day(
  self : SolarDay,
) -> Result[RabByungDay, String] {
  RabByungDay::from_solar_day(self)
}

///|
// get_hijri_day 回历日
pub fn SolarDay::get_hijri_day(self : SolarDay) -> HijriDay {
  let sd = SolarDay::from_ymd(622, 7, 16).unwrap()
  let mut d = self.subtract(sd)
  let z = AbstractCulture::floor_div(d, 10631)
  d = d - z * 10631
  let y = @math.floor((d.to_double() + 0.5) / 354.366).to_int()
  d = d - @math.floor(y.to_double() * 354.366 + 0.5).to_int()
  let m = @math.floor((d.to_double() + 0.11) / 29.51).to_int()
  d = d - @math.floor(m.to_double() * 29.5 + 0.5).to_int()
  match HijriDay::from_ymd(z * 30 + y + 1, m + 1, d + 1) {
    Ok(h) => h
    Err(_) =>
      HijriDay::new(
        DayUnit::new(
          MonthUnit::new(YearUnit::new(z * 30 + y + 1), m + 1),
          d + 1,
        ),
      )
  }
}

///|
pub fn SolarDay::get_legal_holiday(self : SolarDay) -> Option[LegalHoliday] {
  match LegalHoliday::from_ymd(self.get_year(), self.get_month(), self.get_day()) {
    Ok(h) => Some(h)
    Err(_) => None
  }
}

///|
impl Culture for SolarDay with get_name(self : SolarDay) -> String {
  solar_day_names()[self.get_day() - 1]
}

///|
impl Show for SolarDay with to_string(self : SolarDay) -> String {
  self.get_solar_month().to_string() + self.get_name()
}
