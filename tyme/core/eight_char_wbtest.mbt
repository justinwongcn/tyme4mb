// 测试套件：EightChar（对应 Go test/EightChar_test.go，一比一翻译）
// 说明：eight_char_4 通过 ChildLimit::set_provider 切换全局童限实现为 LunarSect1ChildLimitProvider，
// 测试结束后恢复默认实现。

///|
test "eight_char_0" {
  let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉").unwrap()
  let tai_yuan = eight_char.get_fetal_origin()
  expect_eq(
    tai_yuan.get_name(),
    "壬子",
    "EightChar.GetFetalOrigin().GetName()",
  )
  expect_eq(
    tai_yuan.get_sound().get_name(),
    "桑柘木",
    "EightChar.GetFetalOrigin().GetSound().GetName()",
  )
}

///|
test "eight_char_1" {
  let time = SolarTime::from_ymdhms(2005, 12, 23, 8, 37, 0).unwrap()
  let eight_char = time.get_lunar_hour().get_eight_char()
  expect_eq(
    eight_char.get_year().get_name(),
    "乙酉",
    "EightChar.GetYear().GetName()",
  )
  expect_eq(
    eight_char.get_month().get_name(),
    "戊子",
    "EightChar.GetMonth().GetName()",
  )
  expect_eq(
    eight_char.get_day().get_name(),
    "辛巳",
    "EightChar.GetDay().GetName()",
  )
  expect_eq(
    eight_char.get_hour().get_name(),
    "壬辰",
    "EightChar.GetHour().GetName()",
  )
}

///|
test "eight_char_3" {
  let time = SolarTime::from_ymdhms(2022, 3, 9, 20, 51, 0).unwrap()
  let child_limit = ChildLimit::from_solar_time(time, Man)
  expect_eq(child_limit.get_year_count(), 8, "ChildLimit.GetYearCount()")
  expect_eq(child_limit.get_month_count(), 9, "ChildLimit.GetMonthCount()")
  expect_eq(child_limit.get_day_count(), 2, "ChildLimit.GetDayCount()")
  expect_eq(child_limit.get_hour_count(), 10, "ChildLimit.GetHourCount()")
  expect_eq(child_limit.get_minute_count(), 28, "ChildLimit.GetMinuteCount()")
  expect_eq(
    child_limit.get_end_time().to_string(),
    "2030年12月12日 07:19:00",
    "ChildLimit.GetEndTime().String()",
  )
}

///|
test "eight_char_4" {
  // 通过 ChildLimit::set_provider 切换全局童限实现为 LunarSect1ChildLimitProvider
  ChildLimit::set_provider(LunarSect1ChildLimitProvider::{  })
  let birth_time = SolarTime::from_ymdhms(1994, 10, 17, 1, 0, 0).unwrap()
  let child_limit = ChildLimit::from_solar_time(birth_time, Man)
  expect_eq(
    child_limit.get_end_time().to_string(),
    "2002年1月27日 01:00:00",
    "ChildLimit.GetEndTime().String() (LunarSect1)",
  )
  expect_eq(
    child_limit
    .get_start_decade_fortune()
    .get_start_sixty_cycle_year()
    .get_sixty_cycle()
    .get_name(),
    "壬午",
    "ChildLimit.GetStartDecadeFortune()...GetName() (LunarSect1)",
  )
  // 恢复默认实现
  ChildLimit::set_provider(DefaultChildLimitProvider::{  })
}

///|
test "eight_char_5" {
  let me = HeavenStem::from_name("丙").unwrap()
  let earth_branch = EarthBranch::from_name("寅").unwrap()
  expect_eq(
    me.get_terrain(earth_branch).get_name(),
    "长生",
    "HeavenStem.GetTerrain(寅).GetName()",
  )
}

///|
test "eight_char_51" {
  let st = SolarTime::from_ymdhms(1034, 10, 2, 20, 0, 0).unwrap()
  expect_eq(
    st.get_lunar_hour().get_eight_char().to_string(),
    "甲戌 癸酉 甲戌 甲戌",
    "SolarTime.GetLunarHour().GetEightChar().String()",
  )
}
