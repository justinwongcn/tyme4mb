///|
// SecondUnit 秒
pub struct SecondUnit {
  day_unit : DayUnit
  hour : Int
  minute : Int
  second : Int
}

///|
extend SecondUnit with Culture::{get_name}

///|
extend SecondUnit with Show::{to_string}

///|
pub fn SecondUnit::new(
  day_unit : DayUnit,
  hour : Int,
  minute : Int,
  second : Int,
) -> SecondUnit {
  { day_unit, hour, minute, second }
}

///|
// get_hour 时
pub fn SecondUnit::get_hour(self : SecondUnit) -> Int {
  self.hour
}

///|
// get_minute 分
pub fn SecondUnit::get_minute(self : SecondUnit) -> Int {
  self.minute
}

///|
// get_second 秒
pub fn SecondUnit::get_second(self : SecondUnit) -> Int {
  self.second
}

///|
// validate 校验
pub fn SecondUnit::validate(
  _year : Int,
  _month : Int,
  _day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[Unit, String] {
  if hour < 0 || hour > 23 {
    return Err("illegal hour: " + hour.to_string())
  }
  if minute < 0 || minute > 59 {
    return Err("illegal minute: " + minute.to_string())
  }
  if second < 0 || second > 59 {
    return Err("illegal second: " + second.to_string())
  }
  Ok(())
}

///|
// get_seconds_in_day 当天秒数
pub fn SecondUnit::get_seconds_in_day(self : SecondUnit) -> Int {
  self.hour * 3600 + self.minute * 60 + self.second
}

///|
// get_compare_index 用于比较大小的索引
// 注意：day 索引乘以 SecondPerDay 后会超出 32 位范围（年份 >= 3 即溢出），因此这里必须用 Int64。
pub fn SecondUnit::get_compare_index(self : SecondUnit) -> Int64 {
  self.day_unit.get_compare_index().to_int64() * 86400L +
  self.get_seconds_in_day().to_int64()
}

///|
impl Culture for SecondUnit with fn get_name(self : SecondUnit) -> String {
  self.day_unit.get_name()
}

///|
impl Show for SecondUnit with fn to_string(self : SecondUnit) -> String {
  self.get_name()
}
