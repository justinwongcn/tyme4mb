///|
// AbstractCulture 传统文化抽象
pub struct AbstractCulture {
}

///|
extend AbstractCulture with Culture::{get_name}

///|
extend AbstractCulture with Show::{to_string}

///|
// index_of 转换为不超范围的索引
pub fn AbstractCulture::index_of(index : Int, size : Int) -> Int {
  let i = index % size
  if i < 0 {
    i + size
  } else {
    i
  }
}

///|
// floor_div 向下取整的除法（向负无穷取整）
pub fn AbstractCulture::floor_div(x : Int, y : Int) -> Int {
  let r = x / y
  if (x ^ y) < 0 && r * y != x {
    r - 1
  } else {
    r
  }
}

///|
impl Culture for AbstractCulture with get_name(_ : AbstractCulture) -> String {
  ""
}

///|
impl Show for AbstractCulture with to_string(self : AbstractCulture) -> String {
  self.get_name()
}

///|
pub fn AbstractCulture::equals(self : AbstractCulture, target : AbstractCulture) -> Bool {
  self.to_string() == target.to_string()
}
