///|
test "xref_sixty_cycle" {
  // SCY 干支年
  for y in [-2, -1, 0, 1, 1900, 2024, 2025, 9999, 10000] {
    match SixtyCycleYear::from_year(y) {
      Err(e) => println("SCY \{y} ERRMSG \{e}")
      Ok(sy) =>
        println(
          "SCY \{y} \{sy.get_name()}|\{sy.to_string()}|\{sy.get_sixty_cycle().to_string()}|\{sy.get_twenty().to_string()}|\{sy.get_nine_star().get_name()}|\{sy.get_jupiter_direction().to_string()}|\{sy.get_months().length()}|\{sy.get_first_month().to_string()}|\{sy.get_first_month().next(1).to_string()}",
        )
    }
  }
  let sy = SixtyCycleYear::from_year(2024).unwrap()
  for n = -2; n <= 2; n = n + 1 {
    println("SCY NEXT \{n} \{sy.next(n).get_name()}|\{sy.next(n).get_year()}")
  }
  // SCM 干支月
  for ym in [(2024, 0), (2024, 1), (2024, 6), (2024, 11), (2023, 12), (1900, 0)] {
    let (y0, m0) = ym
    match SixtyCycleMonth::from_index(y0, m0) {
      Err(e) => println("SCM \{y0} \{m0} ERRMSG \{e}")
      Ok(m) =>
        println(
          "SCM \{y0} \{m0} \{m.get_name()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_year().to_string()}|\{m.get_sixty_cycle().to_string()}|\{m.get_nine_star().get_name()}|\{m.get_jupiter_direction().to_string()}|\{m.get_days().length()}|\{m.get_first_day().to_string()}|\{m.next(1).to_string()}",
        )
    }
  }
  // SCD 干支日
  for
    ymd in [
      (2024, 1, 1),
      (2024, 2, 4),
      (2024, 2, 10),
      (2024, 12, 31),
      (2000, 1, 7),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("SCD \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let scd = sd.get_sixty_cycle_day()
        println(
          "SCD \{y0} \{m0} \{d0} \{scd.get_name()}|\{scd.to_string()}|\{scd.get_year().to_string()}|\{scd.get_month().to_string()}|\{scd.get_sixty_cycle().to_string()}|\{scd.get_duty().get_name()}|\{scd.get_twelve_star().get_name()}|\{scd.get_nine_star().get_name()}|\{scd.get_jupiter_direction().to_string()}|\{scd.get_twenty_eight_star().get_name()}|\{scd.get_hours().length()}|\{scd.get_fetus_day().to_string()}|\{scd.get_three_pillars().to_string()}",
        )
      }
    }
  }
  // SCD Next / Equals
  let bd = SolarDay::from_ymd(2024, 2, 10).unwrap()
  let bscd = bd.get_sixty_cycle_day()
  let nscd = bscd.next(1)
  println(
    "SCD NEXT \{nscd.to_string()}|\{nscd.equals(bscd)}|\{nscd.get_solar_day().to_string()}",
  )
  // SCH 干支时辰
  for
    hms in [
      (2024, 2, 10, 23, 0),
      (2024, 2, 11, 0, 0),
      (2024, 2, 11, 12, 30),
      (2024, 2, 4, 6, 0),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
      Err(_) => println("SCH \{y0} \{m0} \{d0} \{h0} \{mi0} ERR")
      Ok(st) => {
        let sch = st.get_sixty_cycle_hour()
        println(
          "SCH \{y0} \{m0} \{d0} \{h0} \{mi0} \{sch.get_name()}|\{sch.to_string()}|\{sch.get_index_in_day()}|\{sch.get_year().to_string()}|\{sch.get_month().to_string()}|\{sch.get_day().to_string()}|\{sch.get_sixty_cycle().to_string()}",
        )
      }
    }
  }
  // SCH Next / TwelveStar / NineStar / Recommends / Avoids
  let st0 = SolarTime::from_ymdhms(2024, 2, 10, 23, 0, 0).unwrap()
  let sch0 = st0.get_sixty_cycle_hour()
  let sch1 = sch0.next(7200)
  let rec = sch0.get_recommends()
  let avi = sch0.get_avoids()
  let rlen = match rec {
    Ok(v) => v.length()
    Err(_) => 0
  }
  let alen = match avi {
    Ok(v) => v.length()
    Err(_) => 0
  }
  println(
    "SCH EXTRA \{sch1.to_string()}|\{sch1.get_index_in_day()}|\{sch0.get_twelve_star().get_name()}|\{sch0.get_nine_star().get_name()}|\{rlen}|\{alen}",
  )
  // LHR 农历时辰
  for
    hms in [
      (2024, 1, 1, 0, 0),
      (2024, 1, 1, 23, 0),
      (2024, 2, 10, 12, 30),
      (2023, 12, 30, 6, 0),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match LunarHour::from_ymd_hms(y0, m0, d0, h0, mi0, 0) {
      Err(e) => println("LHR \{y0} \{m0} \{d0} \{h0} \{mi0} ERRMSG \{e}")
      Ok(lh) =>
        println(
          "LHR \{y0} \{m0} \{d0} \{h0} \{mi0} \{lh.get_name()}|\{lh.to_string()}|\{lh.get_index_in_day()}|\{lh.get_sixty_cycle().to_string()}|\{lh.get_twelve_star().get_name()}|\{lh.get_nine_star().get_name()}|\{lh.get_solar_time().to_string()}|\{lh.get_sixty_cycle_hour().to_string()}",
        )
    }
  }
  // LHR Next / MinorRen / IsBefore / IsAfter
  let lh0 = LunarHour::from_ymd_hms(2024, 1, 1, 0, 0, 0).unwrap()
  let lh1 = lh0.next(1)
  let lh2 = LunarHour::from_ymd_hms(2024, 1, 1, 2, 0, 0).unwrap()
  println(
    "LHR EXTRA \{lh1.to_string()}|\{lh1.get_index_in_day()}|\{lh0.get_minor_ren().get_name()}|\{lh0.is_before(lh2)}|\{lh0.is_after(lh2)}",
  )
  // FTD 胎神
  for ymd in [(2024, 1, 1), (2024, 2, 10), (2024, 6, 21)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("FTD \{y0} \{m0} \{d0} ERR")
      Ok(ld) => {
        let fd = ld.get_fetus_day()
        println(
          "FTD \{y0} \{m0} \{d0} \{fd.get_name()}|\{fd.to_string()}|\{fd.get_side().get_name()}|\{fd.get_direction().to_string()}|\{fd.get_fetus_heaven_stem().get_name()}|\{fd.get_fetus_earth_branch().get_name()}",
        )
      }
    }
  }
  // TPD ThreePillars.GetSolarDays
  let tp = ThreePillars::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
  )
  let ds = tp.get_solar_days(2024, 2034)
  for i = 0; i < ds.length(); i = i + 1 {
    println("TPD \{ds[i].to_string()}|\{ds[i].get_lunar_day().to_string()}")
  }
}

