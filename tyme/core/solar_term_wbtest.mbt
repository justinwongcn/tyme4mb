// 测试套件：SolarTerm（对应 Go test/SolarTerm_test.go，一比一翻译）

///|
test "solar_term_0" {
  let d = SolarTerm::from_name(2023, "冬至").unwrap()
  expect_eq(d.get_name(), "冬至", "SolarTerm(2023,冬至).GetName()")
  expect_eq(
    d.get_julian_day().get_solar_day().unwrap().to_string(),
    "2022年12月22日",
    "SolarTerm(2023,冬至).GetJulianDay().GetSolarDay().String()",
  )
  expect_eq(
    d.get_solar_day().to_string(),
    "2022年12月22日",
    "SolarTerm(2023,冬至).GetSolarDay().String()",
  )
}

///|
test "solar_term_1" {
  let d = SolarTerm::from_name(2023, "冬至").unwrap()
  expect_eq(
    d.get_julian_day().get_solar_time().unwrap().to_string(),
    "2022年12月22日 05:48:12",
    "SolarTerm(2023,冬至).GetJulianDay().GetSolarTime().String()",
  )
  expect_eq(
    d.get_solar_day().to_string(),
    "2022年12月22日",
    "SolarTerm(2023,冬至).GetSolarDay().String()",
  )
}

///|
test "solar_term_2" {
  let d = SolarTerm::from_name(2025, "惊蛰").unwrap()
  expect_eq(
    d.get_julian_day().get_solar_time().unwrap().to_string(),
    "2025年3月5日 16:07:18",
    "SolarTerm(2025,惊蛰).GetJulianDay().GetSolarTime().String()",
  )
  expect_eq(
    d.get_solar_day().to_string(),
    "2025年3月5日",
    "SolarTerm(2025,惊蛰).GetSolarDay().String()",
  )
}
