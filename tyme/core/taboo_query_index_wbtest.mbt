///|
test "build_taboo_query_index_preserves_empty_and_nonempty_fields" {
  let index = build_taboo_query_index(["0001,;02,0304"])
  inspect(index[0][0].0, content="Ok([0, 1])")
  inspect(index[0][0].1, content="Ok([])")
  inspect(index[0][1].0, content="Ok([2])")
  inspect(index[0][1].1, content="Ok([3, 4])")
}

///|
test "build_taboo_query_index_ignores_trailing_record_separator" {
  let index = build_taboo_query_index(["0001,;02,0304;"])
  inspect(index[0].length(), content="2")
}

///|
fn taboo_case(
  month_index : Int,
  day_index : Int,
) -> (SixtyCycleMonth, SixtyCycleDay) {
  let month = SixtyCycleMonth::new(
    SixtyCycleYear::from_year(2024).unwrap(),
    SixtyCycle::from_index(month_index),
  )
  let day = SixtyCycleDay::new(
    SolarDay::from_ymd(2024, 1, 1).unwrap(),
    month,
    SixtyCycle::from_index(day_index),
  )
  (month, day)
}

///|
test "taboo_query_returns_independent_arrays" {
  let (month, day) = taboo_case(0, 0)
  let taboos1 = Taboo::get_day_recommends(month, day).unwrap()
  let taboo_count = taboos1.length()
  taboos1.push(Taboo::from_index(0))
  inspect(
    Taboo::get_day_recommends(month, day).unwrap().length() == taboo_count,
    content="true",
  )
}

///|
test "taboo_query_preserves_empty_result" {
  let (month, day) = taboo_case(1, 21)
  inspect(Taboo::get_day_avoids(month, day).unwrap(), content="[]")
}

///|
test "taboo_query_covers_last_day_index" {
  let (month, day) = taboo_case(11, 59)
  let _ = Taboo::get_day_recommends(month, day).unwrap()
}
