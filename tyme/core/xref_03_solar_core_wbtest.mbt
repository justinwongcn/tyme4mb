///|
test "xref_solar_day_ymd" {
  let cases = [
    (2000, 1, 1),
    (2024, 2, 29),
    (2023, 2, 29),
    (2023, 2, 28),
    (1582, 10, 4),
    (1582, 10, 5),
    (1582, 10, 14),
    (1582, 10, 15),
    (1582, 10, 31),
    (2100, 12, 31),
    (1900, 2, 28),
    (1900, 2, 29),
    (2024, 13, 1),
    (2024, 0, 1),
    (2024, 5, 0),
    (2024, 4, 31),
    (1, 1, 1),
    (9999, 12, 31),
  ]
  for c in cases {
    let (y0, m0, d0) = c
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("SDA \{y0} \{m0} \{d0} ERR \{e}")
      Ok(o) => {
        println("SDA \{y0} \{m0} \{d0} \{o.get_name()}|\{o.to_string()}")
        println(
          "SDB \{y0} \{m0} \{d0} \{o.get_solar_month().to_string()}|\{o.get_solar_month().get_day_count()}",
        )
        println("SDX \{y0} \{m0} \{d0} \{o.get_index_in_year()}")
        println(
          "SDW \{y0} \{m0} \{d0} \{o.get_week().get_name()}|\{o.get_week().get_index()}",
        )
        println("SDC \{y0} \{m0} \{d0} \{o.get_constellation().get_name()}")
        match SolarDay::from_ymd(y0, m0, d0) {
          Ok(s) => println("SDE \{y0} \{m0} \{d0} \{o.equals(s)}")
          Err(_) => ()
        }
      }
    }
  }
  // SolarMonth 依赖 SolarDay.FromYmd 的方法
  let mcases = [
    (2024, 2, 0),
    (2023, 2, 0),
    (1582, 10, 0),
    (2000, 1, 0),
    (2100, 12, 0),
  ]
  for c in mcases {
    let (y0, m0, _d0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => println("SMW \{y0} \{m0} ERR")
      Ok(m) => {
        for start = 0; start <= 6; start = start + 1 {
          println("SMW \{y0} \{m0} \{start} \{m.get_week_count(start)}")
        }
        if y0 == 1582 && m0 == 10 {
          // 排除 1582-10：上游 Go 的 GetDays 在该月会 nil 解引用 panic
        } else {
          let days = m.get_days()
          println(
            "SMD \{y0} \{m0} \{days.length()}|\{days[0].to_string()}|\{days[days.length() - 1].to_string()}",
          )
          println("SMF \{y0} \{m0} \{m.get_first_day().to_string()}")
        }
      }
    }
  }
  // PhenologyDay
  for y in [2000, 2024, 1900] {
    for idx in [0, 1, 71] {
      let p = Phenology::from_index(y, idx)
      for d in [0, 2, 4] {
        let o = PhenologyDay::new(p, d)
        println(
          "PDY \{y} \{idx} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_phenology().get_name()}|\{o.get_day_index()}",
        )
      }
    }
  }
}

