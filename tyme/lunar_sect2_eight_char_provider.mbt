///|
// LunarSect2EightCharProvider Lunar流派2的八字计算（晚子时日柱算当天）
#warnings("-struct_never_constructed")
pub struct LunarSect2EightCharProvider {}

///|
impl IEightCharProvider for LunarSect2EightCharProvider with fn get_eight_char(
  _ : LunarSect2EightCharProvider,
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
