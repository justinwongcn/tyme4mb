///|
// animal_names 动物名称
pub fn animal_names() -> Array[String] {
  [
    "蛟", "龙", "貉", "兔", "狐", "虎", "豹", "獬", "牛", "蝠", "鼠", "燕", "猪",
    "獝", "狼", "狗", "彘", "鸡", "乌", "猴", "猿", "犴", "羊", "獐", "马", "鹿", "蛇", "蚓",
  ]
}

///|
// Animal 动物
pub struct Animal {
  loop_tyme : LoopTyme
}

///|
extend Animal with Culture::{get_name}

///|
extend Animal with Show::{to_string}

///|
extend Animal with Tyme::{next}

///|
pub fn Animal::from_index(index : Int) -> Animal {
  Animal::{ loop_tyme: LoopTyme::from_index(animal_names(), index) }
}

///|
pub fn Animal::from_name(name : String) -> Result[Animal, String] {
  match LoopTyme::from_name(animal_names(), name) {
    Ok(p) => Ok(Animal::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Animal::get_index(self : Animal) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Animal with get_name(self : Animal) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Animal with to_string(self : Animal) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Animal with next(self : Animal, n : Int) -> Animal {
  Animal::from_index(self.loop_tyme.get_index() + n)
}
