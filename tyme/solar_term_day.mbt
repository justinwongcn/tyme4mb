///|
// SolarTermDay 节气第几天
pub struct SolarTermDay {
  abstract_culture_day : AbstractCultureDay[SolarTerm]
}

///|
extend SolarTermDay with Culture::{get_name}

///|
extend SolarTermDay with Show::{to_string}

///|
pub fn SolarTermDay::new(o : SolarTerm, index : Int) -> SolarTermDay {
  { abstract_culture_day: AbstractCultureDay::new(o, index) }
}

///|
// get_solar_term 节气
pub fn SolarTermDay::get_solar_term(self : SolarTermDay) -> SolarTerm {
  self.abstract_culture_day.get_culture()
}

///|
// get_day_index 天索引
pub fn SolarTermDay::get_day_index(self : SolarTermDay) -> Int {
  self.abstract_culture_day.get_day_index()
}

///|
impl Culture for SolarTermDay with get_name(self : SolarTermDay) -> String {
  self.abstract_culture_day.get_name()
}

///|
impl Show for SolarTermDay with to_string(self : SolarTermDay) -> String {
  self.abstract_culture_day.to_string()
}
