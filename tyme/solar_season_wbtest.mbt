// 测试套件：SolarSeason（对应 Go test/SolarSeason_test.go，一比一翻译）

///|
test "solar_season_0" {
  let d = SolarSeason::from_index(2023, 0).unwrap()
  expect_eq(
    d.to_string(),
    "2023年一季度",
    "SolarSeason.FromIndex(2023,0).String()",
  )
  expect_eq(
    d.next(-5).to_string(),
    "2021年四季度",
    "SolarSeason.FromIndex(2023,0).Next(-5).String()",
  )
}
