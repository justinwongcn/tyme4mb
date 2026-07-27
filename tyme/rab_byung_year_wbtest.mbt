// 测试套件：RabByungYear（对应 Go test/RabByungYear_test.go，一比一翻译）

///|
test "rab_byung_year_0" {
  let e = RabByungElement::from_name("火").unwrap()
  let z = Zodiac::from_name("兔").unwrap()
  let y = RabByungYear::from_element_zodiac(0, e, z).unwrap()
  expect_eq(y.get_name(), "第一饶迥火兔年", "RabByungYear.FromElementZodiac(0,火,兔).GetName()")
  expect_eq(y.get_solar_year().get_name(), "1027年", "RabByungYear.GetSolarYear().GetName()")
  expect_eq(y.get_sixty_cycle().get_name(), "丁卯", "RabByungYear.GetSixtyCycle().GetName()")
  expect_eq(y.get_leap_month(), 10, "RabByungYear.GetLeapMonth()")
}

///|
test "rab_byung_year_1" {
  let y = RabByungYear::from_year(1027).unwrap()
  expect_eq(y.get_name(), "第一饶迥火兔年", "RabByungYear.FromYear(1027).GetName()")
}

///|
test "rab_byung_year_2" {
  let y = RabByungYear::from_year(2010).unwrap()
  expect_eq(y.get_name(), "第十七饶迥铁虎年", "RabByungYear.FromYear(2010).GetName()")
}

///|
test "rab_byung_year_3" {
  let y = RabByungYear::from_year(2043).unwrap()
  expect_eq(y.get_leap_month(), 5, "RabByungYear.FromYear(2043).GetLeapMonth()")
  let y2 = RabByungYear::from_year(2044).unwrap()
  expect_eq(y2.get_leap_month(), 0, "RabByungYear.FromYear(2044).GetLeapMonth()")
}

///|
test "rab_byung_year_4" {
  let y = RabByungYear::from_year(1961).unwrap()
  expect_eq(y.get_name(), "第十六饶迥铁牛年", "RabByungYear.FromYear(1961).GetName()")
}
