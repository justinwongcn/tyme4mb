///|
// AbstractTyme 抽象Tyme
pub struct AbstractTyme {
}

///|
extend AbstractTyme with Culture::{get_name}

///|
extend AbstractTyme with Show::{to_string}

///|
impl Culture for AbstractTyme with get_name(_ : AbstractTyme) -> String {
  ""
}

///|
impl Show for AbstractTyme with to_string(self : AbstractTyme) -> String {
  self.get_name()
}
