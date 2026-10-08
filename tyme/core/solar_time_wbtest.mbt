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

///|
// day_length_at 指定日期与地点（经度东正西负）的昼长秒数
// 极昼或极夜（日出或日落为 None）返回 None
fn day_length_at(
  year : Int,
  month : Int,
  day : Int,
  latitude : Double,
  longitude : Double,
) -> Int64? {
  let st = SolarTime::from_ymdhms(year, month, day, 12, 0, 0).unwrap()
  match st.get_sunrise(latitude, longitude) {
    None => None
    Some(rise) =>
      match st.get_sunset(latitude, longitude) {
        None => None
        Some(set) => Some(set.subtract(rise))
      }
  }
}

///|
// expect_polar_day_or_night 断言极昼或极夜：日出与日落同时为 None
// get_sunrise/get_sunset 不区分极昼与极夜，只以 None 表示"太阳当日不穿越地平线"
fn expect_polar_day_or_night(
  year : Int,
  month : Int,
  day : Int,
  latitude : Double,
  longitude : Double,
  label : String,
) -> Unit {
  let st = SolarTime::from_ymdhms(year, month, day, 12, 0, 0).unwrap()
  match st.get_sunrise(latitude, longitude) {
    None => ()
    Some(v) => abort("ASSERT FAIL: \{label} sunrise should be None, got \{v}")
  }
  match st.get_sunset(latitude, longitude) {
    None => ()
    Some(v) => abort("ASSERT FAIL: \{label} sunset should be None, got \{v}")
  }
}

///|
// expect_rise_before_set 断言非极昼极夜：日出日落均有值，且日出早于日落
fn expect_rise_before_set(
  year : Int,
  month : Int,
  day : Int,
  latitude : Double,
  longitude : Double,
  label : String,
) -> Unit {
  let st = SolarTime::from_ymdhms(year, month, day, 12, 0, 0).unwrap()
  match st.get_sunrise(latitude, longitude) {
    None => abort("ASSERT FAIL: \{label} sunrise is None")
    Some(rise) =>
      match st.get_sunset(latitude, longitude) {
        None => abort("ASSERT FAIL: \{label} sunset is None")
        Some(set) =>
          if rise.is_after(set) {
            abort(
              "ASSERT FAIL: \{label} sunrise \{rise} is after sunset \{set}",
            )
          }
      }
  }
}

///|
test "sunrise_sunset_day_length_trend_north" {
  // 春分（2025-03-20）后北半球昼长单调增；秋分（2025-09-22）后单调减。
  // 统一时角公式 cos H = (cos 90.833° − sinφ·sinδ)/(cosφ·cosδ) 由 δ 的符号
  // 自动决定昼长增减方向，无需按春分/秋分分支——本测试锁定该行为。
  let mar21 = day_length_at(2025, 3, 21, 39.90, 120.0).unwrap()
  let mar22 = day_length_at(2025, 3, 22, 39.90, 120.0).unwrap()
  let mar23 = day_length_at(2025, 3, 23, 39.90, 120.0).unwrap()
  expect_true(mar21 < mar22, "north day length grows Mar 21→22")
  expect_true(mar22 < mar23, "north day length grows Mar 22→23")
  let sep21 = day_length_at(2025, 9, 21, 39.90, 120.0).unwrap()
  let sep22 = day_length_at(2025, 9, 22, 39.90, 120.0).unwrap()
  let sep23 = day_length_at(2025, 9, 23, 39.90, 120.0).unwrap()
  expect_true(sep21 > sep22, "north day length shrinks Sep 21→22")
  expect_true(sep22 > sep23, "north day length shrinks Sep 22→23")
}

///|
test "sunrise_sunset_day_length_trend_south" {
  // 南半球与北半球反相：春分后昼长递减，秋分后递增
  // （δ 的符号与纬度符号共同决定，同一个公式自然覆盖四种组合）
  let mar21 = day_length_at(2025, 3, 21, -33.87, 120.0).unwrap()
  let mar22 = day_length_at(2025, 3, 22, -33.87, 120.0).unwrap()
  let mar23 = day_length_at(2025, 3, 23, -33.87, 120.0).unwrap()
  expect_true(mar21 > mar22, "south day length shrinks Mar 21→22")
  expect_true(mar22 > mar23, "south day length shrinks Mar 22→23")
  let sep21 = day_length_at(2025, 9, 21, -33.87, 120.0).unwrap()
  let sep22 = day_length_at(2025, 9, 22, -33.87, 120.0).unwrap()
  let sep23 = day_length_at(2025, 9, 23, -33.87, 120.0).unwrap()
  expect_true(sep21 < sep22, "south day length grows Sep 21→22")
  expect_true(sep22 < sep23, "south day length grows Sep 22→23")
}

