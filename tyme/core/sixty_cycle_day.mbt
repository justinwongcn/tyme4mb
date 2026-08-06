///|
// SixtyCycleDay 干支日（立春换年，节令换月）
pub struct SixtyCycleDay {
  // 公历日
  solar_day : SolarDay
  // 干支月
  month : SixtyCycleMonth
  // 日柱
  day : SixtyCycle
}

///|
extend SixtyCycleDay with Culture::{get_name}

///|
extend SixtyCycleDay with Show::{to_string}

///|
extend SixtyCycleDay with Tyme::{next}

///|
// new 从公历日/干支月/日柱构造
pub fn SixtyCycleDay::new(
  solar_day : SolarDay,
  month : SixtyCycleMonth,
  day : SixtyCycle,
) -> SixtyCycleDay {
  { solar_day, month, day }
}

///|
// from_solar_day 从公历日构造
pub fn SixtyCycleDay::from_solar_day(solar_day : SolarDay) -> SixtyCycleDay {
  let term = solar_day.get_term()
  let index = term.loop_tyme.get_index()
  let mut offset = -1
  if index < 3 {
    if index == 0 {
      offset = -2
    }
  } else {
    offset = (index - 3) / 2
  }
  let y = SixtyCycleYear::from_year(term.get_year()).unwrap()
  let d = SolarDay::from_ymd(2000, 1, 7).unwrap()
  {
    solar_day,
    month: y.get_first_month().next(offset),
    day: SixtyCycle::from_index(solar_day.subtract(d)),
  }
}

///|
// get_solar_day 公历日
pub fn SixtyCycleDay::get_solar_day(self : SixtyCycleDay) -> SolarDay {
  self.solar_day
}

///|
// get_sixty_cycle_month 干支月
pub fn SixtyCycleDay::get_sixty_cycle_month(
  self : SixtyCycleDay,
) -> SixtyCycleMonth {
  self.month
}

///|
// get_year 年柱
pub fn SixtyCycleDay::get_year(self : SixtyCycleDay) -> SixtyCycle {
  self.month.get_year()
}

///|
// get_month 月柱
pub fn SixtyCycleDay::get_month(self : SixtyCycleDay) -> SixtyCycle {
  self.month.get_sixty_cycle()
}

///|
// get_sixty_cycle 干支
pub fn SixtyCycleDay::get_sixty_cycle(self : SixtyCycleDay) -> SixtyCycle {
  self.day
}

///|
// get_duty 建除十二值神
pub fn SixtyCycleDay::get_duty(self : SixtyCycleDay) -> Duty {
  Duty::from_index(
    self.day.get_earth_branch().get_index() -
    self.get_month().get_earth_branch().get_index(),
  )
}

///|
// get_twelve_star 黄道黑道十二神
pub fn SixtyCycleDay::get_twelve_star(self : SixtyCycleDay) -> TwelveStar {
  TwelveStar::from_index(
    self.day.get_earth_branch().get_index() +
    (8 - self.get_month().get_earth_branch().get_index() % 6) * 2,
  )
}

///|
// get_nine_star 九星
pub fn SixtyCycleDay::get_nine_star(self : SixtyCycleDay) -> NineStar {
  self.solar_day.get_nine_star()
}

///|
// get_jupiter_direction 太岁方位
pub fn SixtyCycleDay::get_jupiter_direction(self : SixtyCycleDay) -> Direction {
  let index = self.day.get_index()
  if index % 12 < 6 {
    return Element::from_index(index / 12).get_direction()
  }
  self.month.get_sixty_cycle_year().get_jupiter_direction()
}

///|
// get_twenty_eight_star 二十八宿
pub fn SixtyCycleDay::get_twenty_eight_star(
  self : SixtyCycleDay,
) -> TwentyEightStar {
  let arr = [10, 18, 26, 6, 14, 22, 2]
  TwentyEightStar::from_index(arr[self.solar_day.get_week().get_index()]).next(
    -7 * self.day.get_earth_branch().get_index(),
  )
}

///|
// get_fetus_day 逐日胎神
pub fn SixtyCycleDay::get_fetus_day(self : SixtyCycleDay) -> FetusDay {
  FetusDay::from_sixty_cycle_day(self)
}

///|
// get_gods 神煞列表(吉神宜趋，凶神宜忌)
pub fn SixtyCycleDay::get_gods(
  self : SixtyCycleDay,
) -> Result[Array[God], String] {
  God::get_day_gods(self.get_month(), self.day)
}

///|
// get_recommends 宜
pub fn SixtyCycleDay::get_recommends(
  self : SixtyCycleDay,
) -> Result[Array[Taboo], String] {
  Taboo::get_day_recommends(self.get_month(), self.day)
}

///|
// get_avoids 忌
pub fn SixtyCycleDay::get_avoids(
  self : SixtyCycleDay,
) -> Result[Array[Taboo], String] {
  Taboo::get_day_avoids(self.get_month(), self.day)
}

///|
// get_three_pillars 三柱
pub fn SixtyCycleDay::get_three_pillars(self : SixtyCycleDay) -> ThreePillars {
  {
    year: self.get_year(),
    month: self.get_month(),
    day: self.get_sixty_cycle(),
  }
}

///|
// get_hours 当天的干支时辰列表
pub fn SixtyCycleDay::get_hours(self : SixtyCycleDay) -> Array[SixtyCycleHour] {
  let l : Array[SixtyCycleHour] = []
  let d = self.solar_day.next(-1)
  let t = SolarTime::from_ymdhms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    23,
    0,
    0,
  ).unwrap()
  let mut h = SixtyCycleHour::from_solar_time(t)
  l.push(h)
  for i = 0; i < 11; i = i + 1 {
    h = h.next(7200)
    l.push(h)
  }
  l
}

///|
// next 推移
pub impl Tyme for SixtyCycleDay with fn next(self : SixtyCycleDay, n : Int) -> SixtyCycleDay {
  SixtyCycleDay::from_solar_day(self.solar_day.next(n))
}

///|
// equals 是否相等
pub fn SixtyCycleDay::equals(
  self : SixtyCycleDay,
  target : SixtyCycleDay,
) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub impl Culture for SixtyCycleDay with fn get_name(self : SixtyCycleDay) -> String {
  self.day.to_string() + "日"
}

///|
pub impl Show for SixtyCycleDay with fn to_string(self : SixtyCycleDay) -> String {
  self.month.to_string() + self.get_name()
}