///|
test "xref_scc_closure" {
  let dates = [
    (2024, 2, 28),
    (2023, 12, 31),
    (1582, 10, 4),
    (1582, 10, 15),
    (2000, 1, 1),
    (1900, 3, 1),
    (2100, 12, 31),
  ]
  let offsets = [-400, -31, -1, 0, 1, 31, 400]
  let hms = [(0, 0, 0), (12, 30, 45), (23, 59, 59)]
  // SolarDay.Next（SCC 核心）
  for c in dates {
    let (y0, m0, d0) = c
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("SCN \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        for n in offsets {
          println("SCN \{y0} \{m0} \{d0} \{n} \{sd.next(n).to_string()}")
        }
    }
  }
  // JulianDay.GetSolarDay / GetSolarTime
  for c in dates {
    let (y0, m0, d0) = c
    for h in hms {
      let (h0, mi0, s0) = h
      let jd = JulianDay::from_ymdhms(y0, m0, d0, h0, mi0, s0)
      println(
        "SCJ \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{jd.get_solar_day().unwrap().to_string()}|\{jd.get_solar_time().unwrap().to_string()}",
      )
    }
  }
  // SolarTime.GetSolarDay / String / Next
  for c in dates {
    let (y0, m0, d0) = c
    for h in hms {
      let (h0, mi0, s0) = h
      match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, s0) {
        Err(_) => println("SCT \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} ERR")
        Ok(st) => {
          println(
            "SCT \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{st.to_string()}|\{st.get_name()}|\{st.get_solar_day().to_string()}",
          )
          for n in [-86401, -3600, -1, 0, 1, 3600, 86401] {
            println(
              "SCX \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{n} \{st.next(n).to_string()}",
            )
          }
        }
      }
    }
  }
  // SolarTime.Subtract
  let base = SolarTime::from_ymdhms(2000, 1, 1, 0, 0, 0).unwrap()
  for c in dates {
    let (y0, m0, d0) = c
    match SolarTime::from_ymdhms(y0, m0, d0, 12, 0, 0) {
      Err(_) => ()
      Ok(st) => println("SCB \{y0} \{m0} \{d0} \{st.subtract(base)}")
    }
  }
}

///|
test "xref_term_phenology" {
  // SolarTerm.GetSolarDay
  for y in [1900, 1950, 2000, 2024, 2100] {
    for i = 0; i < 24; i = i + 1 {
      let st = SolarTerm::from_index(y, i)
      println(
        "SGD \{y} \{i} \{st.get_name()}|\{st.get_solar_day().to_string()}",
      )
    }
  }
  // SolarDay 系列
  let dates : Array[SolarDay] = []
  for y in [2023, 2024] {
    for m = 1; m < 13; m = m + 1 {
      for d in [1, 5, 10, 15, 20, 25] {
        match SolarDay::from_ymd(y, m, d) {
          Ok(sd) => dates.push(sd)
          Err(_) => ()
        }
      }
    }
  }
  for sd in dates {
    let td = sd.get_term_day()
    println(
      "SDT \{sd.to_string()} \{sd.get_term().to_string()}|\{td.to_string()}|\{td.get_day_index()}",
    )
    let pd = sd.get_phenology_day()
    println(
      "SDP \{sd.to_string()} \{sd.get_phenology().to_string()}|\{pd.to_string()}|\{pd.get_day_index()}",
    )
    match sd.get_nine_day() {
      None => println("SDN \{sd.to_string()} nil")
      Some(nd) =>
        println("SDN \{sd.to_string()} \{nd.to_string()}|\{nd.get_day_index()}")
    }
    let hd = sd.get_hide_heaven_stem_day()
    println(
      "SDH \{sd.to_string()} \{hd.to_string()}|\{hd.get_hide_heaven_stem().to_string()}|\{hd.get_day_index()}",
    )
  }
  // SolarTime.GetTerm / GetPhenology
  for y in [2023, 2024] {
    for m = 1; m < 13; m = m + 1 {
      for hms in [(1, 0, 0, 0), (15, 12, 30, 45), (28, 23, 59, 59)] {
        let (d0, h0, mi0, s0) = hms
        match SolarTime::from_ymdhms(y, m, d0, h0, mi0, s0) {
          Err(_) => ()
          Ok(st) =>
            println(
              "STP \{st.to_string()} \{st.get_term().to_string()}|\{st.get_phenology().to_string()}",
            )
        }
      }
    }
  }
  // SolarYear.GetMonths
  for y in [1582, 1900, 2000, 2024, 2100] {
    match SolarYear::from_year(y) {
      Err(_) => println("SYM \{y} ERR")
      Ok(sy) => {
        let mut s = ""
        for mm in sy.get_months() {
          s = s + mm.to_string() + ","
        }
        println("SYM \{y} \{s}")
      }
    }
  }
}
