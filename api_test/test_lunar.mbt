// 包外 API 测试：农历相关类型
// 验证 api.md 中所有农历相关接口可从包外调用

///|
test "LunarYear" {
  let ly = @tyme.LunarYear::from_year(2023).unwrap()
  let _ = ly.get_name()
  let _ = ly.get_year()
  let _ = ly.get_day_count()
  let _ = ly.get_leap_month()
  let _ = ly.get_sixty_cycle()
  let _ = ly.get_twenty()
  let _ = ly.get_nine_star()
  let _ = ly.get_jupiter_direction()
  let _ = ly.get_months()
  let _ = ly.get_kitchen_god_steed()
  let _ = ly.get_first_month()
  let _ = ly.get_month_count()
}

///|
test "LunarSeason" {
  let lm = @tyme.LunarMonth::from_ym(2023, 1).unwrap()
  let _ = lm.get_season()
  let ls = @tyme.LunarSeason::from_index(0)
  let _ = ls.get_name()
  let _ = @tyme.LunarSeason::from_name("孟春").unwrap()
}

///|
test "LunarMonth" {
  let lm = @tyme.LunarMonth::from_ym(2023, 1).unwrap()
  let _ = lm.get_lunar_year()
  let _ = lm.get_month()
  let _ = lm.get_month_with_leap()
  let _ = lm.is_leap()
  let _ = lm.get_index_in_year()
  let _ = lm.get_day_count()
  let _ = lm.get_season()
  let _ = lm.get_first_julian_day()
  let _ = lm.get_week_count(1)
  let _ = lm.get_weeks(1)
  let _ = lm.get_sixty_cycle()
  let _ = lm.get_nine_star()
  let _ = lm.get_jupiter_direction()
  let _ = lm.get_days()
  let _ = lm.get_first_day()
  let _ = lm.get_fetus()
  let _ = lm.get_minor_ren()
  let _ = lm.get_name()
  let _ = lm.to_string()
  let lm2 = lm.next(5)
  let _ = lm2.get_name()
}

///|
test "LunarWeek" {
  let lw = @tyme.LunarWeek::from_ym(2023, 1, 0, 2).unwrap()
  let _ = lw.get_first_day()
  let _ = lw.get_days()
  let _ = lw.get_index()
  let _ = lw.get_lunar_month()
  let _ = lw.get_start()
  let _ = lw.get_name()
  let _ = lw.to_string()
  let lw2 = lw.next(1)
  let _ = lw2.get_name()
}

///|
test "LunarDay" {
  let ld = @tyme.LunarDay::from_ymd(2023, 1, 1).unwrap()
  let _ = ld.get_lunar_month()
  let _ = ld.get_day()
  let _ = ld.get_week()
  let _ = ld.get_year_sixty_cycle()
  let _ = ld.get_month_sixty_cycle()
  let _ = ld.get_sixty_cycle()
  let _ = ld.get_nine_star()
  let _ = ld.get_jupiter_direction()
  let _ = ld.get_duty()
  let _ = ld.get_twelve_star()
  let _ = ld.get_fetus_day()
  let _ = ld.get_phase()
  let _ = ld.get_twenty_eight_star()
  let _ = ld.get_festival()
  let _ = ld.get_solar_day()
  let _ = ld.is_before(@tyme.LunarDay::from_ymd(2023, 1, 2).unwrap())
  let _ = ld.is_after(@tyme.LunarDay::from_ymd(2023, 1, 2).unwrap())
  let _ = ld.get_hours()
  let _ = ld.get_three_pillars()
  let _ = ld.get_six_star()
  let _ = ld.get_minor_ren()
  let _ = ld.get_gods()
  let _ = ld.get_recommends()
  let _ = ld.get_avoids()
  let _ = ld.get_name()
  let _ = ld.to_string()
}

///|
test "LunarHour" {
  let lh = @tyme.LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0).unwrap()
  let _ = lh.get_lunar_day()
  let _ = lh.get_hour()
  let _ = lh.get_minute()
  let _ = lh.get_second()
  let _ = lh.get_index_in_day()
  let _ = lh.get_year_sixty_cycle()
  let _ = lh.get_month_sixty_cycle()
  let _ = lh.get_day_sixty_cycle()
  let _ = lh.get_sixty_cycle()
  let _ = lh.get_nine_star()
  let _ = lh.get_twelve_star()
  let _ = lh.get_solar_time()
  let _ = lh.get_eight_char()
  let _ = lh.get_sixty_cycle_hour()
  let _ = lh.get_minor_ren()
  let _ = lh.get_recommends()
  let _ = lh.get_avoids()
  let _ = lh.get_name()
  let _ = lh.to_string()
  let lh2 = @tyme.LunarHour::from_ymd_hms(2023, 1, 2, 9, 0, 0).unwrap()
  let _ = lh.is_before(lh2)
  let _ = lh.is_after(lh2)
}
