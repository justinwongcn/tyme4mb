///|
// DefaultEightCharProvider 默认的八字计算（晚子时算第二天）
pub struct DefaultEightCharProvider {
}

///|
impl IEightCharProvider for DefaultEightCharProvider with get_eight_char(
  self : DefaultEightCharProvider,
  hour : LunarHour,
) -> EightChar {
  hour.get_sixty_cycle_hour().get_eight_char()
}
