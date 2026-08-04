///|
// DecadeFortune 大运（10年1大运）
pub struct DecadeFortune {
  // 童限
  child_limit : ChildLimit
  // 序号
  index : Int
}

///|
extend DecadeFortune with Culture::{get_name}

///|
// from_child_limit 从童限与序号构造
pub fn DecadeFortune::from_child_limit(
  child_limit : ChildLimit,
  index : Int,
) -> DecadeFortune {
  { child_limit, index }
}

///|
// get_start_age 开始年龄
pub fn DecadeFortune::get_start_age(self : DecadeFortune) -> Int {
  self.child_limit.get_end_sixty_cycle_year().get_year() -
  self.child_limit.get_start_sixty_cycle_year().get_year() +
  1 +
  self.index * 10
}

///|
// get_end_age 结束年龄
pub fn DecadeFortune::get_end_age(self : DecadeFortune) -> Int {
  self.get_start_age() + 9
}

///|
// get_start_lunar_year 开始农历年（已标记 Deprecated）
pub fn DecadeFortune::get_start_lunar_year(self : DecadeFortune) -> LunarYear {
  self.child_limit.get_end_lunar_year().next(self.index * 10)
}

///|
// get_end_lunar_year 结束农历年（已标记 Deprecated）
pub fn DecadeFortune::get_end_lunar_year(self : DecadeFortune) -> LunarYear {
  self.get_start_lunar_year().next(9)
}

///|
// get_start_sixty_cycle_year 开始干支年
pub fn DecadeFortune::get_start_sixty_cycle_year(
  self : DecadeFortune,
) -> SixtyCycleYear {
  self.child_limit.get_end_sixty_cycle_year().next(self.index * 10)
}

///|
// get_end_sixty_cycle_year 结束干支年
pub fn DecadeFortune::get_end_sixty_cycle_year(
  self : DecadeFortune,
) -> SixtyCycleYear {
  self.get_start_sixty_cycle_year().next(9)
}

///|
// get_sixty_cycle 干支
pub fn DecadeFortune::get_sixty_cycle(self : DecadeFortune) -> SixtyCycle {
  let mut n = self.index + 1
  if !self.child_limit.is_forward() {
    n = -n
  }
  self.child_limit.get_eight_char().get_month().next(n)
}

///|
// get_start_fortune 开始小运
pub fn DecadeFortune::get_start_fortune(self : DecadeFortune) -> Fortune {
  Fortune::from_child_limit(self.child_limit, self.index * 10)
}

///|
pub impl Culture for DecadeFortune with fn get_name(self : DecadeFortune) -> String {
  self.get_sixty_cycle().get_name()
}

///|
pub impl Show for DecadeFortune with fn to_string(self : DecadeFortune) -> String {
  self.get_name()
}

///|
pub impl Tyme for DecadeFortune with fn next(self : DecadeFortune, n : Int) -> DecadeFortune {
  DecadeFortune::from_child_limit(self.child_limit, self.index + n)
}
