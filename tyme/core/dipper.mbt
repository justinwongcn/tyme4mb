///|
// dipper_names 北斗九星名称
pub fn dipper_names() -> Array[String] {
  [
    "天枢", "天璇", "天玑", "天权", "玉衡", "开阳", "摇光", "洞明",
    "隐元",
  ]
}

///|
// Dipper 北斗九星
pub struct Dipper {
  loop_tyme : LoopTyme
}

///|
pub fn Dipper::from_index(index : Int) -> Dipper {
  { loop_tyme: LoopTyme::from_index(dipper_names(), index), }
}

///|
pub fn Dipper::from_name(name : String) -> Result[Dipper, String] {
  match LoopTyme::from_name(dipper_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn Dipper::get_index(self : Dipper) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Dipper with fn get_name(self : Dipper) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Dipper with fn to_string(self : Dipper) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Dipper with fn next(self : Dipper, n : Int) -> Dipper {
  Dipper::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend Dipper with Culture::{get_name}

///|
pub extend Dipper with Show::{to_string}

///|
pub extend Dipper with Tyme::{next}
