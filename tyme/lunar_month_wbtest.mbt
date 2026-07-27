// 测试套件：LunarMonth（对应 Go test/LunarMonth_test.go，一比一翻译）

///|
test "lunar_month_0" {
  let m = LunarMonth::from_ym(2023, 3).unwrap()
  expect_eq(m.to_string(), "农历癸卯年三月", "LunarMonth(2023,3).String()")
  expect_eq(m.next(-1).to_string(), "农历癸卯年闰二月", "LunarMonth(2023,3).Next(-1).String()")
}
