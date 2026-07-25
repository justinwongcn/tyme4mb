///|
// LandNames 九野名称
pub fn land_names() -> Array[String] {
  ["玄天", "朱天", "苍天", "阳天", "钧天", "幽天", "颢天", "变天", "炎天"]
}

///|
// Land 九野
pub struct Land {
  loop_tyme : LoopTyme
}

///|
extend Land with Culture::{get_name}

///|
extend Land with Show::{to_string}

///|
extend Land with Tyme::{next}

///|
pub fn Land::get_index(self : Land) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn Land::from_index(index : Int) -> Land {
  Land::{ loop_tyme: LoopTyme::from_index(land_names(), index) }
}

///|
pub fn Land::from_name(name : String) -> Result[Land, String] {
  match LoopTyme::from_name(land_names(), name) {
    Ok(p) => Ok(Land::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Land::equals(self : Land, target : Land) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_direction 方位
pub fn Land::get_direction(self : Land) -> Direction {
  Direction::from_index(self.loop_tyme.get_index())
}

///|
impl Culture for Land with get_name(self : Land) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Land with to_string(self : Land) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Land with next(self : Land, n : Int) -> Land {
  Land::from_index(self.loop_tyme.get_index() + n)
}
