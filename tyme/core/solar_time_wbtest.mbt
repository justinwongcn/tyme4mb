// 测试套件：SolarTime（对应 Go test/SolarTime_test.go，一比一翻译）

///|
test "solar_time_0" {
  let time = SolarTime::from_ymdhms(2023, 1, 1, 13, 5, 20).unwrap()
  expect_eq(
    time.get_name(),
    "13:05:20",
    "SolarTime(2023,1,1,13,5,20).GetName()",
  )
  expect_eq(
    time.next(-21).get_name(),
    "13:04:59",
    "SolarTime(2023,1,1,13,5,20).Next(-21).GetName()",
  )
  expect_eq(
    time.next(-81).get_name(),
    "13:03:59",
    "SolarTime(2023,1,1,13,5,20).Next(-81).GetName()",
  )
}

///|
test "solar_time_to_true_solar_time_120deg" {
  // 经度 120°E（标准经度），经度修正为 0，只有均时差修正
  // 2025-06-21 均时差接近 0，真太阳时应接近 12:00
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(120.0)
  expect_true(
    tst.get_hour() == 11 || tst.get_hour() == 12,
    "120°E TST hour should be 11 or 12",
  )
  // 均时差在 ±2 分钟内
  expect_true(
    tst.get_minute() >= 58 || tst.get_minute() <= 2,
    "120°E TST minute should be near 00",
  )
}

///|
test "solar_time_to_true_solar_time_beijing" {
  // 北京时间 2025-06-21 12:00:00，经度 116.39°E（北京）
  // 经度修正约 -14.4 分钟，均时差约 0，真太阳时应约 11:46
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(116.39)
  expect_true(tst.get_hour() == 11, "Beijing TST hour should be 11")
  expect_true(
    tst.get_minute() >= 40 && tst.get_minute() <= 50,
    "Beijing TST minute should be 40-50",
  )
}

///|
test "solar_time_to_true_solar_time_urumqi" {
  // 乌鲁木齐 87.62°E，与 120°E 差约 -32.4°，经度修正约 -129 分钟
  // 真太阳时应约 09:50
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(87.62)
  expect_true(tst.get_hour() == 9, "Urumqi TST hour should be 9")
  expect_true(
    tst.get_minute() >= 45 && tst.get_minute() <= 55,
    "Urumqi TST minute should be 45-55",
  )
}

///|
test "solar_time_to_true_solar_time_shanghai" {
  // 上海 121.47°E，经度修正约 +5.9 分钟，真太阳时应约 12:06
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let tst = st.to_true_solar_time(121.47)
  expect_true(tst.get_hour() == 12, "Shanghai TST hour should be 12")
  expect_true(
    tst.get_minute() >= 3 && tst.get_minute() <= 10,
    "Shanghai TST minute should be 3-10",
  )
}

///|
test "solar_noon_beijing" {
  // 北京 116.39°E，2025-06-21：正午 = 12:00 + 14.4分(经度) + 1.8分(均时差) ≈ 12:16
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let noon = st.get_solar_noon(116.39)
  expect_eq(noon.get_hour(), 12, "Beijing noon hour")
  expect_true(
    noon.get_minute() >= 14 && noon.get_minute() <= 18,
    "Beijing noon minute 14-18",
  )
}

///|
test "solar_noon_urumqi" {
  // 乌鲁木齐 87.62°E：正午 = 12:00 + 129.5分 + 1.8分 ≈ 14:11
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let noon = st.get_solar_noon(87.62)
  expect_eq(noon.get_hour(), 14, "Urumqi noon hour")
  expect_true(
    noon.get_minute() >= 9 && noon.get_minute() <= 13,
    "Urumqi noon minute 9-13",
  )
}

///|
test "solar_noon_standard_meridian" {
  // 120°E 标准经度：仅均时差修正 ≈ 12:02
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let noon = st.get_solar_noon(120.0)
  expect_eq(noon.get_hour(), 12, "120E noon hour")
  expect_true(
    noon.get_minute() >= 0 && noon.get_minute() <= 4,
    "120E noon minute 0-4",
  )
}

