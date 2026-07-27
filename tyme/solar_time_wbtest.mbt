// 测试套件：SolarTime（对应 Go test/SolarTime_test.go，一比一翻译）

///|
test "solar_time_0" {
  let time = SolarTime::from_ymdhms(2023, 1, 1, 13, 5, 20).unwrap()
  expect_eq(
    time.get_name(),
    "13:05:20",
    "SolarTime(2023,1,1,13,5,20).GetName()",
  )
  expect_eq(
    time.next(-21).get_name(),
    "13:04:59",
    "SolarTime(2023,1,1,13,5,20).Next(-21).GetName()",
  )
  expect_eq(
    time.next(-81).get_name(),
    "13:03:59",
    "SolarTime(2023,1,1,13,5,20).Next(-81).GetName()",
  )
}
