///|
test (b : @bench.T) {
  let cases : Array[(SixtyCycleMonth, SixtyCycleDay, SixtyCycle)] = []
  for m = 0; m < 12; m = m + 1 {
    let month = SixtyCycleMonth::new(
      SixtyCycleYear::from_year(2024).unwrap(),
      SixtyCycle::from_index(m),
    )
    for d = 0; d < 60; d = d + 1 {
      let day = SixtyCycleDay::new(
        SolarDay::from_ymd(2024, 1, 1).unwrap(),
        month,
        SixtyCycle::from_index(d),
      )
      cases.push((month, day, SixtyCycle::from_index(m)))
    }
  }
  b.bench(name="god_taboo_12x60_queries", fn() {
    let mut checksum = 0
    for item in cases {
      checksum = checksum + God::get_day_gods(item.0, item.1).unwrap().length()
      checksum = checksum +
        Taboo::get_day_recommends(item.0, item.1).unwrap().length()
      checksum = checksum +
        Taboo::get_day_avoids(item.0, item.1).unwrap().length()
      checksum = checksum +
        Taboo::get_hour_recommends(item.1.get_sixty_cycle(), item.2)
        .unwrap()
        .length()
      checksum = checksum +
        Taboo::get_hour_avoids(item.1.get_sixty_cycle(), item.2)
        .unwrap()
        .length()
    }
    b.keep(checksum)
  })
}
