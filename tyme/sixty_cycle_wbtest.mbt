// 测试套件：SixtyCycle（对应 Go test/SixtyCycle_test.go，一比一翻译）

///|
test "sixty_cycle_0" {
  let got = SixtyCycle::from_index(13).get_name()
  expect_eq(got, "丁丑", "SixtyCycle.FromIndex(13).GetName()")
}

///|
test "sixty_cycle_1" {
  let o = SixtyCycle::from_name("辛酉").unwrap()
  expect_eq(o.get_sound().get_name(), "石榴木", "SixtyCycle.FromName(辛酉).GetSound().GetName()")
}
