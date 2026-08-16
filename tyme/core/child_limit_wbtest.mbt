// 测试套件：童限（ChildLimit）

///|
test "child_limit_from_solar_time_reference" {
  // 钟表时刻直接构造（回归基准，锁定既有行为）
  let st = SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0).unwrap()
  let cl = ChildLimit::from_solar_time(st, Man)
  expect_eq(cl.get_eight_char().to_string(), "庚午 辛巳 庚辰 癸未", "clock eight char")
  expect_eq(cl.get_year_count(), 7, "clock year count")
  expect_eq(cl.get_month_count(), 2, "clock month count")
  expect_eq(cl.get_day_count(), 21, "clock day count")
  expect_eq(cl.get_hour_count(), 8, "clock hour count")
  expect_eq(cl.get_minute_count(), 36, "clock minute count")
  assert_true(cl.is_forward(), msg="clock forward")
}

///|
test "child_limit_from_true_solar_time" {
  let st = SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0).unwrap()
  // 乌鲁木齐 87.62°E：真太阳时 1990-05-15 12:24:12 → 午时
  let cl = ChildLimit::from_true_solar_time(st, Man, 87.62)
  // 四柱按真太阳时：时柱由未时改为午时
  expect_eq(cl.get_eight_char().to_string(), "庚午 辛巳 庚辰 壬午", "TST eight char")
  // 起运差值按钟表绝对时刻：计数与钟表版完全一致（核心断言）
  expect_eq(cl.get_year_count(), 7, "TST year count")
  expect_eq(cl.get_month_count(), 2, "TST month count")
  expect_eq(cl.get_day_count(), 21, "TST day count")
  expect_eq(cl.get_hour_count(), 8, "TST hour count")
  expect_eq(cl.get_minute_count(), 36, "TST minute count")
  assert_true(cl.is_forward(), msg="TST forward")
  // 童限开始时刻保持钟表出生时刻
  expect_eq(cl.get_start_time().to_string(), "1990年5月15日 14:30:00", "TST start time")
}

///|
test "child_limit_true_solar_time_not_naive" {
  // 对照组：naive 做法（先转真太阳时再传 from_solar_time）会扭曲时间差
  // （7年3个月1天20小时12分，日数差 10+），证明 from_true_solar_time 的双轨设计是必要的
  let st = SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0).unwrap()
  let cl = ChildLimit::from_true_solar_time(st, Man, 87.62)
  let naive = ChildLimit::from_solar_time(st.to_true_solar_time(87.62), Man)
  assert_true(
    cl.get_day_count() != naive.get_day_count(),
    msg="TST is not naive conversion",
  )
}
