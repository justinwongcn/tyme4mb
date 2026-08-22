///|
test "xref_three_pillars" {
  let names = [
    ("甲子", "乙丑", "丙寅"),
    ("癸亥", "壬戌", "辛酉"),
    ("甲子", "甲子", "甲子"),
    ("丁卯", "戊辰", "己巳"),
    ("庚午", "辛未", "壬申"),
    ("错误", "乙丑", "丙寅"),
    ("甲子", "错误", "丙寅"),
    ("甲子", "乙丑", "错误"),
  ]
  for c in names {
    let (y0, m0, d0) = c
    match ThreePillars::new(y0, m0, d0) {
      Err(e) => println("TPL \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(tp) =>
        println(
          "TPL \{y0} \{m0} \{d0} \{tp.get_name()}|\{tp.to_string()}|\{tp.get_year().to_string()}|\{tp.get_month().to_string()}|\{tp.get_day().to_string()}",
        )
    }
  }
  for i = 0; i < 60; i = i + 7 {
    let y = SixtyCycle::from_index(i)
    let m = SixtyCycle::from_index((i + 13) % 60)
    let d = SixtyCycle::from_index((i + 29) % 60)
    let tp = ThreePillars::from_sixty_cycle(y, m, d)
    let same = ThreePillars::from_sixty_cycle(y, m, d)
    let diff = ThreePillars::from_sixty_cycle(m, y, d)
    println(
      "TPS \{i} \{tp.get_name()}|\{tp.to_string()}|\{tp.get_year().get_index()}|\{tp.get_month().get_index()}|\{tp.get_day().get_index()}|\{tp.equals(same)}|\{tp.equals(diff)}",
    )
  }
  for i = 0; i < 60; i = i + 11 {
    let y = SixtyCycle::from_index(i)
    let m = SixtyCycle::from_index((i + 5) % 60)
    let d = SixtyCycle::from_index((i + 41) % 60)
    let a = ThreePillars::from_sixty_cycle(y, m, d)
    match ThreePillars::new(y.get_name(), m.get_name(), d.get_name()) {
      Err(_) => println("TPE \{i} ERR")
      Ok(b) => println("TPE \{i} \{a.get_name()}|\{a.equals(b)}")
    }
  }
}
