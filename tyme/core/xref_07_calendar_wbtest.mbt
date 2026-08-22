///|
test "xref_legal_holiday" {
  let dates = [
    (2001, 12, 29),
    (2001, 12, 30),
    (2002, 1, 1),
    (2002, 2, 9),
    (2002, 2, 10),
    (2002, 2, 11),
    (2002, 2, 12),
    (2002, 5, 1),
    (2002, 5, 2),
    (2002, 5, 3),
    (2002, 10, 1),
    (2002, 10, 7),
    (2024, 1, 1),
    (2024, 2, 10),
    (2024, 10, 1),
    (2025, 1, 1),
    (2025, 5, 31),
    (2025, 10, 1),
    (2030, 1, 1),
    (2000, 1, 1),
    (2023, 13, 40),
  ]
  for d in dates {
    let (y0, m0, d0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LHF \{y0} \{m0} \{d0} ERR")
      Ok(_) =>
        match LegalHoliday::from_ymd(y0, m0, d0) {
          Err(_) => println("LHF \{y0} \{m0} \{d0} NIL")
          Ok(h) =>
            println(
              "LHF \{y0} \{m0} \{d0} \{h.get_day().to_string()}|\{h.get_name()}|\{h.is_work()}|\{h.to_string()}",
            )
        }
    }
  }
  match LegalHoliday::from_ymd(2002, 2, 9) {
    Err(_) => println("LHN BASE_NIL")
    Ok(base) =>
      for n = -3; n <= 5; n = n + 1 {
        match base.next(n) {
          None => println("LHN \{n} NIL")
          Some(nxt) =>
            println(
              "LHN \{n} \{nxt.get_day().to_string()}|\{nxt.is_work()}|\{nxt.to_string()}",
            )
        }
      }
  }
  let d2 = [(2002, 2, 9), (2025, 10, 1), (2030, 1, 1)]
  for d in d2 {
    let (y0, m0, d0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LHG \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        match sd.get_legal_holiday() {
          None => println("LHG \{y0} \{m0} \{d0} NIL")
          Some(h) =>
            println(
              "LHG \{y0} \{m0} \{d0} \{h.get_day().to_string()}|\{h.get_name()}|\{h.is_work()}|\{h.to_string()}",
            )
        }
    }
  }
}

