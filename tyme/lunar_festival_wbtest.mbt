// 测试套件：LunarFestival（对应 Go test/LunarFestival_test.go，一比一翻译）

///|
test "lunar_festival_0" {
  let d = LunarFestival::from_index(2023, 0).unwrap()
  expect_eq(
    d.next(13).unwrap().to_string(),
    "农历甲辰年正月初一 春节",
    "LunarFestival.FromIndex(2023,0).Next(13).String()",
  )
  expect_eq(
    d.next(-3).unwrap().to_string(),
    "农历壬寅年十一月廿九 冬至节",
    "LunarFestival.FromIndex(2023,0).Next(-3).String()",
  )
}

///|
test "lunar_festival_1" {
  let d = LunarDay::from_ymd(2025, 5, 5).unwrap()
  expect_eq(
    d.get_festival().unwrap().to_string(),
    "农历乙巳年五月初五 端午节",
    "LunarDay(2025,5,5).GetFestival().String()",
  )
}
