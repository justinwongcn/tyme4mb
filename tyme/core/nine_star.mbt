///|
// nine_star_names 九星名称
pub fn nine_star_names() -> Array[String] {
  ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
}

///|
// nine_star_colors 九星颜色
pub fn nine_star_colors() -> Array[String] {
  ["白", "黑", "碧", "绿", "黄", "白", "赤", "白", "紫"]
}

///|
// NineStar 九星
pub struct NineStar {
  loop_tyme : LoopTyme
}

///|
pub extend NineStar with Culture::{get_name}

///|
pub fn NineStar::from_index(index : Int) -> NineStar {
  { loop_tyme: LoopTyme::from_index(nine_star_names(), index) }
}

///|
pub fn NineStar::from_name(name : String) -> Result[NineStar, String] {
  match LoopTyme::from_name(nine_star_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn NineStar::get_index(self : NineStar) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_color 颜色
pub fn NineStar::get_color(self : NineStar) -> String {
  nine_star_colors()[self.loop_tyme.get_index()]
}

///|
// get_element 五行
pub fn NineStar::get_element(self : NineStar) -> Element {
  self.get_direction().get_element()
}

///|
// get_dipper 北斗九星
pub fn NineStar::get_dipper(self : NineStar) -> Dipper {
  Dipper::from_index(self.loop_tyme.get_index())
}

///|
// get_direction 方位
pub fn NineStar::get_direction(self : NineStar) -> Direction {
  Direction::from_index(self.loop_tyme.get_index())
}

///|
pub impl Culture for NineStar with fn get_name(self : NineStar) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for NineStar with fn to_string(self : NineStar) -> String {
  "\{self.get_name()}\{self.get_color()}\{self.get_element()}"
}

///|
pub impl Tyme for NineStar with fn next(self : NineStar, n : Int) -> NineStar {
  NineStar::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend NineStar with Show::{to_string}
