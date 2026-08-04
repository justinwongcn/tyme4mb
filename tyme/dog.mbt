///|
// dog_names 三伏名称
pub fn dog_names() -> Array[String] {
  ["初伏", "中伏", "末伏"]
}

///|
// Dog 三伏
pub struct Dog {
  loop_tyme : LoopTyme
}

///|
extend Dog with Culture::{get_name}

///|
extend Dog with Show::{to_string}

///|
extend Dog with Tyme::{next}

///|
pub fn Dog::from_index(index : Int) -> Dog {
  Dog::{ loop_tyme: LoopTyme::from_index(dog_names(), index) }
}

///|
pub fn Dog::from_name(name : String) -> Result[Dog, String] {
  match LoopTyme::from_name(dog_names(), name) {
    Ok(p) => Ok(Dog::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Dog::get_index(self : Dog) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Dog with fn get_name(self : Dog) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Dog with fn to_string(self : Dog) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Dog with fn next(self : Dog, n : Int) -> Dog {
  Dog::from_index(self.loop_tyme.get_index() + n)
}
