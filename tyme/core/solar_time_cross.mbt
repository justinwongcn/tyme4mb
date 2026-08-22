// SolarTime cross-domain calendar conversions

///|
// get_term 节气
pub fn SolarTime::get_term(self : SolarTime) -> SolarTerm {
  let mut term = self.get_solar_day().get_term()
  if self.is_before(term.get_julian_day().get_solar_time_unchecked()) {
    term = term.next(-1)
  }
  term
}

///|
// get_phenology 候
pub fn SolarTime::get_phenology(self : SolarTime) -> Phenology {
  let mut p = self.get_solar_day().get_phenology()
  if self.is_before(p.get_julian_day().get_solar_time_unchecked()) {
    p = p.next(-1)
  }
  p
}

///|
// get_phase 月相（先经农历时辰→农历日→农历月，取次月首朔推算）
pub fn SolarTime::get_phase(self : SolarTime) -> Phase {
  let month = self.get_lunar_hour().get_lunar_day().get_lunar_month().next(1)
  let mut p = Phase::from_index(
    month.get_year(),
    month.get_month_with_leap(),
    0,
  )
  while p.get_solar_time().is_after(self) {
    p = p.next(-1)
  }
  p
}

///|
// get_lunar_hour 农历时辰（先经 GetSolarDay().GetLunarDay() 做公历→农历转换）
pub fn SolarTime::get_lunar_hour(self : SolarTime) -> LunarHour {
  let d = self.get_solar_day().get_lunar_day()
  LunarHour::from_ymd_hms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    self.get_hour(),
    self.get_minute(),
    self.get_second(),
  ).unwrap()
}

///|
// get_sixty_cycle_hour 干支时辰
pub fn SolarTime::get_sixty_cycle_hour(self : SolarTime) -> SixtyCycleHour {
  SixtyCycleHour::from_solar_time(self)
}
