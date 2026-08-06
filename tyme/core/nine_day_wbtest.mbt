// 测试套件：NineDay（对应 Go test/NineDay_test.go，一比一翻译）

///|
test "nine_day_0" {
  let m = SolarDay::from_ymd(2020, 12, 21).unwrap()
  let nine_day = m.get_nine_day().unwrap()
  expect_eq(nine_day.get_name(), "一九", "NineDay.GetName()")
  expect_eq(
    nine_day.get_nine().to_string(),
    "一九",
    "NineDay.GetNine().String()",
  )
  expect_eq(nine_day.to_string(), "一九第1天", "NineDay.String()")
}

///|
test "nine_day_1" {
  let m = SolarDay::from_ymd(2020, 1, 7).unwrap()
  let nine_day = m.get_nine_day().unwrap()
  expect_eq(nine_day.get_name(), "二九", "NineDay.GetName()")
  expect_eq(
    nine_day.get_nine().to_string(),
    "二九",
    "NineDay.GetNine().String()",
  )
  expect_eq(nine_day.to_string(), "二九第8天", "NineDay.String()")
}
