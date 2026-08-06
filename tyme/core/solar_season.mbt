///|
// solar_season_names 公历季度名称
pub fn solar_season_names() -> Array[String] {
  ["一季度", "二季度", "三季度", "四季度"]
}

///|
// SolarSeason 公历季度
pub struct SolarSeason {
  // 公历年
  year : SolarYear
  // 索引，0-3
  index : Int
}

///|
extend SolarSeason with Culture::{get_name}

///|
// from_index 从年与索引构造
pub fn SolarSeason::from_index(
  year : Int,
  index : Int,
) -> Result[SolarSeason, String] {
  if index < 0 || index > 3 {
    return Err("illegal solar season index: " + index.to_string())
  }
  match SolarYear::from_year(year) {
    Err(e) => Err(e)
    Ok(y) => Ok({ year: y, index })
  }
}

///|
// get_solar_year 公历年
pub fn SolarSeason::get_solar_year(self : SolarSeason) -> SolarYear {
  self.year
}

///|
// get_year 年
pub fn SolarSeason::get_year(self : SolarSeason) -> Int {
  self.year.get_year()
}

///|
// get_index 索引，0-3
pub fn SolarSeason::get_index(self : SolarSeason) -> Int {
  self.index
}

///|
// get_months 月份列表，1季度有3个月。
pub fn SolarSeason::get_months(self : SolarSeason) -> Array[SolarMonth] {
  let l : Array[SolarMonth] = []
  let y = self.get_year()
  for i = 1; i < 4; i = i + 1 {
    l.push(SolarMonth::from_ym(y, self.index * 3 + i).unwrap())
  }
  l
}

///|
pub impl Culture for SolarSeason with fn get_name(self : SolarSeason) -> String {
  solar_season_names()[self.index]
}

///|
pub impl Show for SolarSeason with fn to_string(self : SolarSeason) -> String {
  self.year.to_string() + self.get_name()
}

///|
pub impl Tyme for SolarSeason with fn next(self : SolarSeason, n : Int) -> SolarSeason {
  let i = self.index + n
  SolarSeason::from_index(
    (self.get_year() * 4 + i) / 4,
    AbstractCulture::index_of(i, 4),
  ).unwrap()
}
