// 测试套件：SolarFestival（对应 Go test/SolarFestival_test.go，一比一翻译）

///|
test "solar_festival_0" {
  let d = match SolarFestival::from_index(2023, 0) {
    Some(v) => v
    None => abort("SolarFestival.FromIndex(2023,0) is None")
  }
  expect_eq(
    match d.next(13) {
      Some(v) => v.to_string()
      None => abort("SolarFestival.Next(13) is None")
    },
    "2024年5月1日 劳动节",
    "SolarFestival(2023,0).Next(13).String()",
  )
  expect_eq(
    match d.next(-3) {
      Some(v) => v.to_string()
      None => abort("SolarFestival.Next(-3) is None")
    },
    "2022年8月1日 建军节",
    "SolarFestival(2023,0).Next(-3).String()",
  )
}
