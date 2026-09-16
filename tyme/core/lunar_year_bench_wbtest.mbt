///|
test (b : @bench.T) {
  let years = Array::makei(10001, fn(index) {
    LunarYear::from_year(index - 1).unwrap()
  })
  b.bench(name="get_leap_month_-1_to_9999", fn() {
    let mut checksum = 0
    for year in years {
      checksum = checksum + year.get_leap_month()
    }
    b.keep(checksum)
  })
}
