///|
// SixtyCycleNames 六十甲子(六十干支周)名称
pub fn sixty_cycle_names() -> Array[String] {
  [
    "甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未",
    "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯",
    "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥",
    "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未",
    "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯",
    "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥",
    "壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未",
    "庚申", "辛酉", "壬戌", "癸亥",
  ]
}

///|
// SixtyCycle 六十甲子(六十干支周)
pub struct SixtyCycle {
  loop_tyme : LoopTyme
}

///|
extend SixtyCycle with Culture::{get_name}

///|
extend SixtyCycle with Show::{to_string}

///|
extend SixtyCycle with Tyme::{next}

///|
pub fn SixtyCycle::get_index(self : SixtyCycle) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn SixtyCycle::from_index(index : Int) -> SixtyCycle {
  SixtyCycle::{ loop_tyme: LoopTyme::from_index(sixty_cycle_names(), index) }
}

///|
pub fn SixtyCycle::from_name(name : String) -> Result[SixtyCycle, String] {
  match LoopTyme::from_name(sixty_cycle_names(), name) {
    Ok(p) => Ok(SixtyCycle::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn SixtyCycle::equals(self : SixtyCycle, target : SixtyCycle) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_heaven_stem 天干
pub fn SixtyCycle::get_heaven_stem(self : SixtyCycle) -> HeavenStem {
  HeavenStem::from_index(self.loop_tyme.get_index() % 10)
}

///|
// get_earth_branch 地支
pub fn SixtyCycle::get_earth_branch(self : SixtyCycle) -> EarthBranch {
  EarthBranch::from_index(self.loop_tyme.get_index() % 12)
}

///|
// get_sound 纳音
pub fn SixtyCycle::get_sound(self : SixtyCycle) -> Sound {
  Sound::from_index(self.loop_tyme.get_index() / 2)
}

///|
// get_peng_zu 彭祖百忌
pub fn SixtyCycle::get_peng_zu(self : SixtyCycle) -> PengZu {
  PengZu::from_sixty_cycle(self)
}

///|
// get_ten 旬
pub fn SixtyCycle::get_ten(self : SixtyCycle) -> Ten {
  Ten::from_index(
    (self.get_heaven_stem().get_index() - self.get_earth_branch().get_index()) /
    2,
  )
}

///|
// get_extra_earth_branches 旬空(空亡)，因地支比天干多2个，旬空则为每一轮干支一一配对后多出来的2个地支
pub fn SixtyCycle::get_extra_earth_branches(
  self : SixtyCycle,
) -> Array[EarthBranch] {
  let l : Array[EarthBranch] = []
  let first = EarthBranch::from_index(
    10 +
    self.get_earth_branch().get_index() -
    self.get_heaven_stem().get_index(),
  )
  l.push(first)
  l.push(first.next(1))
  l
}

///|
impl Culture for SixtyCycle with fn get_name(self : SixtyCycle) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for SixtyCycle with fn to_string(self : SixtyCycle) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for SixtyCycle with fn next(self : SixtyCycle, n : Int) -> SixtyCycle {
  SixtyCycle::from_index(self.loop_tyme.get_index() + n)
}
