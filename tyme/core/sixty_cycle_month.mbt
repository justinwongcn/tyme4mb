///|
// SixtyCycleMonth 干支月
pub struct SixtyCycleMonth {
  // 干支年
  year : SixtyCycleYear
  // 月柱
  month : SixtyCycle
}

///|
extend SixtyCycleMonth with Culture::{get_name}

///|
extend SixtyCycleMonth with Show::{to_string}

///|
extend SixtyCycleMonth with Tyme::{next}

///|
// new 从年与月柱构造
pub fn SixtyCycleMonth::new(
  year : SixtyCycleYear,
  month : SixtyCycle,
) -> SixtyCycleMonth {
  { year, month, }
}

///|
// from_index 从年与索引构造
pub fn SixtyCycleMonth::from_index(
  year : Int,
  index : Int,
) -> Result[SixtyCycleMonth, String] {
  match SixtyCycleYear::from_year(year) {
    Ok(y) => Ok(y.get_first_month().next(index))
    Err(e) => Err(e)
  }
}

///|
// get_sixty_cycle_year 干支年
pub fn SixtyCycleMonth::get_sixty_cycle_year(
  self : SixtyCycleMonth,
) -> SixtyCycleYear {
  self.year
}

///|
// get_year 年柱
pub fn SixtyCycleMonth::get_year(self : SixtyCycleMonth) -> SixtyCycle {
  self.year.get_sixty_cycle()
}

///|
// get_sixty_cycle 干支
pub fn SixtyCycleMonth::get_sixty_cycle(self : SixtyCycleMonth) -> SixtyCycle {
  self.month
}

///|
// get_index_in_year 位于当年的索引(0-11)，寅月为0，依次类推
pub fn SixtyCycleMonth::get_index_in_year(self : SixtyCycleMonth) -> Int {
  self.month.get_earth_branch().next(-2).get_index()
}

///|
// get_first_day 首日
pub fn SixtyCycleMonth::get_first_day(self : SixtyCycleMonth) -> SixtyCycleDay {
  SixtyCycleDay::from_solar_day(
    SolarTerm::from_index(
      self.year.get_year(),
      3 + self.get_index_in_year() * 2,
    ).get_solar_day(),
  )
}

///|
// get_days 本月的干支日列表
pub fn SixtyCycleMonth::get_days(
  self : SixtyCycleMonth,
) -> Array[SixtyCycleDay] {
  let l : Array[SixtyCycleDay] = []
  let mut d = self.get_first_day()
  while d.get_sixty_cycle_month().equals(self) {
    l.push(d)
    d = d.next(1)
  }
  l
}

///|
// get_nine_star 九星
pub fn SixtyCycleMonth::get_nine_star(self : SixtyCycleMonth) -> NineStar {
  let mut index = self.month.get_earth_branch().get_index()
  if index < 2 {
    index = index + 3
  }
  NineStar::from_index(
    27 - self.get_year().get_earth_branch().get_index() % 3 * 3 - index,
  )
}

///|
// get_jupiter_direction 太岁方位
pub fn SixtyCycleMonth::get_jupiter_direction(
  self : SixtyCycleMonth,
) -> Direction {
  let n = [7, -1, 1, 3][self.month.get_earth_branch().next(-2).get_index() % 4]
  if n == -1 {
    return self.month.get_heaven_stem().get_direction()
  }
  Direction::from_index(n)
}

///|
// next 推移
pub impl Tyme for SixtyCycleMonth with fn next(self : SixtyCycleMonth, n : Int) -> SixtyCycleMonth {
  let y = SixtyCycleYear::from_year(
    (self.year.get_year() * 12 + self.get_index_in_year() + n) / 12,
  ).unwrap()
  SixtyCycleMonth::new(y, self.month.next(n))
}

///|
// equals 是否相等
pub fn SixtyCycleMonth::equals(
  self : SixtyCycleMonth,
  target : SixtyCycleMonth,
) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub impl Culture for SixtyCycleMonth with fn get_name(self : SixtyCycleMonth) -> String {
  self.month.to_string() + "月"
}

///|
pub impl Show for SixtyCycleMonth with fn to_string(self : SixtyCycleMonth) -> String {
  self.year.to_string() + self.get_name()
}
