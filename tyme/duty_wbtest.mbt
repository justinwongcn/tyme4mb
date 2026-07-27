// 测试套件：Duty（对应 Go test/Duty_test.go，一比一翻译）

///|
test "duty_0" {
  let d = SolarDay::from_ymd(2023, 10, 30).unwrap()
  expect_eq(
    d.get_lunar_day().get_duty().get_name(),
    "闭",
    "SolarDay(2023,10,30).GetLunarDay().GetDuty().GetName()",
  )
}

///|
test "duty_1" {
  let d = SolarDay::from_ymd(2023, 10, 19).unwrap()
  expect_eq(
    d.get_lunar_day().get_duty().get_name(),
    "建",
    "SolarDay(2023,10,19).GetLunarDay().GetDuty().GetName()",
  )
}

///|
test "duty_2" {
  let d = SolarDay::from_ymd(2023, 10, 7).unwrap()
  expect_eq(
    d.get_lunar_day().get_duty().get_name(),
    "除",
    "SolarDay(2023,10,7).GetLunarDay().GetDuty().GetName()",
  )
}

///|
test "duty_3" {
  let d = SolarDay::from_ymd(2023, 10, 8).unwrap()
  expect_eq(
    d.get_lunar_day().get_duty().get_name(),
    "除",
    "SolarDay(2023,10,8).GetLunarDay().GetDuty().GetName()",
  )
}
