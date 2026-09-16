///|
test (b : @bench.T) {
  let early = RabByungYear::from_year(1027).unwrap()
  let typical = RabByungYear::from_year(2024).unwrap()
  let late = RabByungYear::from_year(9999).unwrap()
  b.bench(name="rab_byung_leap_1027_x100", fn() {
    let mut checksum = 0
    for _ in 0..<100 {
      checksum = checksum + early.get_leap_month()
    }
    b.keep(checksum)
  })
  b.bench(name="rab_byung_leap_2024_x100", fn() {
    let mut checksum = 0
    for _ in 0..<100 {
      checksum = checksum + typical.get_leap_month()
    }
    b.keep(checksum)
  })
  b.bench(name="rab_byung_leap_9999_x100", fn() {
    let mut checksum = 0
    for _ in 0..<100 {
      checksum = checksum + late.get_leap_month()
    }
    b.keep(checksum)
  })
  b.bench(name="rab_byung_months_2024_x20", fn() {
    let mut checksum = 0
    for _ in 0..<20 {
      checksum = checksum + typical.get_months().length()
    }
    b.keep(checksum)
  })
}
