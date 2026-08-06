///|
// nine_names 数九名称
pub fn nine_names() -> Array[String] {
  [
    "一九", "二九", "三九", "四九", "五九", "六九", "七九", "八九",
    "九九",
  ]
}

///|
// Nine 数九
pub struct Nine {
  loop_tyme : LoopTyme
}

///|
pub fn Nine::from_index(index : Int) -> Nine {
  { loop_tyme: LoopTyme::from_index(nine_names(), index) }
}

///|
pub fn Nine::from_name(name : String) -> Result[Nine, String] {
  match LoopTyme::from_name(nine_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Nine::get_index(self : Nine) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Nine with fn get_name(self : Nine) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Nine with fn to_string(self : Nine) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Nine with fn next(self : Nine, n : Int) -> Nine {
  Nine::from_index(self.loop_tyme.get_index() + n)
}
