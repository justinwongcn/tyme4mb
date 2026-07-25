///|
// twenty_eight_star_names 二十八宿名称
pub fn twenty_eight_star_names() -> Array[String] {
  [
    "角", "亢", "氐", "房", "心", "尾", "箕", "斗", "牛", "女", "虚", "危", "室", "壁", "奎", "娄", "胃", "昴", "毕", "觜",
    "参", "井", "鬼", "柳", "星", "张", "翼", "轸",
  ]
}

///|
// TwentyEightStar 二十八宿
pub struct TwentyEightStar {
  loop_tyme : LoopTyme
}

///|
extend TwentyEightStar with Culture::{get_name}

///|
extend TwentyEightStar with Show::{to_string}

///|
extend TwentyEightStar with Tyme::{next}

///|
pub fn TwentyEightStar::from_index(index : Int) -> TwentyEightStar {
  TwentyEightStar::{
    loop_tyme: LoopTyme::from_index(twenty_eight_star_names(), index),
  }
}

///|
pub fn TwentyEightStar::from_name(
  name : String
) -> Result[TwentyEightStar, String] {
  match LoopTyme::from_name(twenty_eight_star_names(), name) {
    Ok(p) => Ok(TwentyEightStar::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn TwentyEightStar::get_index(self : TwentyEightStar) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_seven_star 七曜
pub fn TwentyEightStar::get_seven_star(self : TwentyEightStar) -> SevenStar {
  SevenStar::from_index(self.loop_tyme.get_index() % 7 + 4)
}

///|
// get_land 九野
pub fn TwentyEightStar::get_land(self : TwentyEightStar) -> Land {
  Land::from_index(
    [4, 4, 4, 2, 2, 2, 7, 7, 7, 0, 0, 0, 0, 5, 5, 5, 6, 6, 6, 1, 1, 1, 8, 8, 8, 3, 3, 3][self.loop_tyme.get_index()],
  )
}

///|
// get_zone 宫
pub fn TwentyEightStar::get_zone(self : TwentyEightStar) -> Zone {
  Zone::from_index(self.loop_tyme.get_index() / 7)
}

///|
// get_animal 动物
pub fn TwentyEightStar::get_animal(self : TwentyEightStar) -> Animal {
  Animal::from_index(self.loop_tyme.get_index())
}

///|
// get_luck 吉凶
pub fn TwentyEightStar::get_luck(self : TwentyEightStar) -> Luck {
  Luck::from_index(
    [0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0][self.loop_tyme.get_index()],
  )
}

///|
impl Culture for TwentyEightStar with get_name(self : TwentyEightStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for TwentyEightStar with to_string(self : TwentyEightStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for TwentyEightStar with next(
  self : TwentyEightStar,
  n : Int
) -> TwentyEightStar {
  TwentyEightStar::from_index(self.loop_tyme.get_index() + n)
}
