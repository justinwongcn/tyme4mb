///|
// six_star_names 六曜名称
pub fn six_star_names() -> Array[String] {
  ["先胜", "友引", "先负", "佛灭", "大安", "赤口"]
}

///|
// SixStar 六曜（孔明六曜星）
pub struct SixStar {
  loop_tyme : LoopTyme
}

///|
extend SixStar with Culture::{get_name}

///|
extend SixStar with Show::{to_string}

///|
extend SixStar with Tyme::{next}

///|
pub fn SixStar::from_index(index : Int) -> SixStar {
  SixStar::{ loop_tyme: LoopTyme::from_index(six_star_names(), index) }
}

///|
pub fn SixStar::from_name(name : String) -> Result[SixStar, String] {
  match LoopTyme::from_name(six_star_names(), name) {
    Ok(p) => Ok(SixStar::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn SixStar::get_index(self : SixStar) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for SixStar with fn get_name(self : SixStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for SixStar with fn to_string(self : SixStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for SixStar with fn next(self : SixStar, n : Int) -> SixStar {
  SixStar::from_index(self.loop_tyme.get_index() + n)
}
