///|
// zodiac_names 生肖名称
pub fn zodiac_names() -> Array[String] {
  [
    "鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗",
    "猪",
  ]
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
pub fn Zodiac::from_index(index : Int) -> Zodiac {
  { loop_tyme: LoopTyme::from_index(zodiac_names(), index) }
}

///|
pub fn Zodiac::from_name(name : String) -> Result[Zodiac, String] {
  match LoopTyme::from_name(zodiac_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
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
pub impl Culture for Zodiac with fn get_name(self : Zodiac) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Zodiac with fn to_string(self : Zodiac) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Zodiac with fn next(self : Zodiac, n : Int) -> Zodiac {
  Zodiac::from_index(self.loop_tyme.get_index() + n)
}
