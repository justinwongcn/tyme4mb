// 测试套件：SolarMonth（对应 Go test/SolarMonth_test.go，一比一翻译）

///|
test "solar_month_0" {
  let d = SolarMonth::from_ym(2019, 5).unwrap()
  expect_eq(d.get_name(), "5月", "SolarMonth(2019,5).GetName()")
  expect_eq(d.to_string(), "2019年5月", "SolarMonth(2019,5).String()")
}
