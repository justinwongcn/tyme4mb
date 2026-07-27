// 测试套件：Phenology / PhenologyDay（对应 Go test/Phenology_test.go，一比一翻译）

///|
test "phenology_0" {
  let solar_day = SolarDay::from_ymd(2020, 4, 23).unwrap()
  let phenology_day = solar_day.get_phenology_day()
  let three_phenology =
    phenology_day.get_phenology().get_three_phenology()

  expect_eq(
    solar_day.get_term().get_name(),
    "谷雨",
    "SolarDay(2020,4,23).GetTerm().GetName()",
  )
  expect_eq(
    three_phenology.get_name(),
    "初候",
    "Phenology.GetThreePhenology().GetName()",
  )
  expect_eq(
    phenology_day.get_name(),
    "萍始生",
    "PhenologyDay.GetName()",
  )
  expect_eq(
    phenology_day.get_day_index(),
    4,
    "PhenologyDay.GetDayIndex()",
  )
}

///|
test "phenology_1" {
  let p = Phenology::from_index(2026, 1)
  let jd = p.get_julian_day()

  expect_eq(
    p.get_name(),
    "麋角解",
    "Phenology.FromIndex(2026,1).GetName()",
  )
  expect_eq(
    jd.get_solar_day().to_string(),
    "2025年12月26日",
    "Phenology.GetJulianDay().GetSolarDay().String()",
  )
  expect_eq(
    jd.get_solar_time().to_string(),
    "2025年12月26日 20:49:56",
    "Phenology.GetJulianDay().GetSolarTime().String()",
  )
}

///|
test "phenology_2" {
  let d = SolarDay::from_ymd(2025, 12, 26).unwrap()
  let p = d.get_phenology()
  let jd = p.get_julian_day()

  expect_eq(
    p.get_name(),
    "麋角解",
    "SolarDay(2025,12,26).GetPhenology().GetName()",
  )
  expect_eq(
    jd.get_solar_day().to_string(),
    "2025年12月26日",
    "Phenology.GetJulianDay().GetSolarDay().String()",
  )
  expect_eq(
    jd.get_solar_time().to_string(),
    "2025年12月26日 20:49:56",
    "Phenology.GetJulianDay().GetSolarTime().String()",
  )
}

///|
test "phenology_3" {
  let d =
    SolarTime::from_ymdhms(2025, 12, 26, 20, 49, 55).unwrap()
  let p = d.get_phenology()
  expect_eq(
    p.get_name(),
    "蚯蚓结",
    "SolarTime(2025,12,26,20,49,55).GetPhenology().GetName()",
  )

  let d2 =
    SolarTime::from_ymdhms(2025, 12, 26, 20, 49, 56).unwrap()
  let p2 = d2.get_phenology()
  expect_eq(
    p2.get_name(),
    "麋角解",
    "SolarTime(2025,12,26,20,49,56).GetPhenology().GetName()",
  )
}
