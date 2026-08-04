///|
// HideHeavenStemType 藏干类型
pub(all) enum HideHeavenStemType {
  Residual // 余气
  Middle // 中气
  Main // 本气
}

///|
pub fn HideHeavenStemType::get_code(self : HideHeavenStemType) -> Int {
  match self {
    Residual => 0
    Middle => 1
    Main => 2
  }
}

///|
pub fn HideHeavenStemType::from_code(code : Int) -> HideHeavenStemType {
  match code {
    1 => Middle
    2 => Main
    _ => Residual
  }
}

///|
pub fn HideHeavenStemType::get_name(self : HideHeavenStemType) -> String {
  match self {
    Residual => "余气"
    Middle => "中气"
    Main => "本气"
  }
}

///|
impl Show for HideHeavenStemType with fn to_string(self : HideHeavenStemType) -> String {
  self.get_name()
}

///|
extend HideHeavenStemType with Show::{to_string}
