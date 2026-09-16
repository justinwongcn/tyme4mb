///|
fn reference_lunar_year_leap_groups() -> Array[Array[Int]] {
  let groups : Array[Array[Int]] = []
  for month_index = 0
      month_index < lunar_year_leap_data.length()
      month_index = month_index + 1 {
    let encoded = lunar_year_leap_data[month_index]
    let years : Array[Int] = []
    let mut year = 0
    for offset = 0; offset < encoded.length(); offset = offset + 2 {
      let high = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset).to_int(),
      )
      let low = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset + 1).to_int(),
      )
      year = year + high * 64 + low
      years.push(year)
    }
    groups.push(years)
  }
  groups
}

///|
fn reference_lunar_year_leap_month(
  year : Int,
  groups : Array[Array[Int]],
) -> Int {
  if year == -1 {
    return 11
  }
  for month_index = 0
      month_index < groups.length()
      month_index = month_index + 1 {
    let years = groups[month_index]
    for candidate in years {
      if candidate == year {
        return month_index + 1
      }
      if candidate > year {
        break
      }
    }
  }
  0
}

///|
test "lunar_year leap month matches grouped reference for full range" {
  let groups = reference_lunar_year_leap_groups()
  for year = -1; year <= 9999; year = year + 1 {
    let actual = LunarYear::from_year(year).unwrap().get_leap_month()
    let expected = reference_lunar_year_leap_month(year, groups)
    expect_eq(actual, expected, "leap month for year \{year}")
  }
}
