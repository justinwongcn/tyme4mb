///|
// PhenologyDay 七十二候
pub struct PhenologyDay {
  abstract_culture_day : AbstractCultureDay[Phenology]
}

///|
pub fn PhenologyDay::new(o : Phenology, index : Int) -> PhenologyDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index), }
}

///|
// get_phenology 候
pub fn PhenologyDay::get_phenology(self : PhenologyDay) -> Phenology {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn PhenologyDay::get_day_index(self : PhenologyDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
pub impl Culture for PhenologyDay with fn get_name(self : PhenologyDay) -> String {
  Culture::get_name(self.abstract_culture_day)
}

///|
pub impl Show for PhenologyDay with fn to_string(self : PhenologyDay) -> String {
  Show::to_string(self.abstract_culture_day)
}

///|
pub extend PhenologyDay with Culture::{get_name}

///|
pub extend PhenologyDay with Show::{to_string}
