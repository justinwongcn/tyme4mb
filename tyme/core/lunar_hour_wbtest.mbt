// 测试套件：LunarHour（对应 Go test/LunarHour_test.go，一比一翻译）

///|
test "lunar_hour_0" {
  let h = LunarHour::from_ymd_hms(2020, -4, 5, 23, 0, 0).unwrap()
  expect_eq(h.get_name(), "子时", "LunarHour(2020,-4,5,23,0,0).GetName()")
  expect_eq(
    h.to_string(),
    "农历庚子年闰四月初五戊子时",
    "LunarHour(2020,-4,5,23,0,0).String()",
  )
}
