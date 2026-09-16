///|
fn legacy_rab_byung_leap_month(year : Int) -> Int {
  let mut n = 1
  let mut m = 4
  let mut t = 1
  while n < year {
    let i = m + 31 + t
    n = n + 2
    m = i - 23
    if i > 35 {
      n = n + 1
      m = m - 12
    }
    t = 1 - t
  }
  if n == year {
    m
  } else {
    0
  }
}

///|
test "rab_byung_leap_index_matches_legacy_for_every_constructible_year" {
  let index = build_rab_byung_leap_index()
  inspect(index.length(), content="9060")
  inspect(index[1027 - 1024], content="10")
  inspect(index[2043 - 1024], content="5")
  inspect(index[2044 - 1024], content="0")
  for year in 1024..<=10083 {
    if index[year - 1024] != legacy_rab_byung_leap_month(year) {
      fail("leap index differs from legacy for year \{year}")
    }
  }
}

///|
test "rab_byung_leap_public_query_matches_legacy_for_every_constructor" {
  let seen = Array::make(9060, false)
  for cycle in 0..<=150 {
    for element in 0..<5 {
      for zodiac in 0..<12 {
        let value = RabByungYear::new(cycle, element, zodiac).unwrap()
        let year = value.get_year()
        if seen[year - 1024] {
          fail("duplicate constructible year \{year}")
        }
        seen[year - 1024] = true
        if value.get_leap_month() != legacy_rab_byung_leap_month(year) {
          fail("public leap month differs from legacy for year \{year}")
        }
      }
    }
  }
  for year in 1024..<=10083 {
    if !seen[year - 1024] {
      fail("missing constructible year \{year}")
    }
  }
  for year in 1027..<=9999 {
    let value = RabByungYear::from_year(year).unwrap()
    if value.get_leap_month() != legacy_rab_byung_leap_month(year) {
      fail("validated year differs from legacy for year \{year}")
    }
  }
}
