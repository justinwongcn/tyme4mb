// 测试套件：EclipticHideHeavenStemDay 真黄经人元司令分野（黑盒，经 @tyme 门面）

// 断言相等（api_test 黑盒包无共享 helper，此处按 core/test_helper_wbtest.mbt 写法自建）
///|
fn[ T : Eq + Show ] expect_eq(got : T, expected : T, msg : String) -> Unit {
  if got != expected {
    abort(
      "ASSERT EQ FAIL: \{msg}\n  got     = \{got}\n  expected = \{expected}",
    )
  }
}

// 近似相等（Double 用容差，照 core/test_helper_wbtest.mbt 的 expect_near）
///|
fn expect_near(got : Double, expected : Double, eps : Double, msg : String) -> Unit {
  let diff = got - expected
  // NaN 防护：NaN 与任何值比较均为 false，显式用自不等捕获
  if diff != diff || diff < -eps || diff > eps {
    abort(
      "ASSERT NEAR FAIL: \{msg}\n  got      = \{got}\n  expected = \{expected}\n  eps      = \{eps}",
    )
  }
}

///|
test "EclipticHideHeavenStemDay_month_boundaries" {
  // 立春 2024（节气索引 3，黄经 315°）。
  // 注意：SolarTerm 节气时刻按平黄经反解，而本接口按太阳视黄经（含章动+光行差）定位，
  // 两者存在约 1 分钟的系统错位，故边界锚点取节气时刻 ±2 小时（远大于错位量级）。
  let lichun = @tyme.SolarTerm::from_index(2024, 3)
  let t0 = lichun.get_julian_day().get_solar_time().unwrap()
  // 立春前 2 小时：视黄经 ≈ 314.92° < 315°，仍属丑月（小寒令），己土·第3段当令（丑月司令: 癸9 辛3 己18）
  let before = t0.next(-7200)
  let db = before.get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    db.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "己",
    "EclipticHideHeavenStemDay.GetHideHeavenStem().GetHeavenStem().GetName() before 立春",
  )
  expect_eq(
    db.get_sector_index(),
     2,
    "EclipticHideHeavenStemDay.GetSectorIndex() before 立春",
  )
  // 立春后 2 小时：视黄经 ≈ 315.08° > 315°，寅月戊土·第1段（[0,7)°）
  let after = t0.next(7200)
  let da = after.get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    da.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "戊",
    "EclipticHideHeavenStemDay.GetHideHeavenStem().GetHeavenStem().GetName() after 立春",
  )
  expect_eq(
    da.get_sector_index(),
     0,
    "EclipticHideHeavenStemDay.GetSectorIndex() after 立春",
  )
}

///|
test "EclipticHideHeavenStemDay_sector_angle" {
  // 立春后 1 天 ≈ 月令内黄经 0.99° → 戊土·第1段（[0,7)°）
  let lichun = @tyme.SolarTerm::from_index(2024, 3)
  let t0 = lichun.get_julian_day().get_solar_time().unwrap()
  let d1 = t0.next(86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d1.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "戊",
    "立春+1天 天干",
  )
  expect_eq(
    d1.get_sector_index(),
     0,
    "立春+1天 段序",
  )
  // 立春后 8 天 ≈ 7.9° → 丙火·第2段（[7,14)°）
  let d8 = t0.next(8 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d8.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "丙",
    "立春+8天 天干",
  )
  expect_eq(
    d8.get_sector_index(),
     1,
    "立春+8天 段序",
  )
  // 立春后 16 天 ≈ 15.8° → 甲木·第3段（[14,30)°）
  let d16 = t0.next(16 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d16.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "甲",
    "立春+16天 天干",
  )
  expect_eq(
    d16.get_sector_index(),
     2,
    "立春+16天 段序",
  )
  // 段起点度数：戊段 0°、丙段 7°、甲段 14°
  expect_near(d1.get_lon_offset(), 0.0, 1.0e-9, "戊段起点 0°")
  expect_near(d8.get_lon_offset(), 7.0, 1.0e-9, "丙段起点 7°")
  expect_near(d16.get_lon_offset(), 14.0, 1.0e-9, "甲段起点 14°")
  // 不变式：month_lon = lon_offset + angle_in_sector
  expect_near(
    d16.get_month_lon(),
    d16.get_lon_offset() + d16.get_angle_in_sector(),
    1.0e-6,
    "month_lon == lon_offset + angle_in_sector",
  )
}

