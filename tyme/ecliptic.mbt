///|
// EclipticNames 黄道黑道名称
pub fn ecliptic_names() -> Array[String] {
  ["黄道", "黑道"]
}

///|
// Ecliptic 黄道黑道
pub struct Ecliptic {
  loop_tyme : LoopTyme
}

///|
extend Ecliptic with Culture::{get_name}

///|
extend Ecliptic with Show::{to_string}

///|
extend Ecliptic with Tyme::{next}

///|
pub fn Ecliptic::from_index(index : Int) -> Ecliptic {
  Ecliptic::{ loop_tyme: LoopTyme::from_index(ecliptic_names(), index) }
}

///|
pub fn Ecliptic::from_name(name : String) -> Result[Ecliptic, String] {
  match LoopTyme::from_name(ecliptic_names(), name) {
    Ok(p) => Ok(Ecliptic::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Ecliptic::equals(self : Ecliptic, target : Ecliptic) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_luck 吉凶
pub fn Ecliptic::get_luck(self : Ecliptic) -> Luck {
  Luck::from_index(self.loop_tyme.get_index())
}

///|
impl Culture for Ecliptic with get_name(self : Ecliptic) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Ecliptic with to_string(self : Ecliptic) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Ecliptic with next(self : Ecliptic, n : Int) -> Ecliptic {
  Ecliptic::from_index(self.loop_tyme.get_index() + n)
}
