///|
// TwentyNames 运名称
pub fn twenty_names() -> Array[String] {
  [
    "一运", "二运", "三运", "四运", "五运", "六运", "七运", "八运",
    "九运",
  ]
}

///|
// Twenty 运（20年=1运，3运=1元）
pub struct Twenty {
  loop_tyme : LoopTyme
}

///|
extend Twenty with Show::{to_string}

///|
pub fn Twenty::from_index(index : Int) -> Twenty {
  { loop_tyme: LoopTyme::from_index(twenty_names(), index), }
}

///|
pub fn Twenty::from_name(name : String) -> Result[Twenty, String] {
  match LoopTyme::from_name(twenty_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn Twenty::equals(self : Twenty, target : Twenty) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_sixty 元
pub fn Twenty::get_sixty(self : Twenty) -> Sixty {
  Sixty::from_index(self.loop_tyme.get_index() / 3)
}

///|
pub impl Culture for Twenty with fn get_name(self : Twenty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Twenty with fn to_string(self : Twenty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Twenty with fn next(self : Twenty, n : Int) -> Twenty {
  Twenty::from_index(self.loop_tyme.get_index() + n)
}
