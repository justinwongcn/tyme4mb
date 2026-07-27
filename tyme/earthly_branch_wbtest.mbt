// 测试套件：EarthlyBranch（对应 Go test/EarthlyBranch_test.go，一比一翻译）

///|
test "earthly_branch_0" {
  expect_eq(
    EarthBranch::from_index(0).get_name(),
    "子",
    "EarthBranch.FromIndex(0).GetName()",
  )
}

///|
// earth_branch_1 六冲
test "earthly_branch_1" {
  let d = EarthBranch::from_name("子").unwrap()
  expect_eq(
    d.get_opposite().get_name(),
    "午",
    "EarthBranch(子).GetOpposite().GetName()",
  )
}

///|
// earth_branch_2 六合
test "earthly_branch_2" {
  let d = EarthBranch::from_name("申").unwrap()
  expect_eq(
    d.get_combine().get_name(),
    "巳",
    "EarthBranch(申).GetCombine().GetName()",
  )
}

///|
// earth_branch_3 六害
test "earthly_branch_3" {
  let d = EarthBranch::from_name("巳").unwrap()
  expect_eq(
    d.get_harm().get_name(),
    "寅",
    "EarthBranch(巳).GetHarm().GetName()",
  )
}

///|
// earth_branch_4 合化
test "earthly_branch_4" {
  let a = EarthBranch::from_name("卯").unwrap()
  let b = EarthBranch::from_name("戌").unwrap()
  expect_eq(
    a.combine(b).unwrap().get_name(),
    "火",
    "EarthBranch(卯).Combine(戌).GetName()",
  )
}

///|
// earth_branch_5 卯子无法合化，Combine 应返回 None
test "earthly_branch_5" {
  let a = EarthBranch::from_name("卯").unwrap()
  let b = EarthBranch::from_name("子").unwrap()
  expect_true(
    match a.combine(b) {
      None => true
      Some(_) => false
    },
    "EarthBranch(卯).Combine(子) 应返回 None",
  )
}
