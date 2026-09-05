///|
// seven_star_names 七曜名称
pub fn seven_star_names() -> Array[String] {
  ["日", "月", "火", "水", "木", "金", "土"]
}

///|
// SevenStar 七曜（七政、七纬、七耀）
pub struct SevenStar {
  loop_tyme : LoopTyme
}

///|
pub fn SevenStar::from_index(index : Int) -> SevenStar {
  { loop_tyme: LoopTyme::from_index(seven_star_names(), index), }
}

///|
pub fn SevenStar::from_name(name : String) -> Result[SevenStar, String] {
  match LoopTyme::from_name(seven_star_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn SevenStar::get_index(self : SevenStar) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_week 星期
pub fn SevenStar::get_week(self : SevenStar) -> Week {
  Week::from_index(self.loop_tyme.get_index())
}

///|
pub impl Culture for SevenStar with fn get_name(self : SevenStar) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for SevenStar with fn to_string(self : SevenStar) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for SevenStar with fn next(self : SevenStar, n : Int) -> SevenStar {
  SevenStar::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend SevenStar with Culture::{get_name}

///|
pub extend SevenStar with Show::{to_string}
