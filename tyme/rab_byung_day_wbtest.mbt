// 测试套件：RabByungDay（对应 Go test/RabByungDay_test.go，一比一翻译）

///|
test "rab_byung_day_0" {
  let solar = SolarDay::from_ymd(1951, 1, 8).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十六饶迥铁虎年十二月初一", "SolarDay(1951,1,8).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("虎").unwrap()
  let y = RabByungYear::from_element_zodiac(15, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 12, 1).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "1951年1月8日", "RabByungDay(.,12,1).GetSolarDay()")
}

///|
test "rab_byung_day_1" {
  let solar = SolarDay::from_ymd(2051, 2, 11).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十八饶迥铁马年十二月三十", "SolarDay(2051,2,11).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("马").unwrap()
  let y = RabByungYear::from_element_zodiac(17, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 12, 30).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "2051年2月11日", "RabByungDay(.,12,30).GetSolarDay()")
}

///|
test "rab_byung_day_2" {
  let solar = SolarDay::from_ymd(2025, 4, 23).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十七饶迥木蛇年二月廿五", "SolarDay(2025,4,23).GetRabByungDay()")

  let e = RabByungElement::from_name("木").unwrap()
  let z = Zodiac::from_name("蛇").unwrap()
  let y = RabByungYear::from_element_zodiac(16, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 2, 25).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "2025年4月23日", "RabByungDay(.,2,25).GetSolarDay()")
}

///|
test "rab_byung_day_3" {
  let solar = SolarDay::from_ymd(1951, 2, 8).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十六饶迥铁兔年正月初二", "SolarDay(1951,2,8).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("兔").unwrap()
  let y = RabByungYear::from_element_zodiac(15, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 1, 2).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "1951年2月8日", "RabByungDay(.,1,2).GetSolarDay()")
}

///|
test "rab_byung_day_4" {
  let solar = SolarDay::from_ymd(1951, 1, 24).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十六饶迥铁虎年十二月闰十六", "SolarDay(1951,1,24).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("虎").unwrap()
  let y = RabByungYear::from_element_zodiac(15, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 12, -16).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "1951年1月24日", "RabByungDay(.,12,-16).GetSolarDay()")
}

///|
test "rab_byung_day_5" {
  let solar = SolarDay::from_ymd(1961, 6, 24).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十六饶迥铁牛年五月十一", "SolarDay(1961,6,24).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("牛").unwrap()
  let y = RabByungYear::from_element_zodiac(15, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 5, 11).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "1961年6月24日", "RabByungDay(.,5,11).GetSolarDay()")
}

///|
test "rab_byung_day_6" {
  let solar = SolarDay::from_ymd(1952, 2, 23).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十六饶迥铁兔年十二月廿八", "SolarDay(1952,2,23).GetRabByungDay()")

  let e = RabByungElement::from_name("铁").unwrap()
  let z = Zodiac::from_name("兔").unwrap()
  let y = RabByungYear::from_element_zodiac(15, e, z).unwrap()
  let d1 = RabByungDay::from_ymd(y.get_year(), 12, 28).unwrap()
  expect_eq(d1.get_solar_day().to_string(), "1952年2月23日", "RabByungDay(.,12,28).GetSolarDay()")
}

///|
test "rab_byung_day_7" {
  let solar = SolarDay::from_ymd(2025, 4, 26).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十七饶迥木蛇年二月廿九", "SolarDay(2025,4,26).GetRabByungDay()")
}

///|
test "rab_byung_day_8" {
  let solar = SolarDay::from_ymd(2025, 4, 25).unwrap()
  let d = solar.get_rab_byung_day().unwrap()
  expect_eq(d.to_string(), "第十七饶迥木蛇年二月廿七", "SolarDay(2025,4,25).GetRabByungDay()")
}
