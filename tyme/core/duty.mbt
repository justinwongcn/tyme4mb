///|
// duty_names 建除十二值神名称
pub fn duty_names() -> Array[String] {
  [
    "建", "除", "满", "平", "定", "执", "破", "危", "成", "收", "开",
    "闭",
  ]
}

///|
// Duty 建除十二值神
pub struct Duty {
  loop_tyme : LoopTyme
}

///|
pub fn Duty::from_index(index : Int) -> Duty {
  { loop_tyme: LoopTyme::from_index(duty_names(), index) }
}

///|
pub fn Duty::from_name(name : String) -> Result[Duty, String] {
  match LoopTyme::from_name(duty_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Duty::get_index(self : Duty) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Duty with fn get_name(self : Duty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Duty with fn to_string(self : Duty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Duty with fn next(self : Duty, n : Int) -> Duty {
  Duty::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend Duty with Culture::{get_name}

///|
pub extend Duty with Show::{to_string}

///|
pub extend Duty with Tyme::{next}
