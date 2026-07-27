// 测试套件：JulianDay（对应 Go test/JulianDay_test.go，一比一翻译）

///|
test "julian_day_0" {
  let d = SolarDay::from_ymd(2023, 1, 1).unwrap()
  expect_eq(
    d.get_julian_day().get_solar_day().to_string(),
    "2023年1月1日",
    "SolarDay(2023,1,1).GetJulianDay().GetSolarDay().String()",
  )
}
