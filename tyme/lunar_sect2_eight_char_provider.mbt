///|
// LunarSect2EightCharProvider Lunar流派2的八字计算（晚子时日柱算当天）
pub struct LunarSect2EightCharProvider {
}

///|
impl IEightCharProvider for LunarSect2EightCharProvider with get_eight_char(
  self : LunarSect2EightCharProvider,
  hour : LunarHour,
) -> EightChar {
  let h = hour.get_sixty_cycle_hour()
  EightChar::from_sixty_cycle(
    h.get_year(),
    h.get_month(),
    hour.get_lunar_day().get_sixty_cycle(),
    h.get_sixty_cycle(),
  )
}
