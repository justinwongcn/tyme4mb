///|
// dipper_names 北斗九星名称
pub fn dipper_names() -> Array[String] {
  ["天枢", "天璇", "天玑", "天权", "玉衡", "开阳", "摇光", "洞明", "隐元"]
}

///|
// Dipper 北斗九星
pub struct Dipper {
  loop_tyme : LoopTyme
}

///|
extend Dipper with Culture::{get_name}

///|
extend Dipper with Show::{to_string}

///|
extend Dipper with Tyme::{next}

///|
pub fn Dipper::from_index(index : Int) -> Dipper {
  Dipper::{ loop_tyme: LoopTyme::from_index(dipper_names(), index) }
}

///|
pub fn Dipper::from_name(name : String) -> Result[Dipper, String] {
  match LoopTyme::from_name(dipper_names(), name) {
    Ok(p) => Ok(Dipper::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Dipper::get_index(self : Dipper) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Dipper with get_name(self : Dipper) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Dipper with to_string(self : Dipper) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Dipper with next(self : Dipper, n : Int) -> Dipper {
  Dipper::from_index(self.loop_tyme.get_index() + n)
}
