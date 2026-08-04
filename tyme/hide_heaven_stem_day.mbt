///|
// HideHeavenStemDay 人元司令分野（地支藏干+天索引）
pub struct HideHeavenStemDay {
  abstract_culture_day : AbstractCultureDay[HideHeavenStem]
}

///|
extend HideHeavenStemDay with Culture::{get_name}

///|
pub fn HideHeavenStemDay::new(
  o : HideHeavenStem,
  index : Int,
) -> HideHeavenStemDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index) }
}

///|
// get_hide_heaven_stem 藏干
pub fn HideHeavenStemDay::get_hide_heaven_stem(
  self : HideHeavenStemDay,
) -> HideHeavenStem {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn HideHeavenStemDay::get_day_index(self : HideHeavenStemDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
pub impl Culture for HideHeavenStemDay with fn get_name(
  self : HideHeavenStemDay,
) -> String {
  let heaven_stem = self.get_hide_heaven_stem().get_heaven_stem()
  "\{heaven_stem.get_name()}\{heaven_stem.get_element().get_name()}"
}

///|
pub impl Show for HideHeavenStemDay with fn to_string(self : HideHeavenStemDay) -> String {
  "\{self.get_name()}第\{self.abstract_culture_day.get_day_index() + 1}天"
}
