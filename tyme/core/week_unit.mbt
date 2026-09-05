///|
// week_unit_names 周名称
pub fn week_unit_names() -> Array[String] {
  ["第一周", "第二周", "第三周", "第四周", "第五周", "第六周"]
}

///|
// WeekUnit 周
pub struct WeekUnit {
  month_unit : MonthUnit
  // 索引，0-5
  index : Int
  // 起始星期，1234560分别代表星期一至星期天
  start : Int
}

///|
extend WeekUnit with Culture::{get_name}

///|
pub fn WeekUnit::new(
  month_unit : MonthUnit,
  index : Int,
  start : Int,
) -> WeekUnit {
  { month_unit, index, start, }
}

///|
// get_index 索引，0-5
pub fn WeekUnit::get_index(self : WeekUnit) -> Int {
  self.index
}

///|
// get_start 起始星期
pub fn WeekUnit::get_start(self : WeekUnit) -> Week {
  Week::from_index(self.start)
}

///|
// get_compare_index 用于比较大小的索引
pub fn WeekUnit::get_compare_index(self : WeekUnit) -> Int {
  self.month_unit.get_compare_index()
}

///|
// validate 校验
pub fn WeekUnit::validate(
  _year : Int,
  _month : Int,
  index : Int,
  start : Int,
) -> Result[Unit, String] {
  if index < 0 || index > 5 {
    return Err("illegal week index: " + index.to_string())
  }
  if start < 0 || start > 6 {
    return Err("illegal week start: " + start.to_string())
  }
  Ok(())
}

///|
pub impl Culture for WeekUnit with fn get_name(self : WeekUnit) -> String {
  self.month_unit.get_name()
}

///|
pub impl Show for WeekUnit with fn to_string(self : WeekUnit) -> String {
  self.get_name()
}
