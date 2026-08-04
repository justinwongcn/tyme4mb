///|
// IEightCharProvider 八字计算接口
pub trait IEightCharProvider {
  // get_eight_char 根据农历时辰计算八字
  fn get_eight_char(Self, LunarHour) -> EightChar
}
