///|
// AbstractTyme 抽象Tyme
pub struct AbstractTyme {}

///|
pub fn AbstractTyme::new() -> AbstractTyme {
  AbstractTyme::{ }
}

///|
pub extend AbstractTyme with Culture::{get_name}

///|
pub impl Culture for AbstractTyme with fn get_name(_ : AbstractTyme) -> String {
  ""
}

///|
pub extend AbstractTyme with Show::{to_string, output}

///|
pub impl Show for AbstractTyme with fn to_string(self : AbstractTyme) -> String {
  self.get_name()
}
