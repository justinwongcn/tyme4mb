///|
// terrain_names 地势(长生十二神)名称
pub fn terrain_names() -> Array[String] {
  ["长生", "沐浴", "冠带", "临官", "帝旺", "衰", "病", "死", "墓", "绝", "胎", "养"]
}

///|
// Terrain 地势(长生十二神)
pub struct Terrain {
  loop_tyme : LoopTyme
}

///|
extend Terrain with Culture::{get_name}

///|
extend Terrain with Show::{to_string}

///|
extend Terrain with Tyme::{next}

///|
pub fn Terrain::from_index(index : Int) -> Terrain {
  Terrain::{ loop_tyme: LoopTyme::from_index(terrain_names(), index) }
}

///|
pub fn Terrain::from_name(name : String) -> Result[Terrain, String] {
  match LoopTyme::from_name(terrain_names(), name) {
    Ok(p) => Ok(Terrain::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Terrain::get_index(self : Terrain) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Terrain with get_name(self : Terrain) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Terrain with to_string(self : Terrain) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Terrain with next(self : Terrain, n : Int) -> Terrain {
  Terrain::from_index(self.loop_tyme.get_index() + n)
}
