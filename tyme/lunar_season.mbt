///|
// lunar_season_names 农历季节名称
pub fn lunar_season_names() -> Array[String] {
  [
    "孟春", "仲春", "季春", "孟夏", "仲夏", "季夏", "孟秋", "仲秋",
    "季秋", "孟冬", "仲冬", "季冬",
  ]
}

///|
// LunarSeason 农历季节
pub struct LunarSeason {
  loop_tyme : LoopTyme
}

///|
extend LunarSeason with Culture::{get_name}

///|
extend LunarSeason with Show::{to_string}

///|
extend LunarSeason with Tyme::{next}

///|
pub fn LunarSeason::from_index(index : Int) -> LunarSeason {
  LunarSeason::{ loop_tyme: LoopTyme::from_index(lunar_season_names(), index) }
}

///|
pub fn LunarSeason::from_name(name : String) -> Result[LunarSeason, String] {
  match LoopTyme::from_name(lunar_season_names(), name) {
    Ok(p) => Ok(LunarSeason::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn LunarSeason::get_index(self : LunarSeason) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for LunarSeason with fn get_name(self : LunarSeason) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for LunarSeason with fn to_string(self : LunarSeason) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for LunarSeason with fn next(self : LunarSeason, n : Int) -> LunarSeason {
  LunarSeason::from_index(self.loop_tyme.get_index() + n)
}
