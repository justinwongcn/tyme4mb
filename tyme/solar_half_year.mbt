///|
// solar_half_year_names 公历半年名称
pub fn solar_half_year_names() -> Array[String] {
  ["上半年", "下半年"]
}

///|
// SolarHalfYear 公历半年
pub struct SolarHalfYear {
  // 年
  year : SolarYear
  // 索引，0-1
  index : Int
}

///|
extend SolarHalfYear with Culture::{get_name}

///|
// from_index 从年与索引构造
pub fn SolarHalfYear::from_index(
  year : Int,
  index : Int,
) -> Result[SolarHalfYear, String] {
  if index < 0 || index > 1 {
    return Err("illegal solar half year index: " + index.to_string())
  }
  match SolarYear::from_year(year) {
    Err(e) => Err(e)
    Ok(y) => Ok({ year: y, index })
  }
}

///|
// get_solar_year 公历年
pub fn SolarHalfYear::get_solar_year(self : SolarHalfYear) -> SolarYear {
  self.year
}

///|
// get_year 年
pub fn SolarHalfYear::get_year(self : SolarHalfYear) -> Int {
  self.year.get_year()
}

///|
// get_index 索引，0-1
pub fn SolarHalfYear::get_index(self : SolarHalfYear) -> Int {
  self.index
}

///|
// get_months 月份列表，半年有6个月。
pub fn SolarHalfYear::get_months(self : SolarHalfYear) -> Array[SolarMonth] {
  let l : Array[SolarMonth] = []
  let y = self.get_year()
  for i = 1; i < 7; i = i + 1 {
    l.push(SolarMonth::from_ym(y, self.index * 6 + i).unwrap())
  }
  l
}

///|
// get_seasons 季度列表，半年有2个季度。
pub fn SolarHalfYear::get_seasons(self : SolarHalfYear) -> Array[SolarSeason] {
  let l : Array[SolarSeason] = []
  let y = self.get_year()
  for i = 0; i < 2; i = i + 1 {
    l.push(SolarSeason::from_index(y, self.index * 2 + i).unwrap())
  }
  l
}

///|
pub impl Culture for SolarHalfYear with fn get_name(self : SolarHalfYear) -> String {
  solar_half_year_names()[self.index]
}

///|
pub impl Show for SolarHalfYear with fn to_string(self : SolarHalfYear) -> String {
  self.year.to_string() + self.get_name()
}

///|
pub impl Tyme for SolarHalfYear with fn next(self : SolarHalfYear, n : Int) -> SolarHalfYear {
  let i = self.index + n
  SolarHalfYear::from_index(
    (self.get_year() * 2 + i) / 2,
    AbstractCulture::index_of(i, 2),
  ).unwrap()
}
