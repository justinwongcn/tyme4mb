///|
// TwelveStarNames 黄道黑道十二神名称
pub fn twelve_star_names() -> Array[String] {
  [
    "青龙", "明堂", "天刑", "朱雀", "金匮", "天德", "白虎", "玉堂",
    "天牢", "玄武", "司命", "勾陈",
  ]
}

///|
// TwelveStar 黄道黑道十二神
pub struct TwelveStar {
  loop_tyme : LoopTyme
}

///|
pub extend TwelveStar with Show::{to_string}

///|
pub fn TwelveStar::from_index(index : Int) -> TwelveStar {
  { loop_tyme: LoopTyme::from_index(twelve_star_names(), index), }
}

///|
pub fn TwelveStar::from_name(name : String) -> Result[TwelveStar, String] {
  match LoopTyme::from_name(twelve_star_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn TwelveStar::equals(self : TwelveStar, target : TwelveStar) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_ecliptic 黄道黑道
pub fn TwelveStar::get_ecliptic(self : TwelveStar) -> Ecliptic {
  let a = [0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1]
  Ecliptic::from_index(a[self.loop_tyme.get_index()])
}

///|
pub impl Culture for TwelveStar with fn get_name(self : TwelveStar) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for TwelveStar with fn to_string(self : TwelveStar) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for TwelveStar with fn next(self : TwelveStar, n : Int) -> TwelveStar {
  TwelveStar::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend TwelveStar with Culture::{get_name}
