// 测试套件：SolarHalfYear（对应 Go test/SolarHalfYear_test.go，一比一翻译）

///|
test "solar_half_year_0" {
  let d = SolarHalfYear::from_index(2023, 0).unwrap()
  expect_eq(d.get_name(), "上半年", "SolarHalfYear.FromIndex(2023,0).GetName()")
  expect_eq(d.to_string(), "2023年上半年", "SolarHalfYear.FromIndex(2023,0).String()")
}
