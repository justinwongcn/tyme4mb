// 测试套件：Ecliptic / TwelveStar（对应 Go test/Ecliptic_test.go，一比一翻译）

///|
// ecliptic_0 黄道黑道十二神测试
test "ecliptic_0" {
  let d = SolarDay::from_ymd(2023, 10, 30).unwrap()
  let star = d.get_lunar_day().get_twelve_star()
  expect_eq(
    star.get_name(),
    "天德",
    "SolarDay(2023,10,30).GetLunarDay().GetTwelveStar().GetName()",
  )
  expect_eq(
    star.get_ecliptic().get_name(),
    "黄道",
    "TwelveStar.GetEcliptic().GetName()",
  )
  expect_eq(
    star.get_ecliptic().get_luck().get_name(),
    "吉",
    "Ecliptic.GetLuck().GetName()",
  )
}
