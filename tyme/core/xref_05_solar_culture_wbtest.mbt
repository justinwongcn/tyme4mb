///|
test "xref_solar_week" {
  let cases = [
    (2024, 1, 1),
    (2024, 2, 1),
    (2024, 12, 0),
    (2023, 7, 6),
    (2000, 1, 0),
    (2100, 12, 1),
    (1900, 2, 1),
  ]
  for c in cases {
    let (y0, m0, start0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => ()
      Ok(wc) => {
        let size = wc.get_week_count(start0)
        for idx = 0; idx < size; idx = idx + 1 {
          match SolarWeek::from_ym(y0, m0, idx, start0) {
            Err(_) => ()
            Ok(w) => {
              let nd = w.next(1)
              println(
                "SWK \{y0} \{m0} \{idx} \{start0} \{w.get_name()}|\{w.to_string()}|\{w.get_first_day().to_string()}|\{w.get_days().length()}|\{w.get_index_in_year()}|\{nd.get_first_day().to_string()}|\{nd.get_name()}",
              )
            }
          }
        }
      }
    }
  }
  let dcases = [
    (2024, 1, 1, 1),
    (2024, 1, 15, 1),
    (2024, 2, 29, 0),
    (2023, 12, 31, 6),
  ]
  for d in dcases {
    let (y0, m0, d0, s0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => ()
      Ok(sd) =>
        match sd.get_solar_week(s0) {
          Err(_) => ()
          Ok(sw) =>
            println(
              "SWD \{y0} \{m0} \{d0} \{s0} \{sw.to_string()}|\{sw.get_index()}",
            )
        }
    }
  }
  for c in cases {
    let (y0, m0, start0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => ()
      Ok(wc) =>
        println("SWM \{y0} \{m0} \{start0} \{wc.get_weeks(start0).length()}")
    }
  }
}

///|
test "xref_solar_season" {
  let years = [1, 1582, 1583, 1900, 2023, 2024, 2100, 9999]
  let safe = [1583, 1900, 2023, 2024, 2100]
  for y in years {
    for idx = 0; idx < 4; idx = idx + 1 {
      match SolarSeason::from_index(y, idx) {
        Err(_) => println("SSM \{y} \{idx} ERR")
        Ok(s) => {
          let mut mstr = ""
          for m in s.get_months() {
            mstr = mstr + m.to_string() + ","
          }
          println(
            "SSM \{y} \{idx} \{s.get_name()}|\{s.to_string()}|\{s.get_year()}|\{s.get_index()}|\{s.get_solar_year().to_string()}|\{mstr}",
          )
        }
      }
    }
  }
  for y in safe {
    for idx = 0; idx < 4; idx = idx + 1 {
      match SolarSeason::from_index(y, idx) {
        Err(_) => ()
        Ok(s) =>
          for n in [-9, -4, -1, 0, 1, 4, 7] {
            println("SSM \{y} \{idx} N \{n} \{s.next(n).to_string()}")
          }
      }
    }
  }
  for b in [(2024, -1), (2024, 4), (0, 0), (10000, 0)] {
    let (y0, i0) = b
    match SolarSeason::from_index(y0, i0) {
      Err(e) => println("SSM \{y0} \{i0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  for y in years {
    for idx = 0; idx < 2; idx = idx + 1 {
      match SolarHalfYear::from_index(y, idx) {
        Err(_) => println("SHY \{y} \{idx} ERR")
        Ok(h) => {
          let mut mstr = ""
          for m in h.get_months() {
            mstr = mstr + m.to_string() + ","
          }
          let mut sstr = ""
          for s in h.get_seasons() {
            sstr = sstr + s.to_string() + ","
          }
          println(
            "SHY \{y} \{idx} \{h.get_name()}|\{h.to_string()}|\{h.get_year()}|\{h.get_index()}|\{h.get_solar_year().to_string()}|\{mstr}|\{sstr}",
          )
        }
      }
    }
  }
  for y in safe {
    for idx = 0; idx < 2; idx = idx + 1 {
      match SolarHalfYear::from_index(y, idx) {
        Err(_) => ()
        Ok(h) =>
          for n in [-5, -2, -1, 0, 1, 2, 3] {
            println("SHY \{y} \{idx} N \{n} \{h.next(n).to_string()}")
          }
      }
    }
  }
  for b in [(2024, -1), (2024, 2), (0, 0), (10000, 1)] {
    let (y0, i0) = b
    match SolarHalfYear::from_index(y0, i0) {
      Err(e) => println("SHY \{y0} \{i0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  for y in years {
    match SolarYear::from_year(y) {
      Err(_) => ()
      Ok(sy) => {
        let mut i = 0
        for s in sy.get_seasons() {
          println("SYS \{y} \{i} \{s.to_string()}")
          i = i + 1
        }
        let mut j = 0
        for h in sy.get_half_years() {
          println("SYH \{y} \{j} \{h.to_string()}")
          j = j + 1
        }
      }
    }
  }
}
