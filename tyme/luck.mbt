///|
// luck_names 吉凶名称
pub fn luck_names() -> Array[String] {
  ["吉", "凶"]
}

///|
// Luck 吉凶
pub struct Luck {
  loop_tyme : LoopTyme
}

///|
extend Luck with Culture::{get_name}

///|
extend Luck with Show::{to_string}

///|
extend Luck with Tyme::{next}

///|
pub fn Luck::from_index(index : Int) -> Luck {
  Luck::{ loop_tyme: LoopTyme::from_index(luck_names(), index) }
}

///|
pub fn Luck::from_name(name : String) -> Result[Luck, String] {
  match LoopTyme::from_name(luck_names(), name) {
    Ok(p) => Ok(Luck::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Luck::get_index(self : Luck) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Luck with fn get_name(self : Luck) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Luck with fn to_string(self : Luck) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Luck with fn next(self : Luck, n : Int) -> Luck {
  Luck::from_index(self.loop_tyme.get_index() + n)
}
