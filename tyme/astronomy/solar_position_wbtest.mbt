// 测试套件：太阳视赤纬

///|
test "solar_declination_solstices" {
  // 2025-06-21 12:00 UT ≈ t=0.254716（J2000 起 9303 天）→ δ ≈ +23.43°（0.4092 rad）
  let d1 = solar_declination(0.254716)
  expect_true(d1 > 0.404 && d1 < 0.414, "June solstice declination")
  // 2025-12-21 12:00 UT ≈ t=0.259713（9486 天）→ δ ≈ −23.43°
  let d2 = solar_declination(0.259713)
  expect_true(d2 < -0.404 && d2 > -0.414, "December solstice declination")
  // 2025-03-20 12:00 UT ≈ t=0.252138（9210 天）→ 春分附近 δ ≈ 0
  let d3 = solar_declination(0.252138)
  expect_true(d3 > -0.05 && d3 < 0.05, "Equinox declination")
}
