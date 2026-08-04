///|
// plum_rain_names 梅雨名称
pub fn plum_rain_names() -> Array[String] {
  ["入梅", "出梅"]
}

///|
// PlumRain 梅雨
pub struct PlumRain {
  loop_tyme : LoopTyme
}

///|
extend PlumRain with Culture::{get_name}

///|
extend PlumRain with Show::{to_string}

///|
extend PlumRain with Tyme::{next}

///|
pub fn PlumRain::from_index(index : Int) -> PlumRain {
  PlumRain::{ loop_tyme: LoopTyme::from_index(plum_rain_names(), index) }
}

///|
pub fn PlumRain::from_name(name : String) -> Result[PlumRain, String] {
  match LoopTyme::from_name(plum_rain_names(), name) {
    Ok(p) => Ok(PlumRain::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn PlumRain::get_index(self : PlumRain) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for PlumRain with fn get_name(self : PlumRain) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for PlumRain with fn to_string(self : PlumRain) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for PlumRain with fn next(self : PlumRain, n : Int) -> PlumRain {
  PlumRain::from_index(self.loop_tyme.get_index() + n)
}
