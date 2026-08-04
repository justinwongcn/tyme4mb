///|
// DefaultChildLimitProvider 默认的童限计算
pub struct DefaultChildLimitProvider {}

///|
impl IChildLimitProvider for DefaultChildLimitProvider with fn get_info(
  self : DefaultChildLimitProvider,
  birth_time : SolarTime,
  term : SolarTerm,
) -> ChildLimitInfo {
  // 出生时刻和节令时刻相差的秒数
  let diff = term.get_julian_day().get_solar_time().subtract(birth_time)
  let mut seconds = (if diff < 0L { -diff } else { diff }).to_int()
  // 3天 = 1年，3天=60*60*24*3秒=259200秒 = 1年
  let year = seconds / 259200
  seconds = seconds % 259200
  // 1天 = 4月，1天=60*60*24秒=86400秒 = 4月，85400秒/4=21600秒 = 1月
  let month = seconds / 21600
  seconds = seconds % 21600
  // 1时 = 5天，1时=60*60秒=3600秒 = 5天，3600秒/5=720秒 = 1天
  let day = seconds / 720
  seconds = seconds % 720
  // 1分 = 2时，60秒 = 2时，60秒/2=30秒 = 1时
  let hour = seconds / 30
  seconds = seconds % 30
  // 1秒 = 2分，1秒/2=0.5秒 = 1分
  let minute = seconds * 2
  AbstractChildLimitProvider::next(
    birth_time, year, month, day, hour, minute, 0,
  )
}
