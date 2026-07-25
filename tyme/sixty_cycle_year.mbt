///|
// SixtyCycleYear 干支年
pub struct SixtyCycleYear {
  // 年
  year : Int
}

///|
extend SixtyCycleYear with Culture::{get_name}

///|
extend SixtyCycleYear with Show::{to_string}

///|
extend SixtyCycleYear with Tyme::{next}

///|
// from_year 从年构造
pub fn SixtyCycleYear::from_year(
  year : Int,
) -> Result[SixtyCycleYear, String] {
  if year < -1 || year > 9999 {
    return Err("illegal sixty cycle year: " + year.to_string())
  }
  Ok(SixtyCycleYear::{ year })
}

///|
// get_year 年
pub fn SixtyCycleYear::get_year(self : SixtyCycleYear) -> Int {
  self.year
}

///|
// get_sixty_cycle 干支
pub fn SixtyCycleYear::get_sixty_cycle(self : SixtyCycleYear) -> SixtyCycle {
  SixtyCycle::from_index(self.year - 4)
}

///|
// get_twenty 运
pub fn SixtyCycleYear::get_twenty(self : SixtyCycleYear) -> Twenty {
  Twenty::from_index(
    @math.floor((self.year - 1864).to_double() / 20.0).to_int(),
  )
}

///|
// get_nine_star 九星
pub fn SixtyCycleYear::get_nine_star(self : SixtyCycleYear) -> NineStar {
  NineStar::from_index(
    63 + self.get_twenty().get_sixty().get_index() * 3 -
    self.get_sixty_cycle().get_index(),
  )
}

///|
// get_jupiter_direction 太岁方位
pub fn SixtyCycleYear::get_jupiter_direction(
  self : SixtyCycleYear,
) -> Direction {
  let arr = [0, 7, 7, 2, 3, 3, 8, 1, 1, 6, 0, 0]
  Direction::from_index(arr[self.get_sixty_cycle().get_earth_branch().get_index()])
}

///|
// get_first_month 首月（五虎遁：甲己之年丙作首，乙庚之岁戊为头，丙辛必定寻庚起，丁壬壬位顺行流，若问戊癸何方发，甲寅之上好追求。）
pub fn SixtyCycleYear::get_first_month(self : SixtyCycleYear) -> SixtyCycleMonth {
  SixtyCycleMonth::new(self, SixtyCycle::from_index(self.year * 12 - 46))
}

///|
// get_months 干支月列表
pub fn SixtyCycleYear::get_months(self : SixtyCycleYear) -> Array[SixtyCycleMonth] {
  let l : Array[SixtyCycleMonth] = []
  let m = self.get_first_month()
  l.push(m)
  for i = 1; i < 12; i = i + 1 {
    l.push(m.next(i))
  }
  l
}

///|
impl Culture for SixtyCycleYear with get_name(self : SixtyCycleYear) -> String {
  "\{self.get_sixty_cycle().to_string()}年"
}

///|
impl Show for SixtyCycleYear with to_string(self : SixtyCycleYear) -> String {
  self.get_name()
}

///|
impl Tyme for SixtyCycleYear with next(
  self : SixtyCycleYear,
  n : Int,
) -> SixtyCycleYear {
  match SixtyCycleYear::from_year(self.year + n) {
    Ok(y) => y
    Err(_) => self
  }
}

///|
// equals 是否相等
pub fn SixtyCycleYear::equals(
  self : SixtyCycleYear,
  target : SixtyCycleYear,
) -> Bool {
  self.to_string() == target.to_string()
}
