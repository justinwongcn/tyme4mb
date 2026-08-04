///|
// PengZu 彭祖百忌
pub struct PengZu {
  peng_zu_heaven_stem : PengZuHeavenStem
  peng_zu_earth_branch : PengZuEarthBranch
}

///|
extend PengZu with Culture::{get_name}

///|
extend PengZu with Show::{to_string}

///|
pub fn PengZu::from_sixty_cycle(sixty_cycle : SixtyCycle) -> PengZu {
  PengZu::{
    peng_zu_heaven_stem: PengZuHeavenStem::from_index(
      sixty_cycle.get_heaven_stem().get_index(),
    ),
    peng_zu_earth_branch: PengZuEarthBranch::from_index(
      sixty_cycle.get_earth_branch().get_index(),
    ),
  }
}

///|
impl Culture for PengZu with fn get_name(self : PengZu) -> String {
  self.peng_zu_heaven_stem.to_string() +
  " " +
  self.peng_zu_earth_branch.to_string()
}

///|
impl Show for PengZu with fn to_string(self : PengZu) -> String {
  self.get_name()
}

///|
// get_peng_zu_heaven_stem 天干彭祖百忌
pub fn PengZu::get_peng_zu_heaven_stem(self : PengZu) -> PengZuHeavenStem {
  self.peng_zu_heaven_stem
}

///|
// get_peng_zu_earth_branch 地支彭祖百忌
pub fn PengZu::get_peng_zu_earth_branch(self : PengZu) -> PengZuEarthBranch {
  self.peng_zu_earth_branch
}
