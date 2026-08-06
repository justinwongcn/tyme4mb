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
extend Week with Tyme::{next}

///|
pub fn Week::from_index(index : Int) -> Week {
  { loop_tyme: LoopTyme::from_index(week_names(), index) }
}

///|
pub fn Week::from_name(name : String) -> Result[Week, String] {
  match LoopTyme::from_name(week_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Week::get_index(self : Week) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn Week::get_size(self : Week) -> Int {
  self.loop_tyme.get_size()
}

///|
pub fn Week::steps_to(self : Week, target_index : Int) -> Int {
  self.loop_tyme.steps_to(target_index)
}

///|
pub fn Week::steps_back_to(self : Week, target_index : Int) -> Int {
  self.loop_tyme.steps_back_to(target_index)
}

///|
pub fn Week::steps_close_to(self : Week, target_index : Int) -> Int {
  self.loop_tyme.steps_close_to(target_index)
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
pub impl Culture for Week with fn get_name(self : Week) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Week with fn to_string(self : Week) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Week with fn next(self : Week, n : Int) -> Week {
  Week::from_index(self.loop_tyme.get_index() + n)
}
