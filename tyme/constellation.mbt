///|
// constellation_names 星座名称
pub fn constellation_names() -> Array[String] {
  ["白羊", "金牛", "双子", "巨蟹", "狮子", "处女", "天秤", "天蝎", "射手", "摩羯", "水瓶", "双鱼"]
}

///|
// Constellation 星座
pub struct Constellation {
  loop_tyme : LoopTyme
}

///|
extend Constellation with Culture::{get_name}

///|
extend Constellation with Show::{to_string}

///|
extend Constellation with Tyme::{next}

///|
pub fn Constellation::from_index(index : Int) -> Constellation {
  Constellation::{ loop_tyme: LoopTyme::from_index(constellation_names(), index) }
}

///|
pub fn Constellation::from_name(name : String) -> Result[Constellation, String] {
  match LoopTyme::from_name(constellation_names(), name) {
    Ok(p) => Ok(Constellation::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Constellation::get_index(self : Constellation) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Constellation with get_name(self : Constellation) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Constellation with to_string(self : Constellation) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Constellation with next(self : Constellation, n : Int) -> Constellation {
  Constellation::from_index(self.loop_tyme.get_index() + n)
}
