///|
// AbstractCultureDay 带天索引的传统文化抽象
pub struct AbstractCultureDay[C] {
  culture : C
  day_index : Int
}

///|
pub fn[C] AbstractCultureDay::new(
  culture : C,
  day_index : Int,
) -> AbstractCultureDay[C] {
  { culture, day_index }
}

///|
// get_day_index 天索引
pub fn[C] AbstractCultureDay::get_day_index(
  self : AbstractCultureDay[C],
) -> Int {
  self.day_index
}

///|
pub fn[C] AbstractCultureDay::get_culture(self : AbstractCultureDay[C]) -> C {
  self.culture
}

///|
pub impl[C : Culture] Culture for AbstractCultureDay[C] with fn get_name(
  self : AbstractCultureDay[C],
) -> String {
  Culture::get_name(self.culture)
}

///|
pub impl[C : Culture] Show for AbstractCultureDay[C] with fn to_string(
  self : AbstractCultureDay[C],
) -> String {
  Culture::get_name(self.culture) +
  "第" +
  (self.day_index + 1).to_string() +
  "天"
}
