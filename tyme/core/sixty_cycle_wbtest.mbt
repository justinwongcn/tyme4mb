// 测试套件：SixtyCycle（对应 Go test/SixtyCycle_test.go，一比一翻译）

///|
test "sixty_cycle_0" {
  let got = SixtyCycle::from_index(13).get_name()
  expect_eq(got, "丁丑", "SixtyCycle.FromIndex(13).GetName()")
}

///|
test "sixty_cycle_1" {
  let o = SixtyCycle::from_name("辛酉").unwrap()
  expect_eq(
    o.get_sound().get_name(),
    "石榴木",
    "SixtyCycle.FromName(辛酉).GetSound().GetName()",
  )
}

///|
test "loop_wrapper_public_capabilities" {
  let animal = Animal::from_index(27)
  expect_eq(animal.get_size(), 28, "Animal.GetSize")
  expect_eq(animal.steps_to(0), 1, "Animal.StepsTo")
  expect_eq(animal.steps_back_to(0), -27, "Animal.StepsBackTo")
  expect_eq(animal.steps_close_to(0), 1, "Animal.StepsCloseTo")
  expect_true(animal.next(1).equals(Animal::from_index(0)), "Animal.Equals")
  let week = Week::from_index(6)
  expect_eq(week.get_size(), 7, "Week.GetSize")
  expect_eq(week.steps_to(0), 1, "Week.StepsTo")
  expect_eq(week.steps_back_to(0), -6, "Week.StepsBackTo")
  expect_eq(week.steps_close_to(0), 1, "Week.StepsCloseTo")
  let stem = HeavenStem::from_index(9)
  expect_eq(stem.get_size(), 10, "HeavenStem.GetSize")
  expect_eq(stem.steps_to(0), 1, "HeavenStem.StepsTo")
  expect_eq(stem.steps_back_to(0), -9, "HeavenStem.StepsBackTo")
  expect_eq(stem.steps_close_to(0), 1, "HeavenStem.StepsCloseTo")
  let branch = EarthBranch::from_index(11)
  expect_eq(branch.get_size(), 12, "EarthBranch.GetSize")
  expect_eq(branch.steps_to(0), 1, "EarthBranch.StepsTo")
  expect_eq(branch.steps_back_to(0), -11, "EarthBranch.StepsBackTo")
  expect_eq(branch.steps_close_to(0), 1, "EarthBranch.StepsCloseTo")
  let cycle = SixtyCycle::from_index(59)
  expect_eq(cycle.get_size(), 60, "SixtyCycle.GetSize")
  expect_eq(cycle.steps_to(0), 1, "SixtyCycle.StepsTo")
  expect_eq(cycle.steps_back_to(0), -59, "SixtyCycle.StepsBackTo")
  expect_eq(cycle.steps_close_to(0), 1, "SixtyCycle.StepsCloseTo")
}
