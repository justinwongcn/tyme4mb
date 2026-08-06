// 测试套件：JulianDay（对应 Go test/JulianDay_test.go，一比一翻译）

///|
test "julian_day_0" {
  let d = SolarDay::from_ymd(2023, 1, 1).unwrap()
  expect_eq(
    d.get_julian_day().get_solar_day().unwrap().to_string(),
    "2023年1月1日",
    "SolarDay(2023,1,1).GetJulianDay().GetSolarDay().String()",
  )
}

///|
test "julian_day_get_solar_day_result_boundary" {
  let jd = JulianDay::from_julian_day(0.0)
  expect_eq(
    jd.get_solar_time().unwrap_err(),
    "illegal solar year: -4712",
    "JulianDay.GetSolarTime preserves the invalid year",
  )
  expect_eq(
    jd.get_solar_day().unwrap_err(),
    "illegal solar year: -4712",
    "JulianDay.GetSolarDay preserves the invalid year",
  )
}