///|
test "xref_eight_char" {
  let sc = fn(name : String) -> SixtyCycle {
    SixtyCycle::from_name(name).unwrap()
  }
  let cases = [
    ("甲辰", "丙寅", "甲辰", "丙子"),
    ("甲辰", "丙寅", "戊戌", "乙卯"),
    ("癸卯", "乙丑", "戊戌", "乙卯"),
    ("癸丑", "癸亥", "戊寅", "丙午"),
  ]
  for c in cases {
    let (c0, c1, c2, c3) = c
    let ec = EightChar::from_sixty_cycle(sc(c0), sc(c1), sc(c2), sc(c3))
    println(
      "ECH \{c0} \{c1} \{c2} \{c3} \{ec.get_name()}|\{ec.to_string()}|\{ec.get_year().get_name()}|\{ec.get_month().get_name()}|\{ec.get_day().get_name()}|\{ec.get_hour().get_name()}|\{ec.get_fetal_origin().get_name()}|\{ec.get_fetal_breath().get_name()}|\{ec.get_own_sign().get_name()}|\{ec.get_body_sign().get_name()}|\{ec.get_duty().get_name()}|\{ec.equals(ec)}",
    )
  }
  // ECH New 名称版（非法时 ERRMSG）
  for
    c in [
      ("甲辰", "丙寅", "甲辰", "丙子"),
      ("甲辰", "丙寅", "甲辰", "坏名"),
    ] {
    let (c0, c1, c2, c3) = c
    match EightChar::new(c0, c1, c2, c3) {
      Err(e) => println("ECH NEW \{c0} \{c1} \{c2} \{c3} ERRMSG \{e}")
      Ok(ec) => println("ECH NEW \{c0} \{c1} \{c2} \{c3} \{ec.to_string()}")
    }
  }
  // ECS SolarTime→LunarHour→EightChar 委托（晚子时换日）
  for
    hms in [
      (2024, 2, 10, 22, 0),
      (2024, 2, 10, 23, 0),
      (2024, 2, 11, 0, 0),
      (2024, 2, 11, 12, 30),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
      Err(_) => println("ECS \{y0} \{m0} \{d0} \{h0} \{mi0} ERR")
      Ok(st) => {
        let ec = st.get_lunar_hour().get_eight_char()
        println(
          "ECS \{y0} \{m0} \{d0} \{h0} \{mi0} \{ec.to_string()}|\{ec.get_year().get_name()}|\{ec.get_month().get_name()}|\{ec.get_day().get_name()}|\{ec.get_hour().get_name()}",
        )
      }
    }
  }
  // CLM 童限（男/女 × 顺逆）
  for
    hms in [
      (2024, 2, 10, 12, 0),
      (2024, 1, 1, 0, 0),
      (1988, 6, 15, 23, 30),
      (2023, 12, 31, 6, 0),
    ] {
    for g in [Man, Woman] {
      let (y0, m0, d0, h0, mi0) = hms
      match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
        Err(_) =>
          println("CLM \{y0} \{m0} \{d0} \{h0} \{mi0} \{g.get_code()} ERR")
        Ok(st) => {
          let cl = ChildLimit::from_solar_time(st, g)
          println(
            "CLM \{y0} \{m0} \{d0} \{h0} \{mi0} \{g.get_code()} \{cl.get_eight_char().to_string()}|\{cl.get_gender().get_name()}|\{cl.is_forward()}|\{cl.get_year_count()}|\{cl.get_month_count()}|\{cl.get_day_count()}|\{cl.get_hour_count()}|\{cl.get_minute_count()}|\{cl.get_start_time().to_string()}|\{cl.get_end_time().to_string()}|\{cl.get_start_age()}|\{cl.get_end_age()}|\{cl.get_start_decade_fortune().to_string()}|\{cl.get_start_fortune().to_string()}|\{cl.get_end_sixty_cycle_year().to_string()}",
          )
        }
      }
    }
  }
  // FOR 小运
  let st0 = SolarTime::from_ymdhms(2024, 2, 10, 12, 0, 0).unwrap()
  let cl0 = ChildLimit::from_solar_time(st0, Man)
  let sf = cl0.get_start_fortune()
  for n = 0; n <= 3; n = n + 1 {
    let f = sf.next(n)
    println(
      "FOR \{n} \{f.get_age()}|\{f.get_sixty_cycle_year().to_string()}|\{f.get_sixty_cycle().get_name()}|\{f.get_name()}|\{f.to_string()}",
    )
  }
  // DCF 大运
  let sdf = cl0.get_start_decade_fortune()
  for n = 0; n <= 3; n = n + 1 {
    let df = sdf.next(n)
    println(
      "DCF \{n} \{df.get_start_age()}|\{df.get_end_age()}|\{df.get_start_sixty_cycle_year().to_string()}|\{df.get_end_sixty_cycle_year().to_string()}|\{df.get_sixty_cycle().get_name()}|\{df.get_start_fortune().to_string()}|\{df.to_string()}",
    )
  }
  // ECT EightChar.GetSolarTimes
  let ec2 = EightChar::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
    SixtyCycle::from_index(16),
  )
  let sts = ec2.get_solar_times(2024, 2034)
  let mut line = "ECT \{sts.length()}"
  for i = 0; i < sts.length(); i = i + 1 {
    line = line + "|" + sts[i].to_string()
  }
  println(line)
  // ECT2 晚子时八字
  let ec3 = EightChar::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
    SixtyCycle::from_index(0),
  )
  let sts3 = ec3.get_solar_times(2024, 2034)
  let mut line2 = "ECT2 \{sts3.length()}"
  for i = 0; i < sts3.length(); i = i + 1 {
    line2 = line2 + "|" + sts3[i].to_string()
  }
  println(line2)
}
