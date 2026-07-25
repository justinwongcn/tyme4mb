///|
// MonthUnit 月
pub struct MonthUnit {
  year_unit : YearUnit
  month : Int
}

///|
extend MonthUnit with Culture::{get_name}

///|
extend MonthUnit with Show::{to_string}

///|
pub fn MonthUnit::new(year_unit : YearUnit, month : Int) -> MonthUnit {
  { year_unit, month }
}

///|
// get_month 月
pub fn MonthUnit::get_month(self : MonthUnit) -> Int {
  self.month
}

///|
// get_compare_index 用于比较大小的索引
pub fn MonthUnit::get_compare_index(self : MonthUnit) -> Int {
  let m = if self.month > 0 {
    self.month * 2
  } else {
    -self.month * 2 + 1
  }
  self.year_unit.get_compare_index() + m * 100
}

///|
impl Culture for MonthUnit with get_name(self : MonthUnit) -> String {
  self.year_unit.get_name()
}

///|
impl Show for MonthUnit with to_string(self : MonthUnit) -> String {
  self.get_name()
}
