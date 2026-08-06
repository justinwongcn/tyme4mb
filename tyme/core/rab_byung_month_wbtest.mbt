// 测试套件：RabByungMonth（对应 Go test/RabByungMonth_test.go，一比一翻译）

///|
test "rab_byung_month_0" {
  let m = RabByungMonth::from_ym(1950, 12).unwrap()
  expect_eq(
    m.to_string(),
    "第十六饶迥铁虎年十二月",
    "RabByungMonth.FromYm(1950,12).String()",
  )
}
