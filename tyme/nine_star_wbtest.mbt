// 测试套件：NineStar（对应 Go test/NineStar_test.go，一比一翻译）

///|
test "nine_star_0" {
  let m = LunarYear::from_year(1985).unwrap()
  expect_eq(
    m.get_nine_star().get_name(),
    "六",
    "LunarYear(1985).GetNineStar().GetName()",
  )
  expect_eq(
    m.get_nine_star().to_string(),
    "六白金",
    "LunarYear(1985).GetNineStar().String()",
  )
}

///|
test "nine_star_1" {
  let m = SolarDay::from_ymd(1985, 2, 19).unwrap()
  expect_eq(
    m.get_lunar_day().get_nine_star().to_string(),
    "五黄土",
    "SolarDay(1985,2,19).GetLunarDay().GetNineStar().String()",
  )
  expect_eq(
    m.get_lunar_day().get_nine_star().get_dipper().to_string(),
    "玉衡",
    "NineStar.GetDipper().String()",
  )
}
