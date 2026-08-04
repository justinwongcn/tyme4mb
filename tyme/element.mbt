///|
// ElementNames 五行名称
pub fn element_names() -> Array[String] {
  ["木", "火", "土", "金", "水"]
}

///|
// Element 五行
pub struct Element {
  loop_tyme : LoopTyme
}

///|
extend Element with Culture::{get_name}

///|
extend Element with Show::{to_string}

///|
extend Element with Tyme::{next}

///|
pub fn Element::get_index(self : Element) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn Element::from_index(index : Int) -> Element {
  { loop_tyme: LoopTyme::from_index(element_names(), index) }
}

///|
pub fn Element::from_name(name : String) -> Result[Element, String] {
  match LoopTyme::from_name(element_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Element::equals(self : Element, target : Element) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_reinforce 我生者
pub fn Element::get_reinforce(self : Element) -> Element {
  self.next(1)
}

///|
// get_restrain 我克者
pub fn Element::get_restrain(self : Element) -> Element {
  self.next(2)
}

///|
// get_reinforced 生我者
pub fn Element::get_reinforced(self : Element) -> Element {
  self.next(-1)
}

///|
// get_restrained 克我者
pub fn Element::get_restrained(self : Element) -> Element {
  self.next(-2)
}

///|
// get_direction 方位
pub fn Element::get_direction(self : Element) -> Direction {
  let a = [2, 8, 4, 6, 0]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
pub impl Culture for Element with fn get_name(self : Element) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Element with fn to_string(self : Element) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Element with fn next(self : Element, n : Int) -> Element {
  Element::from_index(self.loop_tyme.get_index() + n)
}
