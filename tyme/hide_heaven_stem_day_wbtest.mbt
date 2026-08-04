// 测试套件：HideHeavenStemDay（对应 Go test/HideHeavenStemDay_test.go，一比一翻译）

///|
test "hide_heaven_stem_day_0" {
  let solar = SolarDay::from_ymd(2024, 12, 4).unwrap()
  let d = solar.get_hide_heaven_stem_day()

  expect_eq(
    d.get_hide_heaven_stem().get_type().get_name(),
    "本气",
    "HideHeavenStemDay.GetHideHeavenStem().GetType().GetName()",
  )
  expect_eq(
    d.get_hide_heaven_stem().get_name(),
    "壬",
    "HideHeavenStemDay.GetHideHeavenStem().GetName()",
  )
  expect_eq(
    d.get_hide_heaven_stem().to_string(),
    "壬",
    "HideHeavenStemDay.GetHideHeavenStem().String()",
  )
  expect_eq(d.get_name(), "壬水", "HideHeavenStemDay.GetName()")
  expect_eq(d.to_string(), "壬水第16天", "HideHeavenStemDay.String()")
}
