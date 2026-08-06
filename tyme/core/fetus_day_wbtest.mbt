// 测试套件：FetusDay（对应 Go test/Fetus_test.go，一比一翻译）

///|
test "fetus_0" {
  let d = SolarDay::from_ymd(2021, 11, 13).unwrap()
  expect_eq(
    d.get_lunar_day().get_fetus_day().get_name(),
    "碓磨厕 外东南",
    "SolarDay(2021,11,13).GetLunarDay().GetFetusDay().GetName()",
  )
}
