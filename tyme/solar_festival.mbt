///|
// SolarFestival 公历现代节日
pub struct SolarFestival {
  festival : AbstractFestival
}

///|
// solar_festival_names 公历现代节日名称
pub fn solar_festival_names() -> Array[String] {
  [
    "元旦", "妇女节", "植树节", "劳动节", "青年节", "儿童节", "建党节",
    "建军节", "教师节", "国庆节",
  ]
}

///|
// solar_festival_data 公历现代节日数据
pub let solar_festival_data : String = "0VV__0Ux0Xc__0Ux0Xg__0_Q0ZV__0Ux0ZY__0Ux0aV__0Ux0bV__0Uo0cV__0Ug0de__0_V0eV__0Ux"

///|
// new 构造
pub fn SolarFestival::new(
  index : Int,
  event : Event,
  day : SolarDay,
) -> SolarFestival {
  { festival: AbstractFestival::new(index, event, day.day_unit) }
}

///|
// from_index 从索引构造
pub fn SolarFestival::from_index(year : Int, index : Int) -> SolarFestival? {
  if index < 0 || index >= solar_festival_names().length() {
    return None
  }
  let start = index * 8
  let e = Event::new(
    solar_festival_names()[index],
    "@" + solar_festival_data[start:start + 8].to_owned(),
  ).unwrap()
  if year < e.get_start_year() {
    return None
  }
  let d = match SolarDay::from_ymd(year, e.get_value(2), e.get_value(3)) {
    Err(_) => return None
    Ok(v) => v
  }
  Some(SolarFestival::new(index, e, d))
}

///|
// from_ymd 从年月日构造
pub fn SolarFestival::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> SolarFestival? {
  let d = match SolarDay::from_ymd(year, month, day) {
    Err(_) => return None
    Ok(v) => v
  }
  for i = 0; i < solar_festival_names().length(); i = i + 1 {
    let name = solar_festival_names()[i]
    let start = i * 8
    let e = Event::new(
      name,
      "@" + solar_festival_data[start:start + 8].to_owned(),
    ).unwrap()
    if d.get_year() >= e.get_start_year() &&
      d.get_month() == e.get_value(2) &&
      d.get_day() == e.get_value(3) {
      return Some(SolarFestival::new(i, e, d))
    }
  }
  None
}

///|
// get_day 公历日
pub fn SolarFestival::get_day(self : SolarFestival) -> SolarDay {
  let day = self.festival.day
  SolarDay::from_ymd(
    day.month_unit.year_unit.get_year(),
    day.month_unit.get_month(),
    day.get_day(),
  ).unwrap()
}

///|
// get_start_year 起始年
pub fn SolarFestival::get_start_year(self : SolarFestival) -> Int {
  self.festival.event.get_start_year()
}

///|
// next 推移
pub fn SolarFestival::next(self : SolarFestival, n : Int) -> SolarFestival? {
  let size = solar_festival_names().length()
  let i = self.festival.index + n
  SolarFestival::from_index(
    (self.festival.day.month_unit.year_unit.get_year() * size + i) / size,
    AbstractCulture::index_of(i, size),
  )
}

///|
// get_name 名称
pub fn SolarFestival::get_name(self : SolarFestival) -> String {
  Culture::get_name(self.festival)
}

///|
// get_index 索引
pub fn SolarFestival::get_index(self : SolarFestival) -> Int {
  self.festival.get_index()
}

///|
pub impl Culture for SolarFestival with fn get_name(self : SolarFestival) -> String {
  Culture::get_name(self.festival)
}

///|
pub impl Show for SolarFestival with fn to_string(self : SolarFestival) -> String {
  self.get_day().to_string() + " " + self.get_name()
}
