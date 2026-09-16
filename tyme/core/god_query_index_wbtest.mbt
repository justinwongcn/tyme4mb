///|
test "build_god_query_index_preserves_record_order" {
  let index = build_god_query_index([";000102;013C"])
  debug_inspect(index[0][0], content="Ok([1, 2])")
  debug_inspect(index[0][1], content="Ok([60])")
}

///|
fn god_taboo_case(
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
test "god_query_returns_independent_arrays" {
  let (month, day) = god_taboo_case(0, 0)
  let gods1 = God::get_day_gods(month, day).unwrap()
  let god_count = gods1.length()
  gods1.push(God::from_index(0))
  inspect(
    God::get_day_gods(month, day).unwrap().length() == god_count,
    content="true",
  )
}

///|
test "god_query_covers_last_day_index" {
  let (month, day) = god_taboo_case(11, 59)
  let _ = God::get_day_gods(month, day).unwrap()
}
