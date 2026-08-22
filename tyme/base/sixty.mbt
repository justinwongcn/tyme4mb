///|
// sixty_names 元名称
pub fn sixty_names() -> Array[String] {
  ["上元", "中元", "下元"]
}

///|
// Sixty 元（60年=1元）
pub struct Sixty {
  loop_tyme : LoopTyme
}

///|
pub fn Sixty::from_index(index : Int) -> Sixty {
  { loop_tyme: LoopTyme::from_index(sixty_names(), index) }
}

///|
pub fn Sixty::from_name(name : String) -> Result[Sixty, String] {
  match LoopTyme::from_name(sixty_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Sixty::get_index(self : Sixty) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Sixty with fn get_name(self : Sixty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Sixty with fn to_string(self : Sixty) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Sixty with fn next(self : Sixty, n : Int) -> Sixty {
  Sixty::from_index(self.loop_tyme.get_index() + n)
}
