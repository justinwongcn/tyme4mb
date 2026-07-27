// 测试套件：ThreePillars（对应 Go test/ThreePillars_test.go，一比一翻译）

///|
test "three_pillars_1" {
  let d = SolarDay::from_ymd(1034, 10, 2).unwrap()
  expect_eq(
    d.get_sixty_cycle_day().get_three_pillars().get_name(),
    "甲戌 甲戌 甲戌",
    "SolarDay(1034,10,2).GetSixtyCycleDay().GetThreePillars().GetName()",
  )
}
