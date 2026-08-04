///|
// YinYang 阴阳
pub(all) enum YinYang {
  Yin // 阴
  Yang // 阳
}

///|
pub fn YinYang::get_code(self : YinYang) -> Int {
  match self {
    Yin => 0
    Yang => 1
  }
}

///|
pub fn YinYang::from_code(code : Int) -> YinYang {
  match code {
    1 => Yang
    _ => Yin
  }
}

///|
pub fn YinYang::get_name(self : YinYang) -> String {
  match self {
    Yin => "阴"
    Yang => "阳"
  }
}

///|
pub impl Show for YinYang with fn to_string(self : YinYang) -> String {
  self.get_name()
}
