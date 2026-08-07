// 测试套件：真太阳时天文函数

///|
// 浮点近似断言（容许误差 eps）
fn expect_near(a : Double, b : Double, eps : Double, msg : String) -> Unit {
  if (a - b).abs() > eps {
    abort("ASSERT NEAR FAIL: \{msg}\n  a=\{a} b=\{b} eps=\{eps}")
  }
}

///|
// 断言为真
fn expect_true(cond : Bool, msg : String) -> Unit {
  if !cond {
    abort("ASSERT TRUE FAIL: \{msg}")
  }
}

///|
test "mean_obliquity_j2000" {
  // J2000 历元 (t=0)，平黄赤交角应约 23.4393° = 23°26'21.448"
  // 0.4090928 弧度 ≈ 23.4393°
  let eps = mean_obliquity(0.0)
  // 允许 1 角秒误差
  expect_near(eps, 0.4090928, 1.0 / SecondPerRad, "mean_obliquity(0)")
}

///|
test "mean_obliquity_2025" {
  // 2025 年约 t = 0.25 世纪
  let eps = mean_obliquity(0.25)
  // 黄赤交角在缓慢减小，应略小于 J2000 值
  expect_true(eps < 0.4090928, "mean_obliquity should decrease over time")
}

///|
test "sa_lon_returns_apparent_longitude" {
  // sa_lon 应返回太阳视黄经（弧度），是累积值可能远大于 2π
  let lon = sa_lon(0.25, 10)
  expect_true(lon > 0.0, "sa_lon should be positive")
}

///|
test "nutation_obliquity_j2000" {
  // J2000 交角章动主项约 +2.56 角秒 = 2.56/SecondPerRad 弧度
  let nut = nutation_obliquity(0.0)
  // 交角章动范围约 ±10 角秒
  expect_true(
    nut.abs() < 15.0 / SecondPerRad,
    "nutation_obliquity should be within ±15 arcsec",
  )
}

///|
test "true_obliquity_j2000" {
  // 真黄赤交角 = 平黄赤交角 + 交角章动
  let mean_eps = mean_obliquity(0.0)
  let nut_eps = nutation_obliquity(0.0)
  let true_eps = true_obliquity(0.0)
  expect_near(
    true_eps,
    mean_eps + nut_eps,
    1.0e-15,
    "true_obliquity = mean + nutation",
  )
}

///|
test "lo_to_ra_at_spring_equinox" {
  // 春分点：黄经=0，赤经应=0
  let ra = lo_to_ra(0.0, 0.0, 0.0)
  expect_near(ra, 0.0, 1.0e-10, "lo_to_ra(0,0,0) should be 0")
}

///|
test "lo_to_ra_at_90deg" {
  // 黄经=90°（夏至方向），赤经应≈90°（因黄纬=0时赤经=黄经投影）
  let lo = @math.PI / 2.0
  let ra = lo_to_ra(0.0, lo, 0.0)
  // 赤经应接近 lo 但不完全等于（因黄赤交角影响）
  expect_true(ra > 1.0 && ra < 2.0, "ra should be near π/2")
}

///|
test "sun_apparent_ra_range" {
  // 太阳视赤经应在 [0, 2π) 范围内
  let ra = sun_apparent_ra(0.25)
  expect_true(ra >= 0.0 && ra < Pi2, "sun_apparent_ra should be in [0, 2π)")
}

///|
test "equation_of_time_range" {
  // 均时差应在 [-0.3, 0.3] 小时（约 ±18 分钟）范围内
  let eot = equation_of_time(0.25)
  expect_true(eot >= -0.3 && eot <= 0.3, "EoT should be within ±0.3 hours")
}

///|
test "equation_of_time_year_range" {
  // 遍历一年中多个时间点，均时差应在 [-0.3, 0.3] 小时范围内
  for i = 0; i < 12; i = i + 1 {
    let t = 0.25 + i.to_double() * 0.08
    let eot = equation_of_time(t)
    expect_true(eot >= -0.3 && eot <= 0.3, "EoT at t=\{t} out of range: \{eot}")
  }
}

///|
test "equation_of_time_not_zero" {
  // 均时差不应该恒为 0
  let eot_jan = equation_of_time(0.25) // ≈2025-01-01
  let eot_jun = equation_of_time(0.254666) // ≈2025-06-21
  expect_true(eot_jan != 0.0 || eot_jun != 0.0, "EoT should not be always zero")
  // 不同季节的均时差应该显著不同（1月≈-0.055h, 6月≈-0.026h, 差约0.029h）
  expect_true((eot_jan - eot_jun).abs() > 0.001, "EoT should vary with season")
}
