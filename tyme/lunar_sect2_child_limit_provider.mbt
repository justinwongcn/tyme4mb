///|
// LunarSect2ChildLimitProvider Lunar的流派2童限计算（按分钟数计算）
#warnings("-struct_never_constructed")
pub struct LunarSect2ChildLimitProvider {}

///|
impl IChildLimitProvider for LunarSect2ChildLimitProvider with fn get_info(
  _ : LunarSect2ChildLimitProvider,
  birth_time : SolarTime,
  term : SolarTerm,
) -> ChildLimitInfo {
  // 出生时刻和节令时刻相差的分钟数
  let diff = term.get_julian_day().get_solar_time().subtract(birth_time)
  let mut minutes = (if diff < 0L { -diff } else { diff }).to_int() / 60
  let year = minutes / 4320
  minutes = minutes % 4320
  let month = minutes / 360
  minutes = minutes % 360
  let day = minutes / 12
  minutes = minutes % 12
  let hour = minutes * 2
  AbstractChildLimitProvider::next(birth_time, year, month, day, hour, 0, 0)
}
