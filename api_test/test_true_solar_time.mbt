// 黑盒 API 测试：真太阳时

///|
fn assert_true(cond : Bool, msg : String) -> Unit {
  if !cond {
    abort("ASSERT TRUE FAIL: \{msg}")
  }
}

///|
test "api_true_solar_time_beijing" {
  // 北京 116.39°E，2025-06-21 12:00 CST
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(116.39)
  // 经度修正约 -14.4 分钟，均时差约 -1.8 分钟，真太阳时应约 11:43
  assert_true(tst.get_hour() == 11, "Beijing TST hour = 11")
}

///|
test "api_true_solar_time_shanghai" {
  // 上海 121.47°E，2025-06-21 12:00 CST
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(121.47)
  // 经度修正约 +5.9 分钟，均时差约 -1.8 分钟，真太阳时应约 12:04
  assert_true(tst.get_hour() == 12, "Shanghai TST hour = 12")
}

///|
test "api_true_solar_time_urumqi" {
  // 乌鲁木齐 87.62°E，2025-06-21 12:00 CST
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(87.62)
  // 经度修正约 -129.6 分钟，均时差约 -1.8 分钟，真太阳时应约 09:48
  assert_true(tst.get_hour() == 9, "Urumqi TST hour = 9")
}

///|
test "api_true_solar_time_120deg" {
  // 经度 120°E（标准经度），经度修正为 0，只有均时差修正
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  // 均时差约 -1.8 分钟，真太阳时应约 11:58
  assert_true(tst.get_hour() == 11, "120°E TST hour = 11")
}

///|
test "api_true_solar_time_february" {
  // 2025-02-10 均时差约 -14.2 分钟（一年中负值最大的时期）
  let st = @tyme.SolarTime::from_ymdhms(2025, 2, 10, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  // 真太阳时应约 11:46
  assert_true(tst.get_hour() == 11, "February TST hour = 11")
  assert_true(tst.get_minute() >= 40 && tst.get_minute() <= 52,
    "February TST minute in 40-52")
}

///|
test "api_true_solar_time_november" {
  // 2025-11-03 均时差约 +16.4 分钟（一年中正值最大的时期）
  let st = @tyme.SolarTime::from_ymdhms(2025, 11, 3, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  // 真太阳时应约 12:16
  assert_true(tst.get_hour() == 12, "November TST hour = 12")
  assert_true(tst.get_minute() >= 10 && tst.get_minute() <= 22,
    "November TST minute in 10-22")
}

///|
test "api_true_solar_time_west_longitude" {
  // 西经测试：纽约约 -74.0°W（西经为负）
  // 但钟表时间仍为北京时间 UTC+8
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(-74.0)
  // 经度修正约 (-74-120)*4 = -776 分钟，真太阳时应约 11:04 左右前一天
  // 主要验证不崩溃且返回有效结果
  let _ = tst.get_name()
}

///|
test "api_true_solar_time_preserves_date" {
  // 验证真太阳时的日期与原时刻在同一天或相邻天
  let st = @tyme.SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  let sd1 = st.get_solar_day()
  let sd2 = tst.get_solar_day()
  let diff = sd2.subtract(sd1)
  assert_true(diff >= -1 && diff <= 1, "TST date within ±1 day")
}

///|
test "api_equation_of_time_accessible" {
  // 验证均时差函数可通过 facade 层访问
  let eot = @tyme.equation_of_time(0.25)
  assert_true(eot >= -0.3 && eot <= 0.3, "EoT within ±0.3 hours")
}

///|
test "api_equation_of_time_seasonal_variation" {
  // 验证均时差随季节变化（1月 vs 6月）
  let eot_jan = @tyme.equation_of_time(0.25)
  let eot_jun = @tyme.equation_of_time(0.254666)
  // 1月均时差约 -0.055h，6月约 -0.026h，差异应 > 0.01h
  assert_true((eot_jan - eot_jun).abs() > 0.01,
    "EoT seasonal variation > 0.01h")
}
