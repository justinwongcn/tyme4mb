// 测试套件：PlumRainDay（对应 Go test/PlumRainDay_test.go，一比一翻译）

///|
test "plum_rain_day_0" {
  let solar_day = SolarDay::from_ymd(2024, 6, 11).unwrap()
  let d = solar_day.get_plum_rain_day().unwrap()

  expect_eq(
    d.get_name(),
    "入梅",
    "SolarDay(2024,6,11).GetPlumRainDay().GetName()",
  )
  expect_eq(
    d.get_plum_rain().get_name(),
    "入梅",
    "PlumRainDay.GetPlumRain().GetName()",
  )
  expect_eq(
    d.to_string(),
    "入梅第1天",
    "PlumRainDay.String()",
  )
}
