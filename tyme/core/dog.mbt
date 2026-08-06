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
pub fn Dog::from_index(index : Int) -> Dog {
  { loop_tyme: LoopTyme::from_index(dog_names(), index) }
}

///|
pub fn Dog::from_name(name : String) -> Result[Dog, String] {
  match LoopTyme::from_name(dog_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Dog::get_index(self : Dog) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for Dog with fn get_name(self : Dog) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Dog with fn to_string(self : Dog) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Dog with fn next(self : Dog, n : Int) -> Dog {
  Dog::from_index(self.loop_tyme.get_index() + n)
}
