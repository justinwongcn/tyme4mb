///|
// NineDay 数九天
pub struct NineDay {
  abstract_culture_day : AbstractCultureDay[Nine]
}

///|
pub fn NineDay::new(o : Nine, index : Int) -> NineDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index), }
}

///|
// get_nine 数九
pub fn NineDay::get_nine(self : NineDay) -> Nine {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn NineDay::get_day_index(self : NineDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
pub impl Culture for NineDay with fn get_name(self : NineDay) -> String {
  Culture::get_name(self.abstract_culture_day)
}

///|
pub impl Show for NineDay with fn to_string(self : NineDay) -> String {
  Show::to_string(self.abstract_culture_day)
}

///|
pub extend NineDay with Culture::{get_name}

///|
pub extend NineDay with Show::{to_string}
