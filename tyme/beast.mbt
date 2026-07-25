///|
// beast_names 神兽名称
pub fn beast_names() -> Array[String] {
  ["青龙", "玄武", "白虎", "朱雀"]
}

///|
// Beast 神兽
pub struct Beast {
  loop_tyme : LoopTyme
}

///|
extend Beast with Culture::{get_name}

///|
extend Beast with Show::{to_string}

///|
extend Beast with Tyme::{next}

///|
pub fn Beast::from_index(index : Int) -> Beast {
  Beast::{ loop_tyme: LoopTyme::from_index(beast_names(), index) }
}

///|
pub fn Beast::from_name(name : String) -> Result[Beast, String] {
  match LoopTyme::from_name(beast_names(), name) {
    Ok(p) => Ok(Beast::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Beast::get_index(self : Beast) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_zone 宫
pub fn Beast::get_zone(self : Beast) -> Zone {
  Zone::from_index(self.loop_tyme.get_index())
}

///|
impl Culture for Beast with get_name(self : Beast) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Beast with to_string(self : Beast) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Beast with next(self : Beast, n : Int) -> Beast {
  Beast::from_index(self.loop_tyme.get_index() + n)
}
