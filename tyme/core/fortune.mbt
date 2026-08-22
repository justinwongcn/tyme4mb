///|
// Fortune 小运
pub struct Fortune {
  // 童限
  child_limit : ChildLimit
  // 序号
  index : Int
}

///|
pub extend Fortune with Culture::{get_name}

///|
// from_child_limit 从童限与序号构造
pub fn Fortune::from_child_limit(
  child_limit : ChildLimit,
  index : Int,
) -> Fortune {
  { child_limit, index }
}

///|
// get_age 年龄
pub fn Fortune::get_age(self : Fortune) -> Int {
  self.child_limit.get_end_sixty_cycle_year().get_year() -
  self.child_limit.get_start_sixty_cycle_year().get_year() +
  1 +
  self.index
}

///|
// get_lunar_year 农历年（已标记 Deprecated）
pub fn Fortune::get_lunar_year(self : Fortune) -> LunarYear {
  self.child_limit.get_end_lunar_year().next(self.index)
}

///|
// get_sixty_cycle_year 干支年
pub fn Fortune::get_sixty_cycle_year(self : Fortune) -> SixtyCycleYear {
  self.child_limit.get_end_sixty_cycle_year().next(self.index)
}

///|
// get_sixty_cycle 干支
pub fn Fortune::get_sixty_cycle(self : Fortune) -> SixtyCycle {
  let mut n = self.get_age()
  if !self.child_limit.is_forward() {
    n = -n
  }
  self.child_limit.get_eight_char().get_hour().next(n)
}

///|
pub impl Culture for Fortune with fn get_name(self : Fortune) -> String {
  self.get_sixty_cycle().get_name()
}

///|
pub impl Show for Fortune with fn to_string(self : Fortune) -> String {
  self.get_name()
}

///|
pub impl Tyme for Fortune with fn next(self : Fortune, n : Int) -> Fortune {
  Fortune::from_child_limit(self.child_limit, self.index + n)
}

///|
pub extend Fortune with Show::{to_string}

///|
pub extend Fortune with Tyme::{next}
