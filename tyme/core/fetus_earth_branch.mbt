///|
// fetus_earth_branch_names 地支六甲胎神名称
pub fn fetus_earth_branch_names() -> Array[String] {
  ["碓", "厕", "炉", "门", "栖", "床"]
}

///|
// FetusEarthBranch 地支六甲胎神（《地支六甲胎神歌》子午二日碓须忌，丑未厕道莫修移。寅申火炉休要动，卯酉大门修当避。辰戌鸡栖巳亥床，犯着六甲身堕胎。）
pub struct FetusEarthBranch {
  loop_tyme : LoopTyme
}

///|
pub extend FetusEarthBranch with Culture::{get_name}

///|
pub fn FetusEarthBranch::new(index : Int) -> FetusEarthBranch {
  { loop_tyme: LoopTyme::from_index(fetus_earth_branch_names(), index) }
}

///|
pub fn FetusEarthBranch::get_index(self : FetusEarthBranch) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for FetusEarthBranch with fn get_name(self : FetusEarthBranch) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for FetusEarthBranch with fn to_string(self : FetusEarthBranch) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for FetusEarthBranch with fn next(
  self : FetusEarthBranch,
  n : Int,
) -> FetusEarthBranch {
  FetusEarthBranch::new(self.loop_tyme.get_index() + n)
}

///|
pub extend FetusEarthBranch with Show::{to_string}

///|
pub extend FetusEarthBranch with Tyme::{next}
