///|
// PhaseDay 月相第几天
pub struct PhaseDay {
  day : AbstractCultureDay[Phase]
}

///|
// new 构造
pub fn PhaseDay::new(o : Phase, index : Int) -> PhaseDay {
  PhaseDay::{ day: AbstractCultureDay::new(o, index) }
}

///|
// get_phase 月相
pub fn PhaseDay::get_phase(self : PhaseDay) -> Phase {
  self.day.get_culture()
}

///|
// get_day_index 天索引
pub fn PhaseDay::get_day_index(self : PhaseDay) -> Int {
  self.day.get_day_index()
}

///|
impl Culture for PhaseDay with fn get_name(self : PhaseDay) -> String {
  Culture::get_name(self.day.get_culture())
}

///|
impl Show for PhaseDay with fn to_string(self : PhaseDay) -> String {
  Show::to_string(self.day)
}

///|
extend PhaseDay with Show::{to_string}

///|
extend PhaseDay with Culture::{get_name}
