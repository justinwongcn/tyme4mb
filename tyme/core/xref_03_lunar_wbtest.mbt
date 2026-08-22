///|
test "xref_lunar" {
  // LMY 农历年：边界 + 常规 + 闰月年
  for y in [-2, 0, 1, 1900, 2023, 2024, 2025, 2033] {
    match LunarYear::from_year(y) {
      Err(e) => println("LMY \{y} ERRMSG \{e}")
      Ok(ly) =>
        println(
          "LMY \{y} \{ly.get_name()}|\{ly.to_string()}|\{ly.get_leap_month()}|\{ly.get_month_count()}|\{ly.get_day_count()}|\{ly.get_sixty_cycle().to_string()}|\{ly.get_twenty().to_string()}|\{ly.get_nine_star().get_name()}|\{ly.get_jupiter_direction().to_string()}|\{ly.get_months().length()}|\{ly.get_first_month().to_string()}|\{ly.next(1).to_string()}",
        )
    }
  }
  let lym1 = LunarYear::from_year(-1).unwrap()
  println(
    "LMY -1 \{lym1.get_name()}|\{lym1.get_leap_month()}|\{lym1.get_month_count()}|\{lym1.get_sixty_cycle().to_string()}|\{lym1.next(1).to_string()}",
  )
  let ly9999 = LunarYear::from_year(9999).unwrap()
  println(
    "LMY 9999 \{ly9999.get_name()}|\{ly9999.get_leap_month()}|\{ly9999.get_month_count()}|\{ly9999.get_sixty_cycle().to_string()}|\{ly9999.get_twenty().to_string()}|\{ly9999.get_nine_star().get_name()}|\{ly9999.get_jupiter_direction().to_string()}",
  )
  // LMY Next 边界
  let ly = LunarYear::from_year(2024).unwrap()
  for n = -3; n <= 3; n = n + 1 {
    println("LMY NEXT \{n} \{ly.next(n).get_name()}|\{ly.next(n).get_year()}")
  }
  // LMM 农历月：非法输入
  for
    ym in [
      (2024, 0),
      (2024, 13),
      (2024, -13),
      (2024, -3),
      (2024, -4),
      (2023, -2),
      (2033, -12),
    ] {
    let (y0, m0) = ym
    match LunarMonth::from_ym(y0, m0) {
      Err(e) => println("LMM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // LMM 常规月（2024 闰二月）
  for
    ym in [
      (2024, 1),
      (2024, 2),
      (2024, -2),
      (2024, 3),
      (2024, 12),
      (2023, 2),
      (2033, 11),
      (2033, -11),
    ] {
    let (y0, m0) = ym
    match LunarMonth::from_ym(y0, m0) {
      Err(_) => println("LMM \{y0} \{m0} ERR")
      Ok(m) => {
        let jd = m.get_first_julian_day().get_day().to_int64()
        println(
          "LMM \{y0} \{m0} \{m.get_name()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_day_count()}|\{jd}|\{m.is_leap()}|\{m.get_month_with_leap()}|\{m.get_sixty_cycle().to_string()}|\{m.get_nine_star().get_name()}|\{m.get_jupiter_direction().to_string()}|\{m.get_minor_ren().get_name()}|\{m.get_week_count(1)}|\{m.get_season().get_name()}|\{m.get_first_day().to_string()}|\{m.get_lunar_year().to_string()}",
        )
      }
    }
  }
  // LMM GetDays 长度
  let mm = LunarMonth::from_ym(2024, 2).unwrap()
  println(
    "LMM DAYS \{mm.get_days().length()}|\{mm.get_days()[0].to_string()}|\{mm.get_days()[mm.get_days().length() - 1].to_string()}",
  )
  // LMM Next 跨年（含闰月）
  let bm = LunarMonth::from_ym(2024, 1).unwrap()
  for n = -5; n <= 5; n = n + 1 {
    let nm = bm.next(n)
    println(
      "LMM NEXT \{n} \{nm.to_string()}|\{nm.get_year()}|\{nm.get_month_with_leap()}",
    )
  }
  // LMD 农历日：非法日
  for ymd in [(2024, 1, 0), (2024, 1, 31), (2024, -2, 30), (2023, 2, 31)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("LMD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // LMD 常规日
  for
    ymd in [
      (2024, 1, 1),
      (2024, 1, 30),
      (2024, 2, 1),
      (2024, -2, 1),
      (2024, -2, 29),
      (2023, 12, 30),
      (2033, 11, 1),
    ] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMD \{y0} \{m0} \{d0} ERR")
      Ok(d) =>
        println(
          "LMD \{y0} \{m0} \{d0} \{d.get_name()}|\{d.to_string()}|\{d.get_week().get_name()}|\{d.get_sixty_cycle().to_string()}|\{d.get_nine_star().get_name()}|\{d.get_jupiter_direction().to_string()}|\{d.get_six_star().get_name()}|\{d.get_solar_day().to_string()}|\{d.get_twenty_eight_star().get_name()}|\{d.get_day()}|\{d.get_minor_ren().get_name()}",
        )
    }
  }
  // LMD Next / IsBefore / IsAfter / Equals
  let bd = LunarDay::from_ymd(2024, 1, 1).unwrap()
  let other = LunarDay::from_ymd(2024, 2, 1).unwrap()
  for n = -30; n <= 30; n = n + 10 {
    let nd = bd.next(n)
    println(
      "LMD NEXT \{n} \{nd.to_string()}|\{nd.is_before(other)}|\{nd.is_after(other)}|\{nd.equals(bd)}|\{nd.get_day()}",
    )
  }
  // LMS SolarDay.GetLunarDay 双向往返
  for
    ymd in [
      (1900, 1, 31),
      (2024, 1, 1),
      (2024, 2, 10),
      (2024, 3, 10),
      (2024, 12, 31),
      (2025, 1, 29),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMS \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let ld = sd.get_lunar_day()
        println(
          "LMS \{y0} \{m0} \{d0} \{ld.to_string()}|\{ld.get_solar_day().to_string()}|\{sd.to_string()}",
        )
      }
    }
  }
  // LMN SolarDay.GetNineStar
  for
    ymd in [
      (1900, 1, 31),
      (2024, 1, 1),
      (2024, 6, 21),
      (2024, 12, 21),
      (2024, 12, 22),
      (2025, 6, 21),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMN \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        println(
          "LMN \{y0} \{m0} \{d0} \{sd.get_nine_star().get_name()}|\{sd.get_lunar_day().to_string()}",
        )
    }
  }
}
