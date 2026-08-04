///|
// LoopTyme 可轮回的Tyme
pub struct LoopTyme {
  names : Array[String]
  mut index : Int
}

///|
extend LoopTyme with Culture::{get_name}

///|
extend LoopTyme with Show::{to_string}

///|
pub fn LoopTyme::get_index(self : LoopTyme) -> Int {
  self.index
}

///|
pub fn LoopTyme::get_size(self : LoopTyme) -> Int {
  self.names.length()
}

///|
fn LoopTyme::index_of_name(
  self : LoopTyme,
  name : String,
) -> Result[Int, String] {
  for i, v in self.names {
    if v == name {
      return Ok(i)
    }
  }
  Err("illegal name: " + name)
}

///|
fn LoopTyme::index_of(self : LoopTyme, index : Int) -> Int {
  AbstractCulture::index_of(index, self.get_size())
}

///|
fn LoopTyme::next_index(self : LoopTyme, n : Int) -> Int {
  self.index_of(self.index + n)
}

///|
pub fn LoopTyme::steps_to(self : LoopTyme, target_index : Int) -> Int {
  self.index_of(target_index - self.index)
}

///|
pub fn LoopTyme::steps_back_to(self : LoopTyme, target_index : Int) -> Int {
  let n = self.get_size()
  -((self.index - target_index + n) % n)
}

///|
pub fn LoopTyme::steps_close_to(self : LoopTyme, target_index : Int) -> Int {
  let d1 = self.steps_to(target_index)
  let d2 = self.steps_back_to(target_index)
  let mut t = d2
  if t < 0 {
    t = -t
  }
  if d1 <= t {
    d1
  } else {
    d2
  }
}

///|
pub fn LoopTyme::from_index(names : Array[String], index : Int) -> LoopTyme {
  let instance = LoopTyme::{ names, index: 0 }
  instance.index = instance.next_index(index)
  instance
}

///|
pub fn LoopTyme::from_name(
  names : Array[String],
  name : String,
) -> Result[LoopTyme, String] {
  let instance = LoopTyme::{ names, index: 0 }
  match instance.index_of_name(name) {
    Ok(index) => {
      instance.index = index
      Ok(instance)
    }
    Err(e) => Err(e)
  }
}

///|
impl Culture for LoopTyme with fn get_name(self : LoopTyme) -> String {
  self.names[self.index]
}

///|
impl Show for LoopTyme with fn to_string(self : LoopTyme) -> String {
  self.get_name()
}

///|
pub fn LoopTyme::equals(self : LoopTyme, target : LoopTyme) -> Bool {
  self.to_string() == target.to_string()
}
