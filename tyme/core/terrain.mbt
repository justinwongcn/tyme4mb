///|
// terrain_names 地势(长生十二神)名称
pub fn terrain_names() -> Array[String] {
  [
    "长生", "沐浴", "冠带", "临官", "帝旺", "衰", "病", "死", "墓",
    "绝", "胎", "养",
  ]
}

///|
// Terrain 地势(长生十二神)
pub struct Terrain {
  loop_tyme : LoopTyme
}

///|
pub fn Terrain::from_index(index : Int) -> Terrain {
  { loop_tyme: LoopTyme::from_index(terrain_names(), index), }
}

///|
pub fn Terrain::from_name(name : String) -> Result[Terrain, String] {
  match LoopTyme::from_name(terrain_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn Terrain::get_index(self : Terrain) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Terrain with fn get_name(self : Terrain) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Terrain with fn to_string(self : Terrain) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Terrain with fn next(self : Terrain, n : Int) -> Terrain {
  Terrain::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend Terrain with Culture::{get_name}

///|
pub extend Terrain with Show::{to_string}

///|
pub extend Terrain with Tyme::{next}