///|
test "EclipticHideHeavenStemDay_no_middle_sector" {
  // 卯月（惊蛰）、酉月（白露）、子月（大雪）仅两段：表中间段为 (0,0) 占位
  // 段序直接从第1段 → 第3段（无第2段）
  let jingzhe = @tyme.SolarTerm::from_index(2024, 5)
  let j0 = jingzhe.get_julian_day().get_solar_time().unwrap()
  // 惊蛰 +5 天 ≈ 月令内黄经 4.9° → 仍 甲木·第1段（[0,10)°）
  let m5 = j0.next(5 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    m5.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "甲",
    "惊蛰+5天 天干",
  )
  expect_eq(
    m5.get_sector_index(),
     0,
    "惊蛰+5天 段序",
  )
  // 惊蛰 +11 天 ≈ 月令内黄经 10.8° → 乙木·第3段（[10,30)°），直接跳过第2段
  let m11 = j0.next(11 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    m11.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "乙",
    "惊蛰+11天 天干",
  )
  expect_eq(
    m11.get_sector_index(),
     2,
    "惊蛰+11天 段序",
  )
  // 固化两段制月令的段起点：第1段甲10 后直接到第3段，offset = 10°
  expect_near(m11.get_lon_offset(), 10.0, 1.0e-9, "惊蛰+11天 第3段起点 10°")
  // 酉月（白露 165°）：+5 天 ≈ 4.9° 庚金·第1段，+15 天 ≈ 14.8° 辛金·第3段
  let bailu = @tyme.SolarTerm::from_index(2024, 17)
  let b0 = bailu.get_julian_day().get_solar_time().unwrap()
  let b5 = b0.next(5 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    b5.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "庚",
    "白露+5天 天干",
  )
  expect_eq(
    b5.get_sector_index(),
     0,
    "白露+5天 段序",
  )
  let b15 = b0.next(15 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    b15.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "辛",
    "白露+15天 天干",
  )
  expect_eq(
    b15.get_sector_index(),
     2,
    "白露+15天 段序",
  )
  expect_near(b15.get_lon_offset(), 10.0, 1.0e-9, "白露+15天 第3段起点 10°")
  expect_near(b15.get_lon_offset(), 10.0, 1.0e-9, "白露+15天 第3段起点 10°")
  // 子月（大雪 255°）：+5 天 ≈ 4.9° 壬水·第1段，+15 天 ≈ 14.8° 癸水·第3段
  let daxue = @tyme.SolarTerm::from_index(2024, 23)
  let d0 = daxue.get_julian_day().get_solar_time().unwrap()
  let d5 = d0.next(5 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d5.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "壬",
    "大雪+5天 天干",
  )
  expect_eq(
    d5.get_sector_index(),
     0,
    "大雪+5天 段序",
  )
  let d15 = d0.next(15 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d15.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "癸",
    "大雪+15天 天干",
  )
  expect_eq(
    d15.get_sector_index(),
     2,
    "大雪+15天 段序",
  )
  expect_near(d15.get_lon_offset(), 10.0, 1.0e-9, "大雪+15天 第3段起点 10°")
}

///|
test "EclipticHideHeavenStemDay_diff_from_day_version" {
  // 两版差异固化 —— 用节气时刻作相对锚点（不依赖固定钟点，避免随年份漂移）。
  // 关键事实（实测 2024）：2024 立春 = 02-04 16:27:07。但立春时刻逐年漂移
  // （2025 = 02-03 22:10、2026 = 02-04 04:02），因此不能用固定\"当天 08:00\"作断言前提。
  let lichun = @tyme.SolarTerm::from_index(2024, 3)
  let t0 = lichun.get_julian_day().get_solar_time().unwrap()
  // 日版：以\"节气所在公历日\"划分，立春当天 00:00 起即切寅月 → 戊土余气（day_index=0）
  let day_solar = t0.get_solar_day()
  let day_d = day_solar.get_hide_heaven_stem_day()
  expect_eq(
    day_d.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "戊",
    "立春当天 00:00 起 日版 天干(寅月戊土)",
  )
  expect_eq(day_d.get_day_index(), 0, "立春当天 00:00 起 日版 day_index")
  // 度版在节气时刻之前仍属丑月（视黄经 < 315°）：取节气时刻前 2 小时
  let before = t0.next(-7200)
  let be = before.get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    be.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "己",
    "立春-2h 度版 天干(丑月己土)",
  )
  expect_eq(
    be.get_sector_index(),
     2,
    "立春-2h 度版 段序",
  )
  // 度版在节气时刻之后切寅月：取时刻后 2 小时，与日版一致（戊土余气）
  let after = t0.next(7200)
  let ae = after.get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    ae.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "戊",
    "立春+2h 度版 天干",
  )
  expect_eq(
    ae.get_sector_index(),
     0,
    "立春+2h 度版 段序",
  )
  // 日版在立春之后仍是戊土余气（同一天的延续）
  let ad = after.get_solar_day().get_hide_heaven_stem_day()
  expect_eq(
    ad.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "戊",
    "立春+2h 日版 天干",
  )
}

///|
test "EclipticHideHeavenStemDay_coexist_with_day_version" {
  // 2024-12-04 12:00 按日版为 壬水第16天（本气），黄经版应一致（天干相同、第3段当令）
  let t = @tyme.SolarTime::from_ymdhms(2024, 12, 4, 12, 0, 0).unwrap()
  let e = t.get_hide_heaven_stem_by_ecliptic()
  let d = t.get_solar_day().get_hide_heaven_stem_day()
  expect_eq(
    e.get_hide_heaven_stem().get_heaven_stem().get_name(),
    d.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "共存一致性: 天干一致",
  )
  expect_eq(
    e.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "壬",
    "2024-12-04 天干",
  )
  expect_eq(
    e.get_sector_index(),
     2,
    "2024-12-04 段序",
  )
}

