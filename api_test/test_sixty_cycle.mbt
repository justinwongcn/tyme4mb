// 包外 API 测试：干支、八字、三柱
// 验证 api.md 中所有干支相关接口可从包外调用

///|
test "SixtyCycle" {
  let sc = @tyme.SixtyCycle::from_index(1)
  let _ = sc.get_heaven_stem()
  let _ = sc.get_earth_branch()
  let _ = sc.get_sound()
  let _ = sc.get_peng_zu()
  let sc2 = @tyme.SixtyCycle::from_name("乙卯").unwrap()
  let _ = sc2.get_ten()
  let sc3 = @tyme.SixtyCycle::from_name("甲子").unwrap()
  let _ = sc3.get_extra_earth_branches()
  let _ = sc.get_size()
  let _ = sc.get_index()
  let _ = sc.steps_to(0)
  let _ = sc.steps_back_to(0)
  let _ = sc.steps_close_to(0)
  let _ = sc.equals(sc.next(0))
  let _ = sc.get_name()
  let _ = sc.to_string()
}

///|
test "SixtyCycleYear" {
  let y = @tyme.SixtyCycleYear::from_year(2023).unwrap()
  let _ = y.get_year()
  let _ = y.get_sixty_cycle()
  let _ = y.get_twenty()
  let _ = y.get_nine_star()
  let _ = y.get_jupiter_direction()
  let _ = y.get_months()
  let _ = y.get_first_month()
  let _ = y.get_name()
  let _ = y.to_string()
}

///|
test "SixtyCycleMonth" {
  let m = @tyme.SixtyCycleMonth::from_index(2023, 0).unwrap()
  let _ = m.get_sixty_cycle_year()
  let _ = m.get_year()
  let _ = m.get_sixty_cycle()
  let _ = m.get_index_in_year()
  let _ = m.get_nine_star()
  let _ = m.get_jupiter_direction()
  let _ = m.get_first_day()
  let _ = m.get_days()
  let _ = m.get_name()
  let _ = m.to_string()
  let d = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap().get_sixty_cycle_day()
  let m2 = d.get_sixty_cycle_month()
  let _ = m2.get_name()
}

///|
test "SixtyCycleDay" {
  let d = @tyme.LunarDay::from_ymd(2023, 12, 30).unwrap().get_sixty_cycle_day()
  let _ = d.get_sixty_cycle_month()
  let _ = d.get_year()
  let _ = d.get_month()
  let _ = d.get_sixty_cycle()
  let _ = d.get_nine_star()
  let _ = d.get_jupiter_direction()
  let _ = d.get_duty()
  let _ = d.get_twelve_star()
  let _ = d.get_fetus_day()
  let _ = d.get_twenty_eight_star()
  let _ = d.get_hours()
  let _ = d.get_three_pillars()
  let _ = d.get_gods()
  let _ = d.get_recommends()
  let _ = d.get_avoids()
  let _ = d.get_solar_day()
  let _ = d.get_name()
  let _ = d.to_string()
  let d2 = @tyme.SolarDay::from_ymd(2024, 2, 9).unwrap().get_sixty_cycle_day()
  let _ = d2.get_name()
  let h = @tyme.LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
    .unwrap()
    .get_sixty_cycle_hour()
  let d3 = h.get_sixty_cycle_day()
  let _ = d3.get_name()
}

///|
test "SixtyCycleHour" {
  let st = @tyme.SolarTime::from_ymdhms(2024, 2, 9, 13, 0, 0).unwrap()
  let h = st.get_sixty_cycle_hour()
  let _ = h.get_sixty_cycle_day()
  let _ = h.get_index_in_day()
  let _ = h.get_year()
  let _ = h.get_month()
  let _ = h.get_day()
  let _ = h.get_sixty_cycle()
  let _ = h.get_nine_star()
  let _ = h.get_twelve_star()
  let _ = h.get_eight_char()
  let _ = h.get_recommends()
  let _ = h.get_avoids()
  let _ = h.get_solar_time()
  let _ = h.get_name()
  let _ = h.to_string()
  let h2 = @tyme.LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0)
    .unwrap()
    .get_sixty_cycle_hour()
  let _ = h2.get_name()
  let h3 = @tyme.LunarHour::from_ymd_hms(2023, 12, 30, 23, 0, 0)
    .unwrap()
    .get_sixty_cycle_hour()
  let _ = h3.get_index_in_day()
}

///|
test "ThreePillars" {
  let t = @tyme.ThreePillars::new("丁丑", "癸卯", "癸丑").unwrap()
  let _ = t.get_year()
  let _ = t.get_month()
  let _ = t.get_day()
  let _ = t.get_solar_days(1900, 2024)
  let _ = t.get_name()
  let _ = t.to_string()
  let t2 = @tyme.ThreePillars::from_sixty_cycle(
    @tyme.SixtyCycle::from_name("丁丑").unwrap(),
    @tyme.SixtyCycle::from_name("癸卯").unwrap(),
    @tyme.SixtyCycle::from_name("癸丑").unwrap(),
  )
  let _ = t2.get_year()
  let ld = @tyme.LunarDay::from_ymd(2025, 9, 11).unwrap()
  let t3 = ld.get_three_pillars()
  let _ = t3.get_year()
  let sd = @tyme.SolarDay::from_ymd(2025, 10, 31).unwrap().get_sixty_cycle_day()
  let t4 = sd.get_three_pillars()
  let _ = t4.get_year()
}

///|
test "EightChar" {
  let ec = @tyme.EightChar::new("丁丑", "癸卯", "癸丑", "辛酉").unwrap()
  let _ = ec.get_solar_times(1900, 2024)
  let _ = ec.get_year()
  let _ = ec.get_month()
  let _ = ec.get_day()
  let _ = ec.get_hour()
  let ec2 = @tyme.EightChar::new("癸卯", "辛酉", "己亥", "癸酉").unwrap()
  let _ = ec2.get_fetal_origin()
  let _ = ec2.get_fetal_breath()
  let _ = ec2.get_own_sign()
  let _ = ec2.get_body_sign()
  let _ = ec2.get_duty()
  let _ = ec.get_name()
  let _ = ec.to_string()
  let ec3 = @tyme.EightChar::from_sixty_cycle(
    @tyme.SixtyCycle::from_name("丁丑").unwrap(),
    @tyme.SixtyCycle::from_name("癸卯").unwrap(),
    @tyme.SixtyCycle::from_name("癸丑").unwrap(),
    @tyme.SixtyCycle::from_name("辛酉").unwrap(),
  )
  let _ = ec3.get_year()
  let lh = @tyme.LunarHour::from_ymd_hms(2023, 1, 1, 10, 0, 0).unwrap()
  let ec4 = lh.get_eight_char()
  let _ = ec4.get_year()
}
