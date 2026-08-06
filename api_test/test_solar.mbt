// 包外 API 测试：公历相关类型
// 验证 api.md 中所有公历相关接口可从包外调用

///|
test "SolarYear" {
  let sy = @tyme.SolarYear::from_year(2023).unwrap()
  let _ = sy.get_year()
  let _ = sy.get_day_count()
  let _ = sy.is_leap()
  let _ = sy.get_months()
  let _ = sy.get_half_years()
  let _ = sy.get_seasons()
  let _ = sy.get_rab_byung_year()
  let _ = sy.get_name()
  let _ = sy.to_string()
}

///|
test "SolarHalfYear" {
  let hy = @tyme.SolarHalfYear::from_index(2024, 0).unwrap()
  let _ = hy.get_year()
  let _ = hy.get_index()
  let _ = hy.get_months()
  let _ = hy.get_seasons()
  let _ = hy.get_solar_year()
  let _ = hy.get_name()
  let _ = hy.to_string()
}

///|
test "SolarSeason" {
  let ss = @tyme.SolarSeason::from_index(2024, 0).unwrap()
  let _ = ss.get_year()
  let _ = ss.get_index()
  let _ = ss.get_months()
  let _ = ss.get_solar_year()
  let _ = ss.get_name()
  let _ = ss.to_string()
}

///|
test "SolarMonth" {
  let sm = @tyme.SolarMonth::from_ym(2023, 5).unwrap()
  let _ = sm.get_solar_year()
  let _ = sm.get_month()
  let _ = sm.get_index_in_year()
  let _ = sm.get_day_count()
  let _ = sm.get_week_count(1)
  let _ = sm.get_weeks(1)
  let _ = sm.get_days()
  let _ = sm.get_first_day()
  let _ = sm.get_name()
  let _ = sm.to_string()
}

///|
test "SolarWeek" {
  let sw = @tyme.SolarWeek::from_ym(2023, 1, 0, 2).unwrap()
  let _ = sw.get_first_day()
  let _ = sw.get_days()
  let _ = sw.get_index_in_year()
  let _ = sw.get_index()
  let _ = sw.get_solar_month()
  let _ = sw.get_start()
  let _ = sw.get_name()
  let _ = sw.to_string()
  let sw2 = sw.next(1)
  let _ = sw2.get_name()
}

///|
test "SolarDay" {
  let sd = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap()
  let _ = sd.get_solar_month()
  let _ = sd.get_day()
  let _ = sd.get_week()
  let _ = sd.get_solar_week(0).unwrap()
  let _ = sd.get_constellation()
  let _ = sd.get_term()
  let _ = sd.get_term_day()
  let _ = sd.get_phenology_day()
  let _ = sd.get_phenology()
  let _ = sd.get_dog_day()
  let _ = sd.get_nine_day()
  let _ = sd.get_index_in_year()
  let _ = sd.get_festival()
  let _ = sd.get_legal_holiday()
  let _ = sd.get_lunar_day()
  let _ = sd.get_julian_day()
  let _ = sd.get_hijri_day()
  let _ = sd.get_rab_byung_day()
  let _ = sd.get_sixty_cycle_day()
  let _ = sd.get_phase()
  let _ = sd.get_phase_day()
  let _ = sd.get_plum_rain_day()
  let _ = sd.get_hide_heaven_stem_day()
  let _ = sd.get_nine_star()
  let _ = sd.is_before(@tyme.SolarDay::from_ymd(2023, 1, 2).unwrap())
  let _ = sd.is_after(@tyme.SolarDay::from_ymd(2023, 1, 2).unwrap())
  let _ = sd.subtract(@tyme.SolarDay::from_ymd(2023, 1, 2).unwrap())
  let _ = sd.get_name()
  let _ = sd.to_string()
  let sd2 = sd.next(1)
  let _ = sd2.get_name()
}

///|
test "SolarTime" {
  let st = @tyme.SolarTime::from_ymdhms(2023, 1, 1, 13, 0, 0).unwrap()
  let _ = st.get_solar_day()
  let _ = st.get_hour()
  let _ = st.get_minute()
  let _ = st.get_second()
  let _ = st.get_term()
  let _ = st.get_lunar_hour()
  let _ = st.get_julian_day()
  let _ = st.get_sixty_cycle_hour()
  let _ = st.get_phase()
  let _ = st.get_phenology()
  let _ = st.is_before(
    @tyme.SolarTime::from_ymdhms(2023, 1, 1, 14, 0, 0).unwrap(),
  )
  let _ = st.is_after(
    @tyme.SolarTime::from_ymdhms(2023, 1, 1, 14, 0, 0).unwrap(),
  )
  let _ = st.subtract(
    @tyme.SolarTime::from_ymdhms(2023, 1, 1, 14, 0, 0).unwrap(),
  )
  let _ = st.get_name()
  let _ = st.to_string()
  let st2 = st.next(3600)
  let _ = st2.get_name()
}

///|
test "JulianDay" {
  let jd = @tyme.JulianDay::from_julian_day(2459945.5)
  let _ = jd.get_day()
  let _ = jd.get_solar_day().unwrap()
  let _ = jd.get_solar_time().unwrap()
  let _ = jd.get_week()
  let _ = jd.subtract(@tyme.JulianDay::from_julian_day(2459946.5))
  let _ = jd.get_name()
  let _ = jd.to_string()
  let jd2 = @tyme.JulianDay::from_ymdhms(2023, 1, 1, 0, 0, 0)
  let _ = jd2.get_day()
  let jd3 = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap().get_julian_day()
  let _ = jd3.get_day()
  let jd4 = @tyme.SolarTime::from_ymdhms(2023, 1, 1, 12, 30, 0)
    .unwrap()
    .get_julian_day()
  let _ = jd4.get_day()
}
