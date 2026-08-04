// 测试套件：Week / SolarWeek（对应 Go test/Week_test.go，一比一翻译）

///|
test "week_0" {
  let w = SolarDay::from_ymd(1582, 10, 1).unwrap()
  expect_eq(
    w.get_week().get_name(),
    "一",
    "SolarDay(1582,10,1).GetWeek().GetName()",
  )
}

///|
test "week_1" {
  let w = SolarWeek::from_ym(2023, 10, 0, 0).unwrap()
  expect_eq(
    w.get_name(),
    "第一周",
    "SolarWeek.FromYm(2023,10,0,0).GetName()",
  )
  expect_eq(
    w.to_string(),
    "2023年10月第一周",
    "SolarWeek.FromYm(2023,10,0,0).String()",
  )
}

///|
test "week_2" {
  let solar_day = SolarDay::from_ymd(2025, 3, 6).unwrap()
  let solar_week = solar_day.get_solar_week(0)
  expect_eq(
    solar_week.to_string(),
    "2025年3月第二周",
    "SolarDay(2025,3,6).GetSolarWeek(0).String()",
  )
  expect_eq(
    solar_week.get_first_day().to_string(),
    "2025年3月2日",
    "SolarWeek.GetFirstDay().String()",
  )
}
