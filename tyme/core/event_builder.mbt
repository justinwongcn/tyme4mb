///|
// EventBuilder 事件构造器
pub struct EventBuilder {
  name : String
  data : String
}

///|
// new 事件构造器
pub fn EventBuilder::new() -> EventBuilder {
  { name: "", data: "@_____000", }
}

///|
// name 设置事件名称
pub fn EventBuilder::name(self : EventBuilder, name : String) -> EventBuilder {
  { name, data: self.data, }
}

///|
fn EventBuilder::get_char(_ : EventBuilder, index : Int) -> String {
  event_manager_chars()[index:index + 1].to_owned()
}

///|
fn EventBuilder::set_value(
  self : EventBuilder,
  index : Int,
  n : Int,
) -> EventBuilder {
  let c = event_manager_chars()[31 + n:32 + n].to_owned()
  {
    name: self.name,
    data: self.data[0:index].to_owned() + c + self.data[index + 1:].to_owned(),
  }
}

///|
#warnings("-unused_value")
fn EventBuilder::encode_type(t : EventType) -> String {
  event_manager_chars()[t.get_code():t.get_code() + 1].to_owned()
}

///|
fn EventBuilder::content(
  self : EventBuilder,
  t : EventType,
  a : Int,
  b : Int,
  c : Int,
) -> EventBuilder {
  let mut r = EventBuilder::{
    name: self.name,
    data: self.data[0:1].to_owned() +
    self.get_char(t.get_code()) +
    self.data[2:].to_owned(),
  }
  r = r.set_value(2, a)
  r = r.set_value(3, b)
  r = r.set_value(4, c)
  r
}

///|
// solar_day 公历日期
pub fn EventBuilder::solar_day(
  self : EventBuilder,
  solar_month : Int,
  solar_day : Int,
  delay_days : Int,
) -> EventBuilder {
  self.content(SolarDay, solar_month, solar_day, delay_days)
}

///|
// lunar_day 农历日期
pub fn EventBuilder::lunar_day(
  self : EventBuilder,
  lunar_month : Int,
  lunar_day : Int,
  delay_days : Int,
) -> EventBuilder {
  self.content(LunarDay, lunar_month, lunar_day, delay_days)
}

///|
// solar_week 几月第几个星期几
pub fn EventBuilder::solar_week(
  self : EventBuilder,
  solar_month : Int,
  week_index : Int,
  week : Int,
) -> EventBuilder {
  self.content(SolarWeek, solar_month, week_index, week)
}

///|
// term_day 节气日期
pub fn EventBuilder::term_day(
  self : EventBuilder,
  term_index : Int,
  delay_days : Int,
) -> EventBuilder {
  self.content(TermDay, term_index, 0, delay_days)
}

///|
// term_heaven_stem 节气天干
pub fn EventBuilder::term_heaven_stem(
  self : EventBuilder,
  term_index : Int,
  heaven_stem_index : Int,
  delay_days : Int,
) -> EventBuilder {
  self.content(TermHs, term_index, heaven_stem_index, delay_days)
}

///|
// term_earth_branch 节气地支
pub fn EventBuilder::term_earth_branch(
  self : EventBuilder,
  term_index : Int,
  earth_branch_index : Int,
  delay_days : Int,
) -> EventBuilder {
  self.content(TermEb, term_index, earth_branch_index, delay_days)
}

///|
// start_year 起始年
pub fn EventBuilder::start_year(
  self : EventBuilder,
  year : Int,
) -> EventBuilder {
  let size = event_manager_chars().length()
  let mut n = year
  let mut data = self.data
  for i = 0; i < 3; i = i + 1 {
    data = data[0:8 - i].to_owned() +
      self.get_char(n % size) +
      data[9 - i:].to_owned()
    n = n / size
  }
  { name: self.name, data, }
}

///|
// offset 偏移天数（最远支持-31至31天）
pub fn EventBuilder::offset(self : EventBuilder, days : Int) -> EventBuilder {
  self.set_value(5, days)
}

///|
// build 生成事件
pub fn EventBuilder::build(self : EventBuilder) -> Result[Event, String] {
  Event::new(self.name, self.data)
}
