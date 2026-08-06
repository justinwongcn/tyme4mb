// 测试套件：SolarDay（对应 Go test/SolarDay_test.go，一比一翻译）

///|
test "solar_day_0" {
  let d = SolarDay::from_ymd(2023, 1, 1).unwrap()
  expect_eq(d.to_string(), "2023年1月1日", "SolarDay(2023,1,1).String()")
  expect_eq(d.get_name(), "1日", "SolarDay(2023,1,1).GetName()")
}

///|
test "solar_day_1" {
  let d = SolarDay::from_ymd(2020, 5, 24).unwrap()
  expect_eq(
    d.get_lunar_day().to_string(),
    "农历庚子年闰四月初二",
    "SolarDay(2020,5,24).GetLunarDay().String()",
  )
}

///|
test "solar_day_get_solar_week_result_boundary" {
  let d = SolarDay::from_ymd(2023, 1, 1).unwrap()
  expect_eq(
    d.get_solar_week(0).unwrap().to_string(),
    "2023年1月第一周",
    "SolarDay.GetSolarWeek valid start",
  )
  expect_true(
    d.get_solar_week(6) is Ok(_),
    "SolarDay.GetSolarWeek accepts start 6",
  )
  expect_true(
    d.get_solar_week(-1) is Err(_),
    "SolarDay.GetSolarWeek rejects start -1",
  )
  expect_true(
    d.get_solar_week(7) is Err(_),
    "SolarDay.GetSolarWeek rejects start 7",
  )
}
