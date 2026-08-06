// 测试套件：LunarYear（对应 Go test/LunarYear_test.go，一比一翻译）

///|
test "lunar_year_0" {
  let m = LunarYear::from_year(2023).unwrap()
  expect_eq(m.to_string(), "农历癸卯年", "LunarYear(2023).String()")
}

///|
test "lunar_year_1" {
  let m = LunarYear::from_year(2020).unwrap()
  expect_eq(
    m.get_sixty_cycle().get_name(),
    "庚子",
    "LunarYear(2020).GetSixtyCycle().GetName()",
  )
}

///|
test "lunar_year_2" {
  let m = LunarYear::from_year(1864).unwrap()
  expect_eq(
    m.get_twenty().get_sixty().get_name(),
    "上元",
    "LunarYear(1864).GetTwenty().GetSixty().GetName()",
  )
}

///|
test "lunar_year_3" {
  let m = LunarYear::from_year(1884).unwrap()
  expect_eq(
    m.get_twenty().get_name(),
    "二运",
    "LunarYear(1884).GetTwenty().GetName()",
  )
}
