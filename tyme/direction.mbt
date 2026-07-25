///|
// DirectionNames 方位名称，依据后天八卦排序（0坎北, 1坤西南, 2震东, 3巽东南, 4中, 5乾西北, 6兑西, 7艮东北, 8离南）
pub fn direction_names() -> Array[String] {
  ["北", "西南", "东", "东南", "中", "西北", "西", "东北", "南"]
}

///|
// Direction 方位
pub struct Direction {
  loop_tyme : LoopTyme
}

///|
extend Direction with Culture::{get_name}

///|
extend Direction with Show::{to_string}

///|
extend Direction with Tyme::{next}

///|
pub fn Direction::get_index(self : Direction) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn Direction::from_index(index : Int) -> Direction {
  Direction::{ loop_tyme: LoopTyme::from_index(direction_names(), index) }
}

///|
pub fn Direction::from_name(name : String) -> Result[Direction, String] {
  match LoopTyme::from_name(direction_names(), name) {
    Ok(p) => Ok(Direction::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Direction::equals(self : Direction, target : Direction) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_land 九野
pub fn Direction::get_land(self : Direction) -> Land {
  Land::from_index(self.loop_tyme.get_index())
}

///|
// get_element 五行
pub fn Direction::get_element(self : Direction) -> Element {
  let a = [4, 2, 0, 0, 2, 3, 3, 2, 1]
  Element::from_index(a[self.loop_tyme.get_index()])
}

///|
impl Culture for Direction with get_name(self : Direction) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Direction with to_string(self : Direction) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Direction with next(self : Direction, n : Int) -> Direction {
  Direction::from_index(self.loop_tyme.get_index() + n)
}
