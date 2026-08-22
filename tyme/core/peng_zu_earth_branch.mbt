///|
// peng_zu_earth_branch_names 地支彭祖百忌名称
pub fn peng_zu_earth_branch_names() -> Array[String] {
  [
    "子不问卜自惹祸殃", "丑不冠带主不还乡", "寅不祭祀神鬼不尝",
    "卯不穿井水泉不香", "辰不哭泣必主重丧", "巳不远行财物伏藏",
    "午不苫盖屋主更张", "未不服药毒气入肠", "申不安床鬼祟入房",
    "酉不会客醉坐颠狂", "戌不吃犬作怪上床", "亥不嫁娶不利新郎",
  ]
}

///|
// PengZuEarthBranch 地支彭祖百忌
pub struct PengZuEarthBranch {
  loop_tyme : LoopTyme
}

///|
pub extend PengZuEarthBranch with Show::{to_string}

///|
pub fn PengZuEarthBranch::from_index(index : Int) -> PengZuEarthBranch {
  { loop_tyme: LoopTyme::from_index(peng_zu_earth_branch_names(), index) }
}

///|
pub fn PengZuEarthBranch::from_name(
  name : String,
) -> Result[PengZuEarthBranch, String] {
  match LoopTyme::from_name(peng_zu_earth_branch_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn PengZuEarthBranch::get_index(self : PengZuEarthBranch) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for PengZuEarthBranch with fn get_name(
  self : PengZuEarthBranch,
) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for PengZuEarthBranch with fn to_string(self : PengZuEarthBranch) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for PengZuEarthBranch with fn next(
  self : PengZuEarthBranch,
  n : Int,
) -> PengZuEarthBranch {
  PengZuEarthBranch::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend PengZuEarthBranch with Culture::{get_name}

///|
pub extend PengZuEarthBranch with Tyme::{next}
