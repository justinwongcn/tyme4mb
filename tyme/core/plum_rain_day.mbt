///|
// PlumRainDay 梅雨天
pub struct PlumRainDay {
  abstract_culture_day : AbstractCultureDay[PlumRain]
}

///|
pub fn PlumRainDay::new(o : PlumRain, index : Int) -> PlumRainDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index), }
}

///|
// get_plum_rain 梅雨
pub fn PlumRainDay::get_plum_rain(self : PlumRainDay) -> PlumRain {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn PlumRainDay::get_day_index(self : PlumRainDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
pub impl Culture for PlumRainDay with fn get_name(self : PlumRainDay) -> String {
  Culture::get_name(self.abstract_culture_day)
}

///|
pub impl Show for PlumRainDay with fn to_string(self : PlumRainDay) -> String {
  if self.get_plum_rain().get_index() == 0 {
    "\{self.abstract_culture_day.get_culture()}第\{self.abstract_culture_day.get_day_index() + 1}天"
  } else {
    self.get_plum_rain().get_name()
  }
}

///|
pub extend PlumRainDay with Culture::{get_name}

///|
pub extend PlumRainDay with Show::{to_string}
