// 测试套件：Element（对应 Go test/Element_test.go，一比一翻译）

///|
// element_0 五行测试
test "element_0" {
  // 地支寅的五行为木
  let d = EarthBranch::from_name("寅").unwrap()
  expect_eq(
    d.get_element().get_name(),
    "木",
    "EarthBranch(寅).GetElement().GetName()",
  )
  // 地支寅的五行(木)生火
  expect_eq(
    d.get_element().get_reinforce().get_name(),
    "火",
    "EarthBranch(寅).GetElement().GetReinforce().GetName()",
  )
}
