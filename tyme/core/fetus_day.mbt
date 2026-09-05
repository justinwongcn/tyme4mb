///|
// FetusDay 逐日胎神
pub struct FetusDay {
  fetus_heaven_stem : FetusHeavenStem
  fetus_earth_branch : FetusEarthBranch
  side : Side
  direction : Direction
}

///|
extend FetusDay with Culture::{get_name}

///|
extend FetusDay with Show::{to_string}

///|
// new 从干支构造
pub fn FetusDay::new(sixty_cycle : SixtyCycle) -> FetusDay {
  let fetus_heaven_stem = FetusHeavenStem::new(
    sixty_cycle.get_heaven_stem().get_index() % 5,
  )
  let fetus_earth_branch = FetusEarthBranch::new(
    sixty_cycle.get_earth_branch().get_index() % 6,
  )
  let index = [
      3, 3, 8, 8, 8, 8, 8, 1, 1, 1, 1, 1, 1, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 0,
      0, 0, 0, 0, -9, -9, -9, -9, -9, -5, -5, -1, -1, -1, -3, -7, -7, -7, -7, -5,
      7, 7, 7, 7, 7, 7, 2, 2, 2, 2, 2, 3, 3, 3, 3,
    ][sixty_cycle.get_index()]
  let mut side = @base.Out
  if index < 0 {
    side = @base.In
  }
  let direction = Direction::from_index(index)
  { fetus_heaven_stem, fetus_earth_branch, side, direction, }
}

///|
// from_lunar_day 从农历日构造
pub fn FetusDay::from_lunar_day(lunar_day : LunarDay) -> FetusDay {
  FetusDay::new(lunar_day.get_sixty_cycle())
}

///|
// from_sixty_cycle_day 从干支日构造
pub fn FetusDay::from_sixty_cycle_day(
  sixty_cycle_day : SixtyCycleDay,
) -> FetusDay {
  FetusDay::new(sixty_cycle_day.get_sixty_cycle())
}

///|
// get_side 内外
pub fn FetusDay::get_side(self : FetusDay) -> Side {
  self.side
}

///|
// get_direction 方位
pub fn FetusDay::get_direction(self : FetusDay) -> Direction {
  self.direction
}

///|
// get_fetus_heaven_stem 天干六甲胎神
pub fn FetusDay::get_fetus_heaven_stem(self : FetusDay) -> FetusHeavenStem {
  self.fetus_heaven_stem
}

///|
// get_fetus_earth_branch 地支六甲胎神
pub fn FetusDay::get_fetus_earth_branch(self : FetusDay) -> FetusEarthBranch {
  self.fetus_earth_branch
}

///|
pub impl Culture for FetusDay with fn get_name(self : FetusDay) -> String {
  let mut s = self.fetus_heaven_stem.get_name() +
    self.fetus_earth_branch.get_name()
  if "门门" == s {
    s = "占大门"
  } else if "碓磨碓" == s {
    s = "占碓磨"
  } else if "房床床" == s {
    s = "占房床"
  } else if s.length() >= 1 && s.unsafe_get(0).to_int() == '门'.to_int() {
    s = "占" + s
  }
  s = s + " "
  if self.side.get_code() == 0 {
    s = s + "房"
  }
  s = s + self.side.get_name()
  let direction_name = self.direction.get_name()
  if self.side.get_code() == 1 && str_contains("北南西东", direction_name) {
    s = s + "正"
  }
  s + direction_name
}

///|
// str_contains 字符串包含
fn str_contains(haystack : String, needle : String) -> Bool {
  let hl = haystack.length()
  let nl = needle.length()
  if nl == 0 {
    return true
  }
  if nl > hl {
    return false
  }
  for i = 0; i + nl <= hl; i = i + 1 {
    let mut ok = true
    for j = 0; j < nl; j = j + 1 {
      if haystack.unsafe_get(i + j).to_int() != needle.unsafe_get(j).to_int() {
        ok = false
        break
      }
    }
    if ok {
      return true
    }
  }
  false
}

///|
pub impl Show for FetusDay with fn to_string(self : FetusDay) -> String {
  self.get_name()
}

///|
// equals 是否相等
pub fn FetusDay::equals(self : FetusDay, target : FetusDay) -> Bool {
  self.to_string() == target.to_string()
}
