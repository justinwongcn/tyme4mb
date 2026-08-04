///|
// AbstractFestival 节日抽象
pub struct AbstractFestival {
  // 序号
  index : Int
  // 日
  day : DayUnit
  // 事件
  event : Event
}

///|
// new 构造
pub fn AbstractFestival::new(
  index : Int,
  event : Event,
  day : DayUnit,
) -> AbstractFestival {
  { index, event, day }
}

///|
// get_day 日
pub fn AbstractFestival::get_day(self : AbstractFestival) -> DayUnit {
  self.day
}

///|
// get_index 索引
pub fn AbstractFestival::get_index(self : AbstractFestival) -> Int {
  self.index
}

///|
impl Culture for AbstractFestival with fn get_name(self : AbstractFestival) -> String {
  self.event.get_name()
}

///|
extend AbstractFestival with Culture::{get_name}

///|
impl Show for AbstractFestival with fn to_string(self : AbstractFestival) -> String {
  self.get_day().to_string() + " " + Culture::get_name(self)
}
