// 测试套件：Direction（对应 Go test/Direction_test.go，一比一翻译）

///|
test "direction_0" {
  let d = SolarDay::from_ymd(2021, 11, 13).unwrap()
  expect_eq(
    d
    .get_lunar_day()
    .get_sixty_cycle()
    .get_heaven_stem()
    .get_mascot_direction()
    .get_name(),
    "东南",
    "SolarDay(2021,11,13).GetLunarDay().GetSixtyCycle().GetHeavenStem().GetMascotDirection().GetName()",
  )
}

///|
test "direction_1" {
  let d = SolarDay::from_ymd(2024, 1, 1).unwrap()
  expect_eq(
    d
    .get_lunar_day()
    .get_sixty_cycle()
    .get_heaven_stem()
    .get_mascot_direction()
    .get_name(),
    "东南",
    "SolarDay(2024,1,1).GetLunarDay().GetSixtyCycle().GetHeavenStem().GetMascotDirection().GetName()",
  )
}

///|
test "direction_2" {
  let d = SolarDay::from_ymd(2023, 11, 6).unwrap()
  expect_eq(
    d.get_lunar_day().get_jupiter_direction().get_name(),
    "东",
    "SolarDay(2023,11,6).GetLunarDay().GetJupiterDirection().GetName()",
  )
}
