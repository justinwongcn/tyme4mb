///|
// zodiac_names 生肖名称
pub fn zodiac_names() -> Array[String] {
  ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
}

///|
// Zodiac 生肖
pub struct Zodiac {
  loop_tyme : LoopTyme
}

///|
extend Zodiac with Culture::{get_name}

///|
extend Zodiac with Show::{to_string}

///|
extend Zodiac with Tyme::{next}

///|
pub fn Zodiac::from_index(index : Int) -> Zodiac {
  Zodiac::{ loop_tyme: LoopTyme::from_index(zodiac_names(), index) }
}

///|
pub fn Zodiac::from_name(name : String) -> Result[Zodiac, String] {
  match LoopTyme::from_name(zodiac_names(), name) {
    Ok(p) => Ok(Zodiac::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Zodiac::equals(self : Zodiac, target : Zodiac) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub fn Zodiac::get_index(self : Zodiac) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Zodiac with get_name(self : Zodiac) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Zodiac with to_string(self : Zodiac) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Zodiac with next(self : Zodiac, n : Int) -> Zodiac {
  Zodiac::from_index(self.loop_tyme.get_index() + n)
}
