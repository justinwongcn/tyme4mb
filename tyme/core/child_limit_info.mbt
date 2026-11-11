///|
// ChildLimitInfo 童限信息
pub struct ChildLimitInfo {
  // 开始(即出生)的公历时刻
  start_time : SolarTime
  // 结束(即开始起运)的公历时刻
  end_time : SolarTime
  // 年数
  year_count : Int32
  // 月数
  month_count : Int32
  // 日数
  day_count : Int32
  // 小时数
  hour_count : Int32
  // 分钟数
  minute_count : Int32
}

///|
// New 童限信息
pub fn ChildLimitInfo::new(
  start_time : SolarTime,
  end_time : SolarTime,
  year_count : Int32,
  month_count : Int32,
  day_count : Int32,
  hour_count : Int32,
  minute_count : Int32,
) -> ChildLimitInfo {
  {
    start_time,
    end_time,
    year_count,
    month_count,
    day_count,
    hour_count,
    minute_count,
  }
}

///|
// get_start_time 开始(即出生)的公历时刻
pub fn ChildLimitInfo::get_start_time(self : ChildLimitInfo) -> SolarTime {
  self.start_time
}

///|
// get_end_time 结束(即开始起运)的公历时刻
pub fn ChildLimitInfo::get_end_time(self : ChildLimitInfo) -> SolarTime {
  self.end_time
}

///|
// get_year_count 年数
pub fn ChildLimitInfo::get_year_count(self : ChildLimitInfo) -> Int32 {
  self.year_count
}

///|
// get_month_count 月数
pub fn ChildLimitInfo::get_month_count(self : ChildLimitInfo) -> Int32 {
  self.month_count
}

///|
// get_day_count 日数
pub fn ChildLimitInfo::get_day_count(self : ChildLimitInfo) -> Int32 {
  self.day_count
}

///|
// get_hour_count 小时数
pub fn ChildLimitInfo::get_hour_count(self : ChildLimitInfo) -> Int32 {
  self.hour_count
}

///|
// get_minute_count 分钟数
pub fn ChildLimitInfo::get_minute_count(self : ChildLimitInfo) -> Int32 {
  self.minute_count
}

///|
pub impl Show for ChildLimitInfo with fn to_string(self : ChildLimitInfo) -> String {
  self.get_year_count().to_string() +
  "年" +
  self.get_month_count().to_string() +
  "个月" +
  self.get_day_count().to_string() +
  "天" +
  self.get_hour_count().to_string() +
  "小时" +
  self.get_minute_count().to_string() +
  "分钟"
}

///|
pub extend ChildLimitInfo with Show::{to_string, output}
