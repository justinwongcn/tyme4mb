///|
// YearUnit 年
pub struct YearUnit {
  abstract_tyme : AbstractTyme
  year : Int
}

///|
extend YearUnit with Culture::{get_name}

///|
extend YearUnit with Show::{to_string}

///|
pub fn YearUnit::new(year : Int) -> YearUnit {
  { abstract_tyme : AbstractTyme::{}, year }
}

///|
// get_year 年
pub fn YearUnit::get_year(self : YearUnit) -> Int {
  self.year
}

///|
// get_compare_index 用于比较大小的索引
pub fn YearUnit::get_compare_index(self : YearUnit) -> Int {
  self.year * 10000
}

///|
impl Culture for YearUnit with get_name(self : YearUnit) -> String {
  self.abstract_tyme.get_name()
}

///|
impl Show for YearUnit with to_string(self : YearUnit) -> String {
  self.get_name()
}
