///|
// peng_zu_heaven_stem_names 天干彭祖百忌名称
pub fn peng_zu_heaven_stem_names() -> Array[String] {
  [
    "甲不开仓财物耗散", "乙不栽植千株不长", "丙不修灶必见灾殃",
    "丁不剃头头必生疮", "戊不受田田主不祥", "己不破券二比并亡",
    "庚不经络织机虚张", "辛不合酱主人不尝", "壬不泱水更难提防",
    "癸不词讼理弱敌强",
  ]
}

///|
// PengZuHeavenStem 天干彭祖百忌
pub struct PengZuHeavenStem {
  loop_tyme : LoopTyme
}

///|
pub extend PengZuHeavenStem with Show::{to_string}

///|
pub fn PengZuHeavenStem::from_index(index : Int) -> PengZuHeavenStem {
  { loop_tyme: LoopTyme::from_index(peng_zu_heaven_stem_names(), index), }
}

///|
pub fn PengZuHeavenStem::from_name(
  name : String,
) -> Result[PengZuHeavenStem, String] {
  match LoopTyme::from_name(peng_zu_heaven_stem_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn PengZuHeavenStem::get_index(self : PengZuHeavenStem) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for PengZuHeavenStem with fn get_name(self : PengZuHeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for PengZuHeavenStem with fn to_string(self : PengZuHeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for PengZuHeavenStem with fn next(
  self : PengZuHeavenStem,
  n : Int,
) -> PengZuHeavenStem {
  PengZuHeavenStem::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend PengZuHeavenStem with Culture::{get_name}

///|
pub extend PengZuHeavenStem with Tyme::{next}
