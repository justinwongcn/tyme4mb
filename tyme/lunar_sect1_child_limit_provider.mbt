///|
// LunarSect1ChildLimitProvider Lunar的流派1童限计算（按天数和时辰数计算，3天1年，1天4个月，1时辰10天）
pub struct LunarSect1ChildLimitProvider {}

///|
impl IChildLimitProvider for LunarSect1ChildLimitProvider with fn get_info(
  self : LunarSect1ChildLimitProvider,
  birth_time : SolarTime,
  term : SolarTerm,
) -> ChildLimitInfo {
  let term_time = term.get_julian_day().get_solar_time()
  let mut end = term_time
  let mut start = birth_time
  if birth_time.is_after(term_time) {
    end = birth_time
    start = term_time
  }
  let mut end_time_zhi_index = 11
  if end.get_hour() != 23 {
    end_time_zhi_index = end.get_lunar_hour().get_index_in_day()
  }
  let mut start_time_zhi_index = 11
  if start.get_hour() != 23 {
    start_time_zhi_index = start.get_lunar_hour().get_index_in_day()
  }
  // 时辰差
  let mut hour_diff = end_time_zhi_index - start_time_zhi_index
  // 天数差
  let mut day_diff = end.get_solar_day().subtract(start.get_solar_day())
  if hour_diff < 0 {
    hour_diff = hour_diff + 12
    day_diff = day_diff - 1
  }
  let month_diff = hour_diff * 10 / 30
  let mut month = day_diff * 4 + month_diff
  let day = hour_diff * 10 - month_diff * 30
  let year = month / 12
  month = month - year * 12
  AbstractChildLimitProvider::next(birth_time, year, month, day, 0, 0, 0)
}

///|
extend LunarSect1ChildLimitProvider with IChildLimitProvider::{get_info}
