///|
// DayUnit 日
pub struct DayUnit {
  month_unit : MonthUnit
  day : Int
}

///|
extend DayUnit with Culture::{get_name}

///|
pub extend DayUnit with Show::{to_string}

///|
pub fn DayUnit::new(month_unit : MonthUnit, day : Int) -> DayUnit {
  { month_unit, day, }
}

///|
// get_day 日
pub fn DayUnit::get_day(self : DayUnit) -> Int {
  self.day
}

///|
// get_compare_index 用于比较大小的索引
pub fn DayUnit::get_compare_index(self : DayUnit) -> Int {
  self.month_unit.get_compare_index() + self.day
}

///|
pub impl Culture for DayUnit with fn get_name(self : DayUnit) -> String {
  self.month_unit.get_name()
}

///|
pub impl Show for DayUnit with fn to_string(self : DayUnit) -> String {
  self.get_name()
}
