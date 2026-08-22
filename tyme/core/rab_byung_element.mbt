///|
// rab_byung_element_names 藏历五行名称
pub fn rab_byung_element_names() -> Array[String] {
  ["木", "火", "土", "铁", "水"]
}

///|
// RabByungElement 藏历五行
pub struct RabByungElement {
  element : Element
}

///|
pub extend RabByungElement with Culture::{get_name}

///|
pub extend RabByungElement with Tyme::{next}

///|
pub fn RabByungElement::from_index(index : Int) -> RabByungElement {
  {
    element: {
      loop_tyme: LoopTyme::from_index(rab_byung_element_names(), index),
    },
  }
}

///|
pub fn RabByungElement::from_name(
  name : String,
) -> Result[RabByungElement, String] {
  match LoopTyme::from_name(rab_byung_element_names(), name) {
    Ok(p) => Ok({ element: { loop_tyme: p } })
    Err(e) => Err(e)
  }
}

///|
pub fn RabByungElement::get_index(self : RabByungElement) -> Int {
  self.element.get_index()
}

///|
// get_element 五行
pub fn RabByungElement::get_element(self : RabByungElement) -> Element {
  self.element
}

///|
// get_reinforce 我生者
pub fn RabByungElement::get_reinforce(
  self : RabByungElement,
) -> RabByungElement {
  self.next(1)
}

///|
// get_restrain 我克者
pub fn RabByungElement::get_restrain(self : RabByungElement) -> RabByungElement {
  self.next(2)
}

///|
// get_reinforced 生我者
pub fn RabByungElement::get_reinforced(
  self : RabByungElement,
) -> RabByungElement {
  self.next(-1)
}

///|
// get_restrained 克我者
pub fn RabByungElement::get_restrained(
  self : RabByungElement,
) -> RabByungElement {
  self.next(-2)
}

///|
pub impl Culture for RabByungElement with fn get_name(self : RabByungElement) -> String {
  self.element.get_name()
}

///|
pub impl Show for RabByungElement with fn to_string(self : RabByungElement) -> String {
  self.element.get_name()
}

///|
pub impl Tyme for RabByungElement with fn next(self : RabByungElement, n : Int) -> RabByungElement {
  RabByungElement::from_index(self.element.get_index() + n)
}

///|
pub extend RabByungElement with Show::{to_string}
