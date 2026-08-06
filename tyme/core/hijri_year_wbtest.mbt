// 测试套件：HijriYear（对应 Go test/HijriYear_test.go，一比一翻译）

///|
test "hijri_year_0" {
  let y = HijriYear::from_year(1).unwrap()
  expect_false(y.is_leap(), "HijriYear(1).IsLeap() == false")
}

///|
test "hijri_year_1" {
  let y = HijriYear::from_year(2).unwrap()
  expect_true(y.is_leap(), "HijriYear(2).IsLeap() == true")
}

///|
test "hijri_year_2" {
  let y = HijriYear::from_year(0).unwrap()
  expect_false(y.is_leap(), "HijriYear(0).IsLeap() == false")
}

///|
test "hijri_year_3" {
  let y = HijriYear::from_year(-1).unwrap()
  expect_true(y.is_leap(), "HijriYear(-1).IsLeap() == true")
}
