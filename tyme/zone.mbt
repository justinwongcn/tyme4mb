///|
// zone_names 宫名称
pub fn zone_names() -> Array[String] {
  ["东", "北", "西", "南"]
}

///|
// Zone 宫
pub struct Zone {
  loop_tyme : LoopTyme
}

///|
extend Zone with Culture::{get_name}

///|
extend Zone with Show::{to_string}

///|
extend Zone with Tyme::{next}

///|
pub fn Zone::from_index(index : Int) -> Zone {
  Zone::{ loop_tyme: LoopTyme::from_index(zone_names(), index) }
}

///|
pub fn Zone::from_name(name : String) -> Result[Zone, String] {
  match LoopTyme::from_name(zone_names(), name) {
    Ok(p) => Ok(Zone::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Zone::get_index(self : Zone) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_direction 方位
pub fn Zone::get_direction(self : Zone) -> Direction {
  match Direction::from_name(self.loop_tyme.get_name()) {
    Ok(d) => d
    Err(e) => abort(e)
  }
}

///|
// get_beast 神兽
pub fn Zone::get_beast(self : Zone) -> Beast {
  Beast::from_index(self.loop_tyme.get_index())
}

///|
impl Culture for Zone with get_name(self : Zone) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Zone with to_string(self : Zone) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Zone with next(self : Zone, n : Int) -> Zone {
  Zone::from_index(self.loop_tyme.get_index() + n)
}
