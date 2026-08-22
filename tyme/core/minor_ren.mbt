///|
// minor_ren_names 小六壬名称
pub fn minor_ren_names() -> Array[String] {
  ["大安", "留连", "速喜", "赤口", "小吉", "空亡"]
}

///|
// MinorRen 小六壬
pub struct MinorRen {
  loop_tyme : LoopTyme
}

///|
pub extend MinorRen with Tyme::{next}

///|
pub fn MinorRen::from_index(index : Int) -> MinorRen {
  { loop_tyme: LoopTyme::from_index(minor_ren_names(), index) }
}

///|
pub fn MinorRen::from_name(name : String) -> Result[MinorRen, String] {
  match LoopTyme::from_name(minor_ren_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn MinorRen::get_index(self : MinorRen) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_luck 吉凶
pub fn MinorRen::get_luck(self : MinorRen) -> Luck {
  Luck::from_index(self.loop_tyme.get_index() % 2)
}

///|
// get_element 五行
pub fn MinorRen::get_element(self : MinorRen) -> Element {
  let a = [0, 4, 1, 3, 0, 2]
  Element::from_index(a[self.loop_tyme.get_index()])
}

///|
pub impl Culture for MinorRen with fn get_name(self : MinorRen) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for MinorRen with fn to_string(self : MinorRen) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for MinorRen with fn next(self : MinorRen, n : Int) -> MinorRen {
  MinorRen::from_index(self.loop_tyme.get_index() + n)
}

///|
pub extend MinorRen with Culture::{get_name}

///|
pub extend MinorRen with Show::{to_string}
