// SolarDay cross-domain calendar conversions and observances

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
    let d = data.unsafe_get(start_index + i).to_int()
    let mut count = 0
    if d != 'x'.to_int() {
      heaven_stem_index = d - zero
      let day_count_index = data.unsafe_get(start_index + i + 1).to_int() - zero
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

///|
// get_sixty_cycle_day 干支日
pub fn SolarDay::get_sixty_cycle_day(self : SolarDay) -> SixtyCycleDay {
  SixtyCycleDay::from_solar_day(self)
}

///|
// get_festival 公历现代节日，如果当天不是公历现代节日，返回 None
pub fn SolarDay::get_festival(self : SolarDay) -> SolarFestival? {
  SolarFestival::from_ymd(self.get_year(), self.get_month(), self.get_day())
}

///|
// get_phase_day 月相第几天
pub fn SolarDay::get_phase_day(self : SolarDay) -> PhaseDay {
  let month = self.get_lunar_day().get_lunar_month().next(1)
  let mut p = Phase::from_index(
    month.get_year(),
    month.get_month_with_leap(),
    0,
  )
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
pub fn SolarDay::get_dog_day(self : SolarDay) -> DogDay? {
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
  if !self.is_before(d2) {
    return Some(DogDay::new(Dog::from_index(2), self.subtract(d2)))
  }
  if self.is_before(d1) {
    return Some(DogDay::new(Dog::from_index(0), self.subtract(d0)))
  }
  Some(DogDay::new(Dog::from_index(1), self.subtract(d1)))
}

///|
// get_plum_rain_day 梅雨天，如果当天不是梅雨天，返回 None
pub fn SolarDay::get_plum_rain_day(self : SolarDay) -> PlumRainDay? {
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
  let mut days = self.subtract(
    m.get_first_julian_day().get_solar_day_unchecked(),
  )
  let mut mm = m
  while days < 0 {
    mm = mm.next(-1)
    days = days + mm.get_day_count()
  }
  match LunarDay::from_ymd(mm.get_year(), mm.get_month_with_leap(), days + 1) {
    Ok(d) => d
    Err(_) =>
      {
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
    winter_solstice.get_lunar_day().get_sixty_cycle().steps_close_to(0),
  )
  // 距夏至最近的甲子日
  let s = summer_solstice.next(
    summer_solstice.get_lunar_day().get_sixty_cycle().steps_close_to(0),
  )
  // 距下个冬至最近的甲子日
  let n = next_winter_solstice.next(
    next_winter_solstice.get_lunar_day().get_sixty_cycle().steps_close_to(0),
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
pub fn SolarDay::get_legal_holiday(self : SolarDay) -> LegalHoliday? {
  match
    LegalHoliday::from_ymd(self.get_year(), self.get_month(), self.get_day()) {
    Ok(h) => Some(h)
    Err(_) => None
  }
}