///|
test "sunrise_sunset_equator_day_length_stable" {
  // 赤道全年昼长稳定在 12h07m 附近，波动不足 1 分钟
  let dates : Array[(Int, Int, Int)] = [
    (2025, 1, 1),
    (2025, 3, 20),
    (2025, 6, 21),
    (2025, 9, 22),
    (2025, 12, 21),
  ]
  for (y, m, d) in dates {
    let len = day_length_at(y, m, d, 0.0, 120.0).unwrap()
    // 43590s = 12:06:30，43650s = 12:07:30
    expect_true(
      len >= 43590L && len <= 43650L,
      "equator day length should stay within 12:06:30..12:07:30 on \{y}-\{m}-\{d}, got \{len}",
    )
  }
  // 二分日赤道视昼长仍略长于 12h，证明 0.833°（蒙气差 34′ + 太阳视半径 16′）修正确实生效
  let equinox = day_length_at(2025, 3, 20, 0.0, 120.0).unwrap()
  expect_true(equinox > 43200L, "equinox equator apparent day exceeds 12h")
}

///|
test "sunrise_sunset_polar_day_boundary_june" {
  // 夏至日（δ ≈ +23.44°）北半球极昼临界纬度 = 90° − |δ| − 0.833° ≈ 65.73°
  // 蒙气差与太阳视半径使极昼范围比几何值更靠南
  expect_rise_before_set(2025, 6, 21, 65.5, 120.0, "65.5N June solstice")
  expect_polar_day_or_night(2025, 6, 21, 66.0, 120.0, "66.0N June solstice")
  expect_polar_day_or_night(2025, 6, 21, 70.0, 120.0, "70.0N June solstice")
  // 南半球同纬度此时只是短昼（极夜临界在 67.39°S 以南），锁住半球反相
  expect_rise_before_set(2025, 6, 21, -66.0, 120.0, "66.0S June solstice")
  expect_polar_day_or_night(2025, 6, 21, -67.5, 120.0, "67.5S June solstice")
}

///|
test "sunrise_sunset_polar_night_boundary_december" {
  // 冬至日（δ ≈ −23.44°）北半球极夜临界纬度 = 90° − |δ| + 0.833° ≈ 67.39°
  expect_rise_before_set(2025, 12, 21, 67.39, 120.0, "67.39N December solstice")
  // 临界纬度附近昼长压缩到 15 分钟以内，说明 None 边界是连续过渡而非跳变
  let len = day_length_at(2025, 12, 21, 67.39, 120.0).unwrap()
  expect_true(
    len < 900L,
    "67.39N December day length should be under 15 minutes",
  )
  expect_polar_day_or_night(
    2025, 12, 21, 67.5, 120.0, "67.5N December solstice",
  )
  expect_polar_day_or_night(
    2025, 12, 21, 80.0, 120.0, "80.0N December solstice",
  )
  // 南半球同纬度此时为极昼
  expect_polar_day_or_night(
    2025, 12, 21, -67.5, 120.0, "67.5S December solstice",
  )
}

///|
test "sunrise_sunset_ordering_and_symmetry" {
  // 不变量：日出必然早于日落；且 None（极昼/极夜）必然成对出现，不会只缺一个
  let lats : Array[Double] = [-60.0, -33.87, 0.0, 23.5, 39.9, 55.0, 65.0]
  let lons : Array[Double] = [116.39, 87.62, 120.0]
  for m = 1; m <= 12; m = m + 3 {
    for d = 1; d <= 28; d = d + 9 {
      for lat in lats {
        for lon in lons {
          let st = SolarTime::from_ymdhms(2025, m, d, 12, 0, 0).unwrap()
          let rise = st.get_sunrise(lat, lon)
          let set = st.get_sunset(lat, lon)
          match rise {
            Some(r) =>
              match set {
                Some(s) =>
                  if r.is_after(s) {
                    abort(
                      "ASSERT FAIL: rise \{r} after set \{s} at lat=\{lat} lon=\{lon}",
                    )
                  }
                None =>
                  abort(
                    "ASSERT FAIL: sunrise present but sunset None at lat=\{lat} lon=\{lon}",
                  )
              }
            None =>
              match set {
                Some(s) =>
                  abort(
                    "ASSERT FAIL: sunset \{s} present but sunrise None at lat=\{lat} lon=\{lon}",
                  )
                None => ()
              }
          }
        }
      }
    }
  }
}
