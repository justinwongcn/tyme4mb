///|
// AbstractCulture 传统文化抽象
#warnings("-struct_never_constructed")
pub struct AbstractCulture {}

///|
pub extend AbstractCulture with Culture::{get_name}

///|
pub extend AbstractCulture with Show::{to_string, output}

///|
// index_of 转换为不超范围的索引
pub fn AbstractCulture::index_of(index : Int32, size : Int32) -> Int32 {
  let i = index % size
  if i < 0 {
    i + size
  } else {
    i
  }
}

///|
// floor_div 向下取整的除法（向负无穷取整）
pub fn AbstractCulture::floor_div(x : Int32, y : Int32) -> Int32 {
  let r = x / y
  if (x ^ y) < 0 && r * y != x {
    r - 1
  } else {
    r
  }
}

///|
pub impl Culture for AbstractCulture with fn get_name(_ : AbstractCulture) -> String {
  ""
}

///|
pub impl Show for AbstractCulture with fn to_string(self : AbstractCulture) -> String {
  self.get_name()
}

///|
pub fn AbstractCulture::equals(
  self : AbstractCulture,
  target : AbstractCulture,
) -> Bool {
  self.to_string() == target.to_string()
}
