///|
// MonthUnit 月
pub struct MonthUnit {
  year_unit : YearUnit
  month : Int
}

///|
extend MonthUnit with Culture::{get_name}

///|
pub fn MonthUnit::new(year_unit : YearUnit, month : Int) -> MonthUnit {
  { year_unit, month, }
}

///|
// get_month 月
pub fn MonthUnit::get_month(self : MonthUnit) -> Int {
  self.month
}

///|
// get_compare_index 用于比较大小的索引
pub fn MonthUnit::get_compare_index(self : MonthUnit) -> Int {
  let m = if self.month > 0 { self.month * 2 } else { -self.month * 2 + 1 }
  self.year_unit.get_compare_index() + m * 100
}

///|
pub impl Culture for MonthUnit with fn get_name(self : MonthUnit) -> String {
  self.year_unit.get_name()
}

///|
pub impl Show for MonthUnit with fn to_string(self : MonthUnit) -> String {
  self.get_name()
}
