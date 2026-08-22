///|
test "xref_child_limit" {
  let cases = [
    (2000, 1, 1, 0, 0, 0, 2010, 5, 20, 8, 30, 0, 10, 4, 19, 8, 30),
    (1988, 8, 8, 12, 0, 0, 1989, 9, 9, 9, 9, 9, 1, 1, 1, 1, 1),
  ]
  for c in cases {
    let (sy, sm, sd, sh, smi, ss, ey, em, ed, eh, emi, es, yc, mc, dc, hc, minc) = c
    match SolarTime::from_ymdhms(sy, sm, sd, sh, smi, ss) {
      Err(_) =>
        println(
          "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} ERR",
        )
      Ok(st1) =>
        match SolarTime::from_ymdhms(ey, em, ed, eh, emi, es) {
          Err(_) =>
            println(
              "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} ERR",
            )
          Ok(st2) => {
            let cli = ChildLimitInfo::new(st1, st2, yc, mc, dc, hc, minc)
            println(
              "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} \{cli.get_start_time().to_string()}|\{cli.get_end_time().to_string()}|\{cli.get_year_count()}|\{cli.get_month_count()}|\{cli.get_day_count()}|\{cli.get_hour_count()}|\{cli.get_minute_count()}",
            )
          }
        }
    }
  }
}
