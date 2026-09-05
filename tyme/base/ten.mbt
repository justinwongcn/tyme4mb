///|
// ten_names 旬名称
pub fn ten_names() -> Array[String] {
  ["甲子", "甲戌", "甲申", "甲午", "甲辰", "甲寅"]
}

///|
// Ten 旬
pub struct Ten {
  loop_tyme : LoopTyme
}

///|
pub fn Ten::from_index(index : Int) -> Ten {
  { loop_tyme: LoopTyme::from_index(ten_names(), index), }
}

///|
pub fn Ten::from_name(name : String) -> Result[Ten, String] {
  match LoopTyme::from_name(ten_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn Ten::get_index(self : Ten) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Ten with fn get_name(self : Ten) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Ten with fn to_string(self : Ten) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Ten with fn next(self : Ten, n : Int) -> Ten {
  Ten::from_index(self.loop_tyme.get_index() + n)
}
