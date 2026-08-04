///|
// EventType 事件类型
pub(all) enum EventType {
  SolarDay // 公历日期
  SolarWeek // 几月第几个星期几
  LunarDay // 农历日期
  TermDay // 节气日期
  TermHs // 节气天干
  TermEb // 节气地支
}

///|
pub fn EventType::get_code(self : EventType) -> Int {
  match self {
    SolarDay => 0
    SolarWeek => 1
    LunarDay => 2
    TermDay => 3
    TermHs => 4
    TermEb => 5
  }
}

///|
pub fn EventType::from_code(code : Int) -> EventType {
  match code {
    1 => SolarWeek
    2 => LunarDay
    3 => TermDay
    4 => TermHs
    5 => TermEb
    _ => SolarDay
  }
}

///|
pub fn EventType::get_name(self : EventType) -> String {
  match self {
    SolarWeek => "几月第几个星期几"
    LunarDay => "农历日期"
    TermDay => "节气日期"
    TermHs => "节气天干"
    TermEb => "节气地支"
    SolarDay => "公历日期"
  }
}

///|
impl Show for EventType with fn to_string(self : EventType) -> String {
  self.get_name()
}

///|
extend EventType with Show::{to_string}