///|
test "EclipticHideHeavenStemDay_example" {
  let t = @tyme.SolarTime::from_ymdhms(2024, 12, 4, 12, 0, 0).unwrap()
  let d = t.get_hide_heaven_stem_by_ecliptic()
  expect_eq(d.get_name(), "壬水", "GetName()")
  expect_eq(d.to_string(), "壬水", "String()")
  let _ = d.get_hide_heaven_stem()
  let _ = d.get_month_lon()
  let _ = d.get_lon_offset()
  let _ = d.get_angle_in_sector()
}

///|
test "EclipticHideHeavenStemDay_year_wrap" {
  // 惊蛰（345°）月令跨过 360°/0°：+20 天 ≈ 黄经 364.7°（归一化至 [0,360) → 4.7°）
  // month_lon = 4.7 - 345 < 0 → +360 → 19.7° → 乙木·第3段（[10,30)°）
  let jingzhe = @tyme.SolarTerm::from_index(2024, 5)
  let t0 = jingzhe.get_julian_day().get_solar_time().unwrap()
  let d = t0.next(20 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    d.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "乙",
    "惊蛰+20天跨0° 天干",
  )
  expect_eq(
    d.get_sector_index(),
     2,
    "惊蛰+20天跨0° 段序",
  )
  // 大雪（255°）后跨年：大雪 2024-12-06 + 26 天 ≈ 2025-01-01，
  // 黄经 ≈ 280.6° → month_lon ≈ 25.6° → 癸水·第3段（[10,30)°）
  let daxue = @tyme.SolarTerm::from_index(2024, 23)
  let t1 = daxue.get_julian_day().get_solar_time().unwrap()
  let ny = t1.next(26 * 86400).get_hide_heaven_stem_by_ecliptic()
  expect_eq(
    ny.get_hide_heaven_stem().get_heaven_stem().get_name(),
    "癸",
    "大雪+26天跨年 天干",
  )
  expect_eq(
    ny.get_sector_index(),
     2,
    "大雪+26天跨年 段序",
  )
}

///|
test "EclipticHideHeavenStemDay_all_months_sampling" {
  // 12 月令中覆盖剩余 6 令（清明/立夏/芒种/小暑/立秋/寒露）的段位采样。
  // 每令取第1/2/3段 3 个中点日（约等于月令内 4~10/12~13/18~23°），
  // 断言天干 + 段序 + 段起点，数据来自 2024 年实测算例。
  fn probe(term_idx : Int, days : Int, stem : String, sector : Int, offset : Double) -> Unit {
    let term = @tyme.SolarTerm::from_index(2024, term_idx)
    let t0 = term.get_julian_day().get_solar_time().unwrap()
    let d = t0.next(days * 86400).get_hide_heaven_stem_by_ecliptic()
    expect_eq(
      d.get_hide_heaven_stem().get_heaven_stem().get_name(),
      stem,
      "\{term.get_name()}+\{days}天 天干",
    )
    expect_eq(
      d.get_sector_index(),
      sector,
      "\{term.get_name()}+\{days}天 段序",
    )
    expect_near(d.get_lon_offset(), offset, 1.0e-6, "\{term.get_name()}+\{days}天 段起点")
    expect_eq(d.get_angle_in_sector() >= 0.0, true, "\{term.get_name()}+\{days}天 angle>=0")
  }
  // 清明(15°): 乙9 癸3 戊18
  probe(7, 4, "乙", 0, 0.0)
  probe(7, 10, "癸", 1, 9.0)
  probe(7, 20, "戊", 2, 12.0)
  // 立夏(45°): 戊5 庚9 丙16
  probe(9, 2, "戊", 0, 0.0)
  probe(9, 7, "庚", 1, 5.0)
  probe(9, 18, "丙", 2, 14.0)
  // 芒种(75°): 丙10 己9 丁11
  probe(11, 5, "丙", 0, 0.0)
  probe(11, 13, "己", 1, 10.0)
  probe(11, 23, "丁", 2, 19.0)
  // 小暑(105°): 丁9 乙3 己18
  probe(13, 4, "丁", 0, 0.0)
  probe(13, 10, "乙", 1, 9.0)
  probe(13, 20, "己", 2, 12.0)
  // 立秋(135°): 戊10 壬3 庚17
  probe(15, 5, "戊", 0, 0.0)
  probe(15, 12, "壬", 1, 10.0)
  probe(15, 18, "庚", 2, 13.0)
  // 寒露(195°): 辛9 丁3 戊18
  probe(19, 4, "辛", 0, 0.0)
  probe(19, 10, "丁", 1, 9.0)
  probe(19, 20, "戊", 2, 12.0)
}
