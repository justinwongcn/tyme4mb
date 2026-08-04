///|
// ten_star_names 十神名称
pub fn ten_star_names() -> Array[String] {
  [
    "比肩", "劫财", "食神", "伤官", "偏财", "正财", "七杀", "正官",
    "偏印", "正印",
  ]
}

///|
// TenStar 十神
pub struct TenStar {
  loop_tyme : LoopTyme
}

///|
extend TenStar with Culture::{get_name}

///|
extend TenStar with Show::{to_string}

///|
extend TenStar with Tyme::{next}

///|
pub fn TenStar::from_index(index : Int) -> TenStar {
  TenStar::{ loop_tyme: LoopTyme::from_index(ten_star_names(), index) }
}

///|
pub fn TenStar::from_name(name : String) -> Result[TenStar, String] {
  match LoopTyme::from_name(ten_star_names(), name) {
    Ok(p) => Ok(TenStar::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn TenStar::get_index(self : TenStar) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for TenStar with fn get_name(self : TenStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for TenStar with fn to_string(self : TenStar) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for TenStar with fn next(self : TenStar, n : Int) -> TenStar {
  TenStar::from_index(self.loop_tyme.get_index() + n)
}