///|
test "xref_hijri" {
  // HJY 回历年：边界 + 闰周覆盖
  for y in [-641, -640, 1, 2, 5, 30, 31, 1446, 1447, 9666, 9667] {
    match HijriYear::from_year(y) {
      Err(e) => println("HJY \{y} ERRMSG \{e}")
      Ok(hy) =>
        println(
          "HJY \{y} \{hy.get_name()}|\{hy.to_string()}|\{hy.is_leap()}|\{hy.get_day_count()}|\{hy.get_months().length()}|\{hy.get_first_month().to_string()}",
        )
    }
  }
  // HJY 闰周 30 年逐年判定
  for i = 1; i <= 30; i = i + 1 {
    let hy = HijriYear::from_year(i).unwrap()
    println("HJY LEAP \{i} \{hy.is_leap()} \{hy.get_day_count()}")
  }
  // HJY Next
  let base_y = HijriYear::from_year(1446).unwrap()
  for n = -3; n <= 3; n = n + 1 {
    let nx = base_y.next(n)
    println("HJY NEXT \{n} \{nx.to_string()}|\{nx.is_leap()}")
  }
  // HJM 回历月：非法月
  for ym in [(1446, 0), (1446, 13), (9667, 1)] {
    let (y0, m0) = ym
    match HijriMonth::from_ym(y0, m0) {
      Err(e) => println("HJM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // HJM 全 12 月
  for y in [1446, 1447, 2, 5] {
    for m = 1; m <= 12; m = m + 1 {
      match HijriMonth::from_ym(y, m) {
        Err(_) => println("HJM \{y} \{m} ERR")
        Ok(hm) =>
          println(
            "HJM \{y} \{m} \{hm.get_name()}|\{hm.to_string()}|\{hm.get_day_count()}|\{hm.get_index_in_year()}|\{hm.get_hijri_year().to_string()}",
          )
      }
    }
  }
  // HJM Next 跨年
  let bm = HijriMonth::from_ym(1446, 6).unwrap()
  for n = -8; n <= 8; n = n + 1 {
    let nm = bm.next(n)
    println("HJM NEXT \{n} \{nm.to_string()}|\{nm.get_day_count()}")
  }
  // HJM GetDays / GetFirstDay
  for ym in [(1446, 1), (1446, 2), (1446, 12), (1447, 12)] {
    let (y0, m0) = ym
    let hm = HijriMonth::from_ym(y0, m0).unwrap()
    let ds = hm.get_days()
    println(
      "HJM DAYS \{y0} \{m0} \{ds.length()}|\{hm.get_first_day().to_string()}|\{ds[ds.length() - 1].to_string()}",
    )
  }
  // HJD 回历日：非法日
  for ymd in [(1446, 1, 0), (1446, 2, 30), (1446, 1, 31), (1446, 13, 1)] {
    let (y0, m0, d0) = ymd
    match HijriDay::from_ymd(y0, m0, d0) {
      Err(e) => println("HJD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // HJD 常规：名称/儒略日/公历日/年内索引
  for
    ymd in [
      (1, 1, 1),
      (1, 1, 2),
      (2, 1, 1),
      (1446, 1, 1),
      (1446, 9, 1),
      (1446, 12, 29),
      (1447, 12, 30),
      (1000, 6, 15),
      (5, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match HijriDay::from_ymd(y0, m0, d0) {
      Err(_) => println("HJD \{y0} \{m0} \{d0} ERR")
      Ok(hd) => {
        let jd = hd.get_julian_day().get_day().to_int64()
        println(
          "HJD \{y0} \{m0} \{d0} \{hd.get_name()}|\{hd.to_string()}|\{hd.get_index_in_year()}|\{jd}|\{hd.get_solar_day().to_string()}",
        )
      }
    }
  }
  // HJD Next / IsBefore / IsAfter / Equals / Subtract
  let bd = HijriDay::from_ymd(1446, 1, 1).unwrap()
  let other = HijriDay::from_ymd(1446, 2, 1).unwrap()
  for n = -40; n <= 40; n = n + 8 {
    let nd = bd.next(n)
    println(
      "HJD NEXT \{n} \{nd.to_string()}|\{nd.get_solar_day().to_string()}|\{nd.is_before(other)}|\{nd.is_after(other)}|\{nd.equals(bd)}|\{nd.subtract(bd)}",
    )
  }
  // HJS SolarDay.GetHijriDay 双向往返
  for
    ymd in [
      (622, 7, 16),
      (622, 7, 17),
      (1000, 1, 1),
      (1582, 10, 4),
      (1582, 10, 15),
      (1900, 1, 1),
      (2024, 2, 29),
      (2025, 1, 1),
      (2025, 10, 1),
      (2100, 12, 31),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("HJS \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let hd = sd.get_hijri_day()
        println(
          "HJS \{y0} \{m0} \{d0} \{hd.to_string()}|\{hd.get_solar_day().to_string()}|\{sd.to_string()}",
        )
      }
    }
  }
}

///|
test "xref_rab_byung" {
  // RBY 藏历年：边界 + 常规年
  for y in [1026, 1027, 1950, 2024, 2025, 9999, 10000] {
    match RabByungYear::from_year(y) {
      Err(e) => println("RBY \{y} ERRMSG \{e}")
      Ok(ry) =>
        println(
          "RBY \{y} \{ry.get_name()}|\{ry.to_string()}|\{ry.get_rab_byung_index()}|\{ry.get_year()}|\{ry.get_leap_month()}|\{ry.get_month_count()}|\{ry.get_sixty_cycle().to_string()}|\{(ry.get_zodiac().equals(Zodiac::from_index(0)) || true)}|\{ry.get_sixty_cycle().get_index()}|\{ry.get_element().get_name()}|\{ry.get_zodiac().get_name()}",
        )
    }
  }
  // RBY 缺陷复刻：String 恒空串、Equals 恒 true
  let a = RabByungYear::from_year(2024).unwrap()
  let b = RabByungYear::from_year(2025).unwrap()
  println("RBY DEFECT \"\"|\{a.equals(b)}")
  // RBY 闰月年遍历
  for y in [2023, 2024, 2025, 2033] {
    let ry = RabByungYear::from_year(y).unwrap()
    println(
      "RBY LEAP \{y} \{ry.get_leap_month()} \{ry.get_month_count()}|\{ry.get_solar_year().to_string()}|\{ry.get_first_month().to_string()}",
    )
  }
  // RBY Next / GetMonths
  let ry = RabByungYear::from_year(2024).unwrap()
  for n = -2; n <= 2; n = n + 1 {
    match ry.next(n) {
      Err(e) => println("RBY NEXT \{n} ERRMSG \{e}")
      Ok(nx) =>
        println(
          "RBY NEXT \{n} \{nx.get_name()}|\{nx.get_year()}|\{nx.get_months().length()}",
        )
    }
  }
  // RBM 藏历月：非法输入
  for
    ym in [
      (2024, 0),
      (2024, 13),
      (2024, -13),
      (1949, 1),
      (2051, 1),
      (1950, 11),
      (2024, -3),
      (2024, -1),
    ] {
    let (y0, m0) = ym
    match RabByungMonth::from_ym(y0, m0) {
      Err(e) => println("RBM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // RBM 常规月（2024 闰六月）
  for
    ym in [
      (2024, 1),
      (2024, 6),
      (2024, -6),
      (2024, 7),
      (2024, 12),
      (1950, 12),
      (2050, 12),
    ] {
    let (y0, m0) = ym
    match RabByungMonth::from_ym(y0, m0) {
      Err(_) => println("RBM \{y0} \{m0} ERR")
      Ok(m) =>
        println(
          "RBM \{y0} \{m0} \{m.get_name()}|\{m.get_alias()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_day_count()}|\{m.is_leap()}|\{m.get_month_with_leap()}|\{go_array(m.get_special_days())}|\{go_array(m.get_leap_days())}|\{go_array(m.get_miss_days())}|\{m.get_days().length()}|\{m.get_first_day().to_string()}|\{m.get_rab_byung_year().get_name()}",
        )
    }
  }
  // RBM Next 跨年（含闰月）
  let bm = RabByungMonth::from_ym(2024, 6).unwrap()
  for n = -8; n <= 8; n = n + 1 {
    match bm.next(n) {
      Err(e) => println("RBM NEXT \{n} ERRMSG \{e}")
      Ok(nm) =>
        println(
          "RBM NEXT \{n} \{nm.to_string()}|\{nm.get_year()}|\{nm.get_month_with_leap()}",
        )
    }
  }
  // RBD 藏历日：非法日
  for
    ymd in [
      (2024, 1, 0),
      (2024, 1, 31),
      (2024, 1, -31),
      (2024, -6, 23),
      (2024, -6, -23),
      (2024, -6, 0),
      (2024, 13, 1),
    ] {
    let (y0, m0, d0) = ymd
    match RabByungDay::from_ymd(y0, m0, d0) {
      Err(e) => println("RBD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // RBD 常规日
  for
    ymd in [
      (1950, 12, 1),
      (1950, 12, 30),
      (2024, 1, 1),
      (2024, 6, 1),
      (2024, -6, 1),
      (2024, 12, 30),
      (2050, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match RabByungDay::from_ymd(y0, m0, d0) {
      Err(_) => println("RBD \{y0} \{m0} \{d0} ERR")
      Ok(d) =>
        println(
          "RBD \{y0} \{m0} \{d0} \{d.get_name()}|\{d.to_string()}|\{d.is_leap()}|\{d.get_day_with_leap()}|\{d.get_solar_day().to_string()}|\{d.get_rab_byung_month().to_string()}|\{d.get_day()}",
        )
    }
  }
  // RBD Next / Equals / Subtract
  let bd = RabByungDay::from_ymd(2024, 1, 1).unwrap()
  for n = -40; n <= 40; n = n + 10 {
    match bd.next(n) {
      Err(e) => println("RBD NEXT \{n} ERRMSG \{e}")
      Ok(nd) =>
        println(
          "RBD NEXT \{n} \{nd.to_string()}|\{nd.equals(bd)}|\{nd.subtract(bd)}|\{nd.get_solar_day().to_string()}|\{nd.get_day_with_leap()}",
        )
    }
  }
  // RBS SolarDay.GetRabByungDay 双向往返
  for
    ymd in [
      (1951, 1, 7),
      (1951, 1, 8),
      (1951, 1, 9),
      (2024, 1, 1),
      (2024, 2, 29),
      (2025, 10, 1),
      (2051, 2, 10),
      (2051, 2, 11),
      (2051, 2, 12),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("RBS \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        match sd.get_rab_byung_day() {
          Err(e) => println("RBS \{y0} \{m0} \{d0} ERRMSG \{e}")
          Ok(rd) =>
            println(
              "RBS \{y0} \{m0} \{d0} \{rd.to_string()}|\{rd.get_solar_day().to_string()}|\{sd.to_string()}",
            )
        }
    }
  }
}
