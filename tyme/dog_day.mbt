///|
// DogDay 三伏天
pub struct DogDay {
  abstract_culture_day : AbstractCultureDay[Dog]
}

///|
extend DogDay with Culture::{get_name}

///|
extend DogDay with Show::{to_string}

///|
pub fn DogDay::new(o : Dog, index : Int) -> DogDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index) }
}

///|
// get_dog 三伏
pub fn DogDay::get_dog(self : DogDay) -> Dog {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn DogDay::get_day_index(self : DogDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
impl Culture for DogDay with get_name(self : DogDay) -> String {
  self.abstract_culture_day.get_name()
}

///|
impl Show for DogDay with to_string(self : DogDay) -> String {
  self.abstract_culture_day.to_string()
}
