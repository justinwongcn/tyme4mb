///|
// HideHeavenStem 藏干（即人元，司令取天干，分野取天干的五行）
pub struct HideHeavenStem {
  heaven_stem : HeavenStem
  hide_heaven_stem_type : HideHeavenStemType
}

///|
extend HideHeavenStem with Culture::{get_name}

///|
extend HideHeavenStem with Show::{to_string}

///|
pub fn HideHeavenStem::new(
  heaven_stem_name : String,
  hide_heaven_stem_type : HideHeavenStemType,
) -> Result[HideHeavenStem, String] {
  match HeavenStem::from_name(heaven_stem_name) {
    Ok(h) => Ok(HideHeavenStem::{ heaven_stem: h, hide_heaven_stem_type })
    Err(e) => Err(e)
  }
}

///|
pub fn HideHeavenStem::from_index(
  heaven_stem_index : Int,
  hide_heaven_stem_type : HideHeavenStemType,
) -> HideHeavenStem {
  HideHeavenStem::{
    heaven_stem: HeavenStem::from_index(heaven_stem_index),
    hide_heaven_stem_type,
  }
}

///|
// get_heaven_stem 天干
pub fn HideHeavenStem::get_heaven_stem(self : HideHeavenStem) -> HeavenStem {
  self.heaven_stem
}

///|
// get_type 藏干类型
pub fn HideHeavenStem::get_type(self : HideHeavenStem) -> HideHeavenStemType {
  self.hide_heaven_stem_type
}

///|
impl Culture for HideHeavenStem with fn get_name(self : HideHeavenStem) -> String {
  self.heaven_stem.get_name()
}

///|
impl Show for HideHeavenStem with fn to_string(self : HideHeavenStem) -> String {
  self.get_name()
}
