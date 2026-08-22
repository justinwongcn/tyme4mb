///|
// Gender 性别
pub(all) enum Gender {
  Woman // 女
  Man // 男
}

///|
pub fn Gender::get_code(self : Gender) -> Int {
  match self {
    Woman => 0
    Man => 1
  }
}

///|
pub fn Gender::from_code(code : Int) -> Gender {
  match code {
    1 => Man
    _ => Woman
  }
}

///|
pub fn Gender::get_name(self : Gender) -> String {
  match self {
    Woman => "女"
    Man => "男"
  }
}

///|
pub impl Show for Gender with fn to_string(self : Gender) -> String {
  self.get_name()
}

///|
pub extend Gender with Show::{to_string}