///|
test "solar_noon_roundtrip" {
  // 与 to_true_solar_time 严格互逆：正午换算回真太阳时应为 12:00:0x（取整误差 ≤ 5 秒）
  // 取均时差全年最大的 2025-11-03（约 +16.4 分钟）
  let st = SolarTime::from_ymdhms(2025, 11, 3, 9, 0, 0).unwrap()
  let noon = st.get_solar_noon(116.39)
  let tst = noon.to_true_solar_time(116.39)
  expect_eq(tst.get_hour(), 12, "roundtrip hour")
  expect_eq(tst.get_minute(), 0, "roundtrip minute")
  expect_true(tst.get_second() <= 5, "roundtrip second")
}

///|
test "solar_noon_roundtrip_urumqi" {
  // 最坏偏移情形：乌鲁木齐 87.62°E 正午偏移约 2 小时 15 分，
  // 均时差求值点漂移最大，锁定互逆承诺在最坏情形下依然成立
  let st = SolarTime::from_ymdhms(2025, 11, 3, 9, 0, 0).unwrap()
  let noon = st.get_solar_noon(87.62)
  let tst = noon.to_true_solar_time(87.62)
  expect_eq(tst.get_hour(), 12, "urumqi roundtrip hour")
  expect_eq(tst.get_minute(), 0, "urumqi roundtrip minute")
  expect_true(tst.get_second() <= 5, "urumqi roundtrip second")
}

///|
test "sunrise_sunset_beijing_summer" {
  // 北京（39.90°N, 116.39°E）2025-06-21：日出 ≈ 04:46，日落 ≈ 19:46（±3 分钟）
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let rise = st.get_sunrise(39.90, 116.39)
  let set = st.get_sunset(39.90, 116.39)
  expect_rise_set(rise, 4, 43, 48, "Beijing summer sunrise")
  expect_rise_set(set, 19, 44, 49, "Beijing summer sunset")
}

///|
test "sunrise_sunset_beijing_winter" {
  // 北京 2025-12-21：日出 ≈ 07:32，日落 ≈ 16:52（±3 分钟）
  let st = SolarTime::from_ymdhms(2025, 12, 21, 12, 0, 0).unwrap()
  let rise = st.get_sunrise(39.90, 116.39)
  let set = st.get_sunset(39.90, 116.39)
  expect_rise_set(rise, 7, 30, 34, "Beijing winter sunrise")
  expect_rise_set(set, 16, 50, 54, "Beijing winter sunset")
}

///|
test "sunrise_sunset_urumqi_summer" {
  // 乌鲁木齐（43.83°N, 87.62°E）2025-06-21：日出 ≈ 06:27，日落 ≈ 21:55（±4 分钟）
  let st = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let rise = st.get_sunrise(43.83, 87.62)
  let set = st.get_sunset(43.83, 87.62)
  expect_rise_set(rise, 6, 24, 31, "Urumqi summer sunrise")
  expect_rise_set(set, 21, 51, 58, "Urumqi summer sunset")
}

///|
test "sunrise_sunset_polar" {
  // 北纬 70° 夏至：极昼 → None；北纬 80° 冬至：极夜 → None
  // 注：SolarTime 未实现 Eq trait，不能用 == None 比较，须用模式匹配
  let jun = SolarTime::from_ymdhms(2025, 6, 21, 12, 0, 0).unwrap()
  let dec = SolarTime::from_ymdhms(2025, 12, 21, 12, 0, 0).unwrap()
  match jun.get_sunrise(70.0, 120.0) {
    None => ()
    Some(_) => abort("ASSERT FAIL: polar day sunrise should be None")
  }
  match jun.get_sunset(70.0, 120.0) {
    None => ()
    Some(_) => abort("ASSERT FAIL: polar day sunset should be None")
  }
  match dec.get_sunrise(80.0, 120.0) {
    None => ()
    Some(_) => abort("ASSERT FAIL: polar night sunrise should be None")
  }
  match dec.get_sunset(80.0, 120.0) {
    None => ()
    Some(_) => abort("ASSERT FAIL: polar night sunset should be None")
  }
}

///|
// expect_rise_set 断言日出/日落时刻：小时相等且分钟落在 [lo, hi]
fn expect_rise_set(
  t : SolarTime?,
  hour : Int,
  lo : Int,
  hi : Int,
  label : String,
) -> Unit {
  match t {
    None => abort("ASSERT FAIL: \{label} is None")
    Some(v) =>
      if v.get_hour() != hour || v.get_minute() < lo || v.get_minute() > hi {
        abort("ASSERT FAIL: \{label} got \{v.get_name()}")
      }
  }
}
