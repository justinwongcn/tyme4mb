///|
// week_names 星期名称
pub fn week_names() -> Array[String] {
  ["日", "一", "二", "三", "四", "五", "六"]
}

///|
// Week 星期
pub struct Week {
  loop_tyme : LoopTyme
}

///|
extend Week with Culture::{get_name}

///|
extend Week with Show::{to_string}

///|
extend Week with Tyme::{next}

///|
pub fn Week::from_index(index : Int) -> Week {
  Week::{ loop_tyme: LoopTyme::from_index(week_names(), index) }
}

///|
pub fn Week::from_name(name : String) -> Result[Week, String] {
  match LoopTyme::from_name(week_names(), name) {
    Ok(p) => Ok(Week::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Week::get_index(self : Week) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_seven_star 七曜
pub fn Week::get_seven_star(self : Week) -> SevenStar {
  SevenStar::from_index(self.loop_tyme.get_index())
}

///|
pub fn Week::equals(self : Week, target : Week) -> Bool {
  self.loop_tyme.get_index() == target.loop_tyme.get_index()
}

///|
impl Culture for Week with get_name(self : Week) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Week with to_string(self : Week) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Week with next(self : Week, n : Int) -> Week {
  Week::from_index(self.loop_tyme.get_index() + n)
}
