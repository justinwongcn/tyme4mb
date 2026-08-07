// 测试套件：SolarTime（对应 Go test/SolarTime_test.go，一比一翻译）

///|
test "solar_time_0" {
  let time = SolarTime::from_ymdhms(2023, 1, 1, 13, 5, 20).unwrap()
  expect_eq(
    time.get_name(),
    "13:05:20",
    "SolarTime(2023,1,1,13,5,20).GetName()",
  )
  expect_eq(
    time.next(-21).get_name(),
    "13:04:59",
    "SolarTime(2023,1,1,13,5,20).Next(-21).GetName()",
  )
  expect_eq(
    time.next(-81).get_name(),
    "13:03:59",
    "SolarTime(2023,1,1,13,5,20).Next(-81).GetName()",
  )
}

///|
test "solar_time_to_true_solar_time_120deg" {
  // 经度 120°E（标准经度），经度修正为 0，只有均时差修正
  // 2025-06-21 均时差接近 0，真太阳时应接近 12:00
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  expect_true(
    tst.get_hour() == 11 || tst.get_hour() == 12,
    "120°E TST hour should be 11 or 12",
  )
  // 均时差在 ±2 分钟内
  expect_true(
    tst.get_minute() >= 58 || tst.get_minute() <= 2,
    "120°E TST minute should be near 00",
  )
}

///|
test "solar_time_to_true_solar_time_beijing" {
  // 北京时间 2025-06-21 12:00:00，经度 116.39°E（北京）
  // 经度修正约 -14.4 分钟，均时差约 0，真太阳时应约 11:46
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(116.39)
  expect_true(tst.get_hour() == 11, "Beijing TST hour should be 11")
  expect_true(
    tst.get_minute() >= 40 && tst.get_minute() <= 50,
    "Beijing TST minute should be 40-50",
  )
}

///|
test "solar_time_to_true_solar_time_urumqi" {
  // 乌鲁木齐 87.62°E，与 120°E 差约 -32.4°，经度修正约 -129 分钟
  // 真太阳时应约 09:50
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(87.62)
  expect_true(tst.get_hour() == 9, "Urumqi TST hour should be 9")
  expect_true(
    tst.get_minute() >= 45 && tst.get_minute() <= 55,
    "Urumqi TST minute should be 45-55",
  )
}

///|
test "solar_time_to_true_solar_time_shanghai" {
  // 上海 121.47°E，经度修正约 +5.9 分钟，真太阳时应约 12:06
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(121.47)
  expect_true(tst.get_hour() == 12, "Shanghai TST hour should be 12")
  expect_true(
    tst.get_minute() >= 3 && tst.get_minute() <= 10,
    "Shanghai TST minute should be 3-10",
  )
}
