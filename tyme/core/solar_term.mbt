///|
// solar_term_names 节气名称
pub fn solar_term_names() -> Array[String] {
  [
    "冬至", "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明",
    "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋",
    "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪",
  ]
}

///|
// SolarTerm 节气
pub struct SolarTerm {
  loop_tyme : LoopTyme
  year : Int
  cursory_julian_day : Double
}

///|
pub extend SolarTerm with Tyme::{next}

///|
pub fn SolarTerm::from_index(year : Int, index : Int) -> SolarTerm {
  let parent = LoopTyme::from_index(solar_term_names(), index)
  let size = parent.get_size()
  let y = (year * size + index) / size
  let cursory = init_by_year(y, parent.get_index())
  { loop_tyme: parent, year: y, cursory_julian_day: cursory }
}

///|
pub fn SolarTerm::from_name(
  year : Int,
  name : String,
) -> Result[SolarTerm, String] {
  match LoopTyme::from_name(solar_term_names(), name) {
    Ok(p) => {
      let cursory = init_by_year(year, p.get_index())
      Ok({ loop_tyme: p, year, cursory_julian_day: cursory })
    }
    Err(e) => Err(e)
  }
}

///|
fn init_by_year(year : Int, offset : Int) -> Double {
  let jd = @math.floor((year - 2000).to_double() * 365.2422 + 180.0)
  let mut w = @math.floor((jd - 355.0 + 183.0) / 365.2422) * 365.2422 + 355.0
  if calc_qi(w) > jd {
    w = w - 365.2422
  }
  calc_qi(w + 15.2184 * offset.to_double())
}

///|
pub impl Culture for SolarTerm with fn get_name(self : SolarTerm) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for SolarTerm with fn to_string(self : SolarTerm) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for SolarTerm with fn next(self : SolarTerm, n : Int) -> SolarTerm {
  let size = self.loop_tyme.get_size()
  let i = self.loop_tyme.get_index() + n
  SolarTerm::from_index(
    (self.year * size + i) / size,
    self.loop_tyme.index_of(i),
  )
}

// is_jie 是否节令

///|
pub fn SolarTerm::is_jie(self : SolarTerm) -> Bool {
  self.loop_tyme.get_index() % 2 == 1
}

// is_qi 是否气令

///|
pub fn SolarTerm::is_qi(self : SolarTerm) -> Bool {
  self.loop_tyme.get_index() % 2 == 0
}

// get_julian_day 儒略日（精确到秒）

///|
pub fn SolarTerm::get_julian_day(self : SolarTerm) -> JulianDay {
  JulianDay::from_julian_day(
    qi_accurate2(self.cursory_julian_day) + J2000.to_double(),
  )
}

///|
// get_solar_day 公历日（用于日历）
// 注（2026-08-02 22:10 补译）：原注释称需等 SolarTime/SolarDay/JulianDay 互引环解出，
// 但该环已于本日 21:40 解开（JulianDay::from_julian_day / get_solar_day 均已就绪）。
pub fn SolarTerm::get_solar_day(self : SolarTerm) -> SolarDay {
  JulianDay::from_julian_day(self.cursory_julian_day + J2000.to_double()).get_solar_day_unchecked()
}

// get_year 年

///|
pub fn SolarTerm::get_year(self : SolarTerm) -> Int {
  self.year
}

// get_cursory_julian_day 儒略日（用于日历，只精确到日中午12:00）

///|
pub fn SolarTerm::get_cursory_julian_day(self : SolarTerm) -> Double {
  self.cursory_julian_day
}

///|
pub extend SolarTerm with Culture::{get_name}

///|
pub extend SolarTerm with Show::{to_string}
