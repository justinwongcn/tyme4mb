// 测试套件：SolarYear（对应 Go test/SolarYear_test.go，一比一翻译）

///|
test "solar_year_0" {
  let y = SolarYear::from_year(2023).unwrap()
  expect_eq(y.get_name(), "2023年", "SolarYear(2023).GetName()")
}

///|
test "solar_year_1" {
  let y = SolarYear::from_year(1500).unwrap()
  expect_true(y.is_leap(), "SolarYear(1500).IsLeap()")
}

///|
test "solar_year_2" {
  let y = SolarYear::from_year(1500).unwrap()
  expect_eq(y.get_year(), 1500, "SolarYear(1500).GetYear()")
}
