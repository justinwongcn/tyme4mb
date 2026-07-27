// 测试套件：LegalHoliday（对应 Go test/LegalHoliday_test.go，一比一翻译）

///|
test "legal_holiday_0" {
  let d = LegalHoliday::from_ymd(2011, 5, 1).unwrap()
  expect_eq(
    d.to_string(),
    "2011年5月1日 劳动节(休)",
    "LegalHoliday(2011,5,1).String()",
  )
  expect_eq(
    d.next(1).unwrap().to_string(),
    "2011年5月2日 劳动节(休)",
    "LegalHoliday(2011,5,1).Next(1).String()",
  )
  expect_eq(
    d.next(2).unwrap().to_string(),
    "2011年6月4日 端午节(休)",
    "LegalHoliday(2011,5,1).Next(2).String()",
  )
  expect_eq(
    d.next(-1).unwrap().to_string(),
    "2011年4月30日 劳动节(休)",
    "LegalHoliday(2011,5,1).Next(-1).String()",
  )
  expect_eq(
    d.next(-2).unwrap().to_string(),
    "2011年4月5日 清明节(休)",
    "LegalHoliday(2011,5,1).Next(-2).String()",
  )
}

///|
test "legal_holiday_1" {
  let d = LegalHoliday::from_ymd(2001, 12, 29).unwrap()
  expect_eq(
    d.to_string(),
    "2001年12月29日 元旦(班)",
    "LegalHoliday(2001,12,29).String()",
  )
}
