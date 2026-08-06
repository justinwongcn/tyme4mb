// 测试套件：HijriDay（对应 Go test/HijriDay_test.go，一比一翻译）

///|
test "hijri_day_0" {
  let d = SolarDay::from_ymd(622, 7, 16).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "1年穆哈兰姆月1日",
    "SolarDay(622,7,16).GetHijriDay().String()",
  )
}

///|
test "hijri_day_1" {
  let d = SolarDay::from_ymd(2026, 5, 13).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "1447年都尔喀尔德月26日",
    "SolarDay(2026,5,13).GetHijriDay().String()",
  )

  let h1 = HijriDay::from_ymd(1447, 11, 26).unwrap()
  let d1 = h1.get_solar_day()
  expect_eq(
    d1.to_string(),
    "2026年5月13日",
    "HijriDay(1447,11,26).GetSolarDay().String()",
  )
}

///|
test "hijri_day_2" {
  let d = SolarDay::from_ymd(100, 7, 8).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "-538年都尔黑哲月12日",
    "SolarDay(100,7,8).GetHijriDay().String()",
  )

  let h1 = HijriDay::from_ymd(-538, 12, 12).unwrap()
  let d1 = h1.get_solar_day()
  expect_eq(
    d1.to_string(),
    "100年7月8日",
    "HijriDay(-538,12,12).GetSolarDay().String()",
  )
}

///|
test "hijri_day_3" {
  let d = SolarDay::from_ymd(622, 7, 15).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "0年都尔黑哲月29日",
    "SolarDay(622,7,15).GetHijriDay().String()",
  )

  let h1 = HijriDay::from_ymd(0, 12, 29).unwrap()
  let d1 = h1.get_solar_day()
  expect_eq(
    d1.to_string(),
    "622年7月15日",
    "HijriDay(0,12,29).GetSolarDay().String()",
  )
}

///|
test "hijri_day_4" {
  let d = SolarDay::from_ymd(1, 1, 1).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "-640年主马达·敖外鲁月16日",
    "SolarDay(1,1,1).GetHijriDay().String()",
  )

  let h1 = HijriDay::from_ymd(-640, 5, 16).unwrap()
  let d1 = h1.get_solar_day()
  expect_eq(
    d1.to_string(),
    "1年1月1日",
    "HijriDay(-640,5,16).GetSolarDay().String()",
  )
}

///|
test "hijri_day_5" {
  let d = SolarDay::from_ymd(9999, 12, 31).unwrap()
  let h = d.get_hijri_day()
  expect_eq(
    h.to_string(),
    "9666年赖比尔·阿色尼月2日",
    "SolarDay(9999,12,31).GetHijriDay().String()",
  )

  let h1 = HijriDay::from_ymd(9666, 4, 2).unwrap()
  let d1 = h1.get_solar_day()
  expect_eq(
    d1.to_string(),
    "9999年12月31日",
    "HijriDay(9666,4,2).GetSolarDay().String()",
  )
}
