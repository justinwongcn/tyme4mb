// 测试套件：SixStar（对应 Go test/SixStar_test.go，一比一翻译）

///|
// six_star_0 六曜测试
test "six_star_0" {
  let solar_day = SolarDay::from_ymd(2020, 4, 23).unwrap()
  let d = solar_day.get_lunar_day().get_six_star()
  expect_eq(
    d.get_name(),
    "佛灭",
    "SolarDay(2020,4,23).GetLunarDay().GetSixStar().GetName()",
  )
}
