///|
// Side 内外
pub(all) enum Side {
  In  // 内
  Out // 外
}

///|
pub fn Side::get_code(self : Side) -> Int {
  match self {
    In => 0
    Out => 1
  }
}

///|
pub fn Side::from_code(code : Int) -> Side {
  match code {
    1 => Out
    _ => In
  }
}

///|
pub fn Side::get_name(self : Side) -> String {
  match self {
    In => "内"
    Out => "外"
  }
}

///|
impl Show for Side with to_string(self : Side) -> String {
  self.get_name()
}
