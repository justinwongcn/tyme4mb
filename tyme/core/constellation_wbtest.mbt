// 测试套件：Constellation（对应 Go test/Constellation_test.go，一比一翻译）

///|
test "constellation_0" {
  let d = SolarDay::from_ymd(2020, 3, 21).unwrap()
  expect_eq(
    d.get_constellation().get_name(),
    "白羊",
    "SolarDay(2020,3,21).GetConstellation().GetName()",
  )
  let d2 = SolarDay::from_ymd(2020, 4, 19).unwrap()
  expect_eq(
    d2.get_constellation().get_name(),
    "白羊",
    "SolarDay(2020,4,19).GetConstellation().GetName()",
  )
}

///|
test "constellation_1" {
  let d = SolarDay::from_ymd(2020, 4, 20).unwrap()
  expect_eq(
    d.get_constellation().get_name(),
    "金牛",
    "SolarDay(2020,4,20).GetConstellation().GetName()",
  )
  let d2 = SolarDay::from_ymd(2020, 5, 20).unwrap()
  expect_eq(
    d2.get_constellation().get_name(),
    "金牛",
    "SolarDay(2020,5,20).GetConstellation().GetName()",
  )
}

///|
test "constellation_2" {
  let d = SolarDay::from_ymd(2020, 5, 21).unwrap()
  expect_eq(
    d.get_constellation().get_name(),
    "双子",
    "SolarDay(2020,5,21).GetConstellation().GetName()",
  )
  let d2 = SolarDay::from_ymd(2020, 6, 21).unwrap()
  expect_eq(
    d2.get_constellation().get_name(),
    "双子",
    "SolarDay(2020,6,21).GetConstellation().GetName()",
  )
}

///|
test "constellation_3" {
  let d = SolarDay::from_ymd(2020, 6, 22).unwrap()
  expect_eq(
    d.get_constellation().get_name(),
    "巨蟹",
    "SolarDay(2020,6,22).GetConstellation().GetName()",
  )
  let d2 = SolarDay::from_ymd(2020, 7, 22).unwrap()
  expect_eq(
    d2.get_constellation().get_name(),
    "巨蟹",
    "SolarDay(2020,7,22).GetConstellation().GetName()",
  )
}
