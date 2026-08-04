///|
// China95ChildLimitProvider 元亨利贞的童限计算
#warnings("-struct_never_constructed")
pub struct China95ChildLimitProvider {}

///|
impl IChildLimitProvider for China95ChildLimitProvider with fn get_info(
  _ : China95ChildLimitProvider,
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
  AbstractChildLimitProvider::next(birth_time, year, month, day, 0, 0, 0)
}
