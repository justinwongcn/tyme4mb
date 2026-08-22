///|
test "xref_downstream" {
  // LWK 农历周
  for start in [0, 1] {
    for i = 0; i < 4; i = i + 1 {
      match LunarWeek::from_ym(2024, 1, i, start) {
        Err(e) => println("LWK 2024 1 \{i} \{start} ERRMSG \{e}")
        Ok(w) =>
          println(
            "LWK 2024 1 \{i} \{start} \{w.get_name()}|\{w.to_string()}|\{w.get_first_day().to_string()}|\{w.get_days().length()}|\{w.get_lunar_month().get_month_with_leap()}",
          )
      }
    }
  }
  let w0 = LunarWeek::from_ym(2024, 1, 0, 1).unwrap()
  let w1 = LunarWeek::from_ym(2024, 1, 1, 1).unwrap()
  let wm1 = w0.next(-1)
  let wn1 = w0.next(1)
  println(
    "LWK NEXT -1 \{wm1.to_string()}|\{wm1.equals(w0)}|\{wm1.equals(w0.next(0))}",
  )
  println("LWK NEXT 1 \{wn1.to_string()}|\{wn1.equals(w1)}")
  match LunarWeek::from_ym(2024, 1, 6, 1) {
    Err(e) => println("LWK ERR \{e}")
    Ok(_) => println("LWK ERR <nil>")
  }
  // LFT 农历节日 FromIndex
  for i = 0; i < 13; i = i + 1 {
    match LunarFestival::from_index(2024, i) {
      None => println("LFT 2024 \{i} NIL")
      Some(f) => {
        let ts = match f.get_solar_term() {
          Some(st) => st.get_name()
          None => "nil"
        }
        println(
          "LFT 2024 \{i} \{f.to_string()}|\{f.get_day().to_string()}|\{ts}",
        )
      }
    }
  }
  // LFT FromYmd
  for
    ymd in [
      (2024, 1, 1),
      (2024, 2, 10),
      (2024, 6, 10),
      (2024, 4, 4),
      (2024, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match LunarFestival::from_ymd(y0, m0, d0) {
      None => println("LFT YMD \{y0} \{m0} \{d0} NIL")
      Some(f) => println("LFT YMD \{y0} \{m0} \{d0} \{f.to_string()}")
    }
  }
  // LFT Next
  match LunarFestival::from_index(2024, 0) {
    None => ()
    Some(f0) =>
      for n = -1; n <= 1; n = n + 1 {
        match f0.next(n) {
          None => println("LFT NEXT \{n} NIL")
          Some(fnx) => println("LFT NEXT \{n} \{fnx.to_string()}")
        }
      }
  }
  // FTM 逐月胎神
  for i = 0; i < 12; i = i + 1 {
    let f = FetusMonth::new(i)
    println("FTM \{i} \{f.get_name()}|\{f.to_string()}|\{f.next(1).get_name()}")
  }
  let lm = LunarMonth::from_ym(2024, 1).unwrap()
  match FetusMonth::from_lunar_month(lm) {
    Some(fm) =>
      println("FTM LM \{fm.get_name()}|\{fm.next(2).get_name() == "占厨灶"}")
    None => ()
  }
  let lml = LunarMonth::from_ym(2023, -2).unwrap()
  match FetusMonth::from_lunar_month(lml) {
    Some(f) => println("FTM LEAP \{f.to_string()}")
    None => println("FTM LEAP <nil>")
  }
  // PHS 月相
  for i = 0; i < 8; i = i + 1 {
    let p = Phase::from_index(2024, 1, i)
    println(
      "PHS \{i} \{p.get_name()}|\{p.to_string()}|\{p.get_solar_day().to_string()}|\{p.get_solar_time().to_string()}",
    )
  }
  match Phase::from_name(2024, 1, "满月") {
    Err(e) => println("PHS NAME ERR \{e}")
    Ok(pn) => println("PHS NAME \{pn.get_name()}|\{pn.next(1).get_name()}")
  }
  // PHD 月相第几天
  let pd = PhaseDay::new(Phase::from_index(2024, 1, 1), 3)
  println(
    "PHD \{pd.get_phase().get_name()}|\{pd.to_string()}|\{pd.get_day_index()}|\{pd.get_name()}",
  )
  // KGS 灶马头
  for y in [2023, 2024, 2025, 1988, 2033] {
    let k = KitchenGodSteed::from_lunar_year(y)
    println(
      "KGS \{y} \{k.get_name()}|\{k.get_mouse()}|\{k.get_grass()}|\{k.get_cattle()}|\{k.get_flower()}|\{k.get_dragon()}|\{k.get_horse()}|\{k.get_chicken()}|\{k.get_silkworm()}|\{k.get_pig()}|\{k.get_field()}|\{k.get_cake()}|\{k.get_gold()}|\{k.get_people_cakes()}|\{k.get_people_hoes()}",
    )
  }
  // SFT 公历节日
  for i = 0; i < 10; i = i + 1 {
    match SolarFestival::from_index(2024, i) {
      None => println("SFT 2024 \{i} NIL")
      Some(f) =>
        println(
          "SFT 2024 \{i} \{f.to_string()}|\{f.get_day().to_string()}|\{f.get_start_year()}",
        )
    }
  }
  for ymd in [(2024, 10, 1), (2024, 1, 1), (2024, 6, 1), (2023, 5, 1)] {
    let (y0, m0, d0) = ymd
    match SolarFestival::from_ymd(y0, m0, d0) {
      None => println("SFT YMD \{y0} \{m0} \{d0} NIL")
      Some(f) => println("SFT YMD \{y0} \{m0} \{d0} \{f.to_string()}")
    }
  }
  match SolarFestival::from_index(2024, 0) {
    None => ()
    Some(sf0) =>
      match sf0.next(1) {
        Some(nx) => println("SFT NEXT \{nx.to_string()}")
        None => ()
      }
  }
  // EVT 事件构造与解析
  let ev1 = Event::builder()
    .term_heaven_stem(12, 6, 20)
    .start_year(2024)
    .build()
    .unwrap()
  let ev2 = Event::builder()
    .term_earth_branch(13, 7, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev3 = Event::builder()
    .solar_day(10, 1, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev4 = Event::builder()
    .lunar_day(1, 1, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev5 = Event::builder()
    .solar_week(5, 1, 1)
    .start_year(2024)
    .build()
    .unwrap()
  for ev in [ev1, ev2, ev3, ev4, ev5] {
    let ts = match ev.get_solar_day(2024) {
      Some(sd) => sd.to_string()
      None => "nil"
    }
    let m = ev.get_month(2024)
    println(
      "EVT \{ev.get_name()}|\{ev.get_data()}|\{ev.get_value(2)}|\{ev.get_value(3)}|\{ev.get_value(4)}|\{ev.get_value(5)}|\{ev.get_type().get_code()}|\{ev.get_start_year()}|\{m.0}|\{ts}",
    )
  }
  // EVT 非法数据
  match Event::new("测试", "abc") {
    Err(e) => println("EVT ERR \{e}")
    Ok(_) => println("EVT ERR <nil>")
  }
  // EVD solar_day 委托
  for
    ymd in [
      (2024, 7, 15),
      (2024, 8, 10),
      (2024, 10, 1),
      (2024, 2, 10),
      (2024, 6, 10),
      (2024, 4, 4),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => ()
      Ok(sd) => {
        let ddt = match sd.get_dog_day() {
          Some(dd) => dd.to_string()
          None => "nil"
        }
        let prt = match sd.get_plum_rain_day() {
          Some(pr) => pr.to_string()
          None => "nil"
        }
        let ftt = match sd.get_festival() {
          Some(ft) => ft.to_string()
          None => "nil"
        }
        println(
          "EVD \{y0} \{m0} \{d0} \{ddt}|\{prt}|\{ftt}|\{sd.get_phase_day().to_string()}|\{sd.get_phase().get_name()}|\{sd.get_phase_day().get_day_index()}",
        )
      }
    }
  }
  // LDD lunar_day 委托
  for ymd in [(2024, 1, 1), (2024, 6, 5), (2024, 6, 10), (2024, 12, 30)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("LDD \{y0} \{m0} \{d0} ERR \{e}")
      Ok(ld) => {
        let ftt = match ld.get_festival() {
          Some(ft) => ft.to_string()
          None => "nil"
        }
        println(
          "LDD \{y0} \{m0} \{d0} \{ftt}|\{ld.get_phase_day().to_string()}|\{ld.get_phase().get_name()}|\{ld.get_phase_day().get_day_index()}",
        )
      }
    }
  }
  // LMF lunar_month 委托
  let lm2 = LunarMonth::from_ym(2024, 6).unwrap()
  println("LMF FETUS \{lm2.get_fetus().unwrap().get_name()}")
  for start in [1, 0] {
    let ws = lm2.get_weeks(start)
    let mut line = "LMF WEEKS \{start} \{ws.length()}"
    for i = 0; i < ws.length(); i = i + 1 {
      line = line + "|" + ws[i].to_string()
    }
    println(line)
  }
  // LYK lunar_year 委托
  for y in [2024, 2023] {
    let ly = LunarYear::from_year(y).unwrap()
    println(
      "LYK \{y} \{ly.get_kitchen_god_steed().get_name()}|\{ly.get_kitchen_god_steed().get_mouse()}",
    )
  }
}
