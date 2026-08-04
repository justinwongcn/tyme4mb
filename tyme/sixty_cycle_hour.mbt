///|
// SixtyCycleHour 干支时辰（立春换年，节令换月，23点换日）
pub struct SixtyCycleHour {
  // 公历时刻
  solar_time : SolarTime
  // 干支日
  day : SixtyCycleDay
  // 时柱
  hour : SixtyCycle
}

///|
extend SixtyCycleHour with Culture::{get_name}

///|
extend SixtyCycleHour with Tyme::{next}

///|
// from_solar_time 从公历时刻构造
pub fn SixtyCycleHour::from_solar_time(
  solar_time : SolarTime,
) -> SixtyCycleHour {
  let solar_year = solar_time.get_year()
  let spring_solar_time = SolarTerm::from_index(solar_year, 3)
    .get_julian_day()
    .get_solar_time()
  let lunar_hour = solar_time.get_lunar_hour()
  let lunar_day = lunar_hour.get_lunar_day()
  let mut lunar_year = lunar_day.get_lunar_month().get_lunar_year()
  if lunar_year.get_year() == solar_year {
    if solar_time.is_before(spring_solar_time) {
      lunar_year = lunar_year.next(-1)
    }
  } else if lunar_year.get_year() < solar_year {
    if !solar_time.is_before(spring_solar_time) {
      lunar_year = lunar_year.next(1)
    }
  }
  let term = solar_time.get_term()
  let mut index = term.loop_tyme.get_index() - 3
  if index < 0 &&
    term
    .get_julian_day()
    .get_solar_time()
    .is_after(
      SolarTerm::from_index(solar_year, 3).get_julian_day().get_solar_time(),
    ) {
    index = index + 24
  }
  let mut d = lunar_day.get_sixty_cycle()
  if solar_time.get_hour() == 23 {
    d = d.next(1)
  }
  let y = SixtyCycleYear::from_year(lunar_year.get_year()).unwrap()
  let m = LunarMonth::from_ym(solar_year, 1).unwrap()
  {
    solar_time,
    day: SixtyCycleDay::new(
      solar_time.get_solar_day(),
      SixtyCycleMonth::new(
        y,
        m.get_sixty_cycle().next(@math.floor(index.to_double() * 0.5).to_int()),
      ),
      d,
    ),
    hour: lunar_hour.get_sixty_cycle(),
  }
}

///|
// get_year 年柱
pub fn SixtyCycleHour::get_year(self : SixtyCycleHour) -> SixtyCycle {
  self.day.get_year()
}

///|
// get_month 月柱
pub fn SixtyCycleHour::get_month(self : SixtyCycleHour) -> SixtyCycle {
  self.day.get_month()
}

///|
// get_day 日柱
pub fn SixtyCycleHour::get_day(self : SixtyCycleHour) -> SixtyCycle {
  self.day.get_sixty_cycle()
}

///|
// get_sixty_cycle 干支
pub fn SixtyCycleHour::get_sixty_cycle(self : SixtyCycleHour) -> SixtyCycle {
  self.hour
}

///|
// get_sixty_cycle_day 干支日
pub fn SixtyCycleHour::get_sixty_cycle_day(
  self : SixtyCycleHour,
) -> SixtyCycleDay {
  self.day
}

///|
// get_solar_time 公历时刻
pub fn SixtyCycleHour::get_solar_time(self : SixtyCycleHour) -> SolarTime {
  self.solar_time
}

///|
// get_index_in_day 位于当天的索引
pub fn SixtyCycleHour::get_index_in_day(self : SixtyCycleHour) -> Int {
  let h = self.solar_time.get_hour()
  if h == 23 {
    return 0
  }
  (h + 1) / 2
}

///|
// get_twelve_star 黄道黑道十二神
pub fn SixtyCycleHour::get_twelve_star(self : SixtyCycleHour) -> TwelveStar {
  TwelveStar::from_index(
    self.hour.get_earth_branch().get_index() +
    (8 - self.get_day().get_earth_branch().get_index() % 6) * 2,
  )
}

///|
// get_nine_star 九星
pub fn SixtyCycleHour::get_nine_star(self : SixtyCycleHour) -> NineStar {
  let solar = self.solar_time.get_solar_day()
  let dong_zhi = SolarTerm::from_index(solar.get_year(), 0)
  let earth_branch_index = self.get_index_in_day() % 12
  let mut index = 8 - 3 * (self.get_day().get_earth_branch().get_index() % 3)
  if !solar.is_before(dong_zhi.get_julian_day().get_solar_day()) &&
    solar.is_before(dong_zhi.next(12).get_julian_day().get_solar_day()) {
    index = 8 + earth_branch_index - index
  } else {
    index = index - earth_branch_index
  }
  NineStar::from_index(index)
}

///|
// get_recommends 宜
pub fn SixtyCycleHour::get_recommends(
  self : SixtyCycleHour,
) -> Result[Array[Taboo], String] {
  Taboo::get_hour_recommends(self.get_day(), self.hour)
}

///|
// get_avoids 忌
pub fn SixtyCycleHour::get_avoids(
  self : SixtyCycleHour,
) -> Result[Array[Taboo], String] {
  Taboo::get_hour_avoids(self.get_day(), self.hour)
}

///|
// get_eight_char 八字
pub fn SixtyCycleHour::get_eight_char(self : SixtyCycleHour) -> EightChar {
  EightChar::from_sixty_cycle(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    self.hour,
  )
}

///|
pub impl Culture for SixtyCycleHour with fn get_name(self : SixtyCycleHour) -> String {
  "\{self.hour.to_string()}时"
}

///|
pub impl Show for SixtyCycleHour with fn to_string(self : SixtyCycleHour) -> String {
  self.day.to_string() + self.get_name()
}

///|
pub impl Tyme for SixtyCycleHour with fn next(self : SixtyCycleHour, n : Int) -> SixtyCycleHour {
  SixtyCycleHour::from_solar_time(self.solar_time.next(n))
}
