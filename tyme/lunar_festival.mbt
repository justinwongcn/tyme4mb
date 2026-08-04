///|
// LunarFestival 农历传统节日（依据国家标准《农历的编算和颁行》GB/T 33661-2017）
pub struct LunarFestival {
  festival : AbstractFestival
}

///|
// lunar_festival_names 农历传统节日名称
pub fn lunar_festival_names() -> Array[String] {
  [
    "春节", "元宵节", "龙头节", "上巳节", "清明节", "端午节", "七夕节",
    "中元节", "中秋节", "重阳节", "冬至节", "腊八节", "除夕",
  ]
}

///|
// lunar_festival_data 农历传统节日数据
pub let lunar_festival_data : String = "2VV__0002Vj__0002WW__0002XX__0003b___0002ZZ__0002bb__0002bj__0002cj__0002dd__0003s___0002gc__0002hV_U000"

///|
// new 构造
pub fn LunarFestival::new(
  index : Int,
  event : Event,
  day : LunarDay,
) -> LunarFestival {
  LunarFestival::{ festival: AbstractFestival::new(index, event, day.day_unit) }
}

///|
// from_index 从索引构造
pub fn LunarFestival::from_index(year : Int, index : Int) -> LunarFestival? {
  if index < 0 || index >= lunar_festival_names().length() {
    return None
  }
  let start = index * 8
  let e = Event::new(
    lunar_festival_names()[index],
    "@" + lunar_festival_data[start:start + 8].to_owned(),
  ).unwrap()
  match e.get_type() {
    LunarDay => {
      let (y, m) = e.get_month(year)
      let d = LunarDay::from_ymd(y, m, e.get_value(3)).unwrap()
      let offset = e.get_value(5)
      if 0 == offset {
        return Some(LunarFestival::new(index, e, d))
      }
      Some(LunarFestival::new(index, e, d.next(offset)))
    }
    TermDay =>
      Some(
        LunarFestival::new(
          index,
          e,
          SolarTerm::from_index(year, e.get_value(2))
          .get_solar_day()
          .get_lunar_day(),
        ),
      )
    _ => None
  }
}

///|
// from_ymd 从年月日构造
pub fn LunarFestival::from_ymd(
  year : Int,
  month : Int,
  day : Int,
) -> LunarFestival? {
  let d = match LunarDay::from_ymd(year, month, day) {
    Err(_) => return None
    Ok(v) => v
  }
  for i = 0; i < lunar_festival_names().length(); i = i + 1 {
    let name = lunar_festival_names()[i]
    let start = i * 8
    let e = Event::new(
      name,
      "@" + lunar_festival_data[start:start + 8].to_owned(),
    ).unwrap()
    match e.get_type() {
      LunarDay => {
        let offset = e.get_value(5)
        if 0 == offset {
          if d.get_month() == e.get_value(2) && d.get_day() == e.get_value(3) {
            return Some(LunarFestival::new(i, e, d))
          }
        } else {
          let (y, m) = e.get_month(d.get_year())
          let next = d.next(-offset)
          if next.get_year() == y &&
            next.get_month() == m &&
            next.get_day() == e.get_value(3) {
            return Some(LunarFestival::new(i, e, d))
          }
        }
      }
      TermDay => {
        let term = d.get_solar_day().get_term_day()
        if term.get_day_index() == 0 &&
          term.get_solar_term().loop_tyme.get_index() == e.get_value(2) % 24 {
          return Some(LunarFestival::new(i, e, d))
        }
      }
      _ => ()
    }
  }
  None
}

///|
// get_day 农历日
pub fn LunarFestival::get_day(self : LunarFestival) -> LunarDay {
  let day = self.festival.day
  LunarDay::from_ymd(
    day.month_unit.year_unit.get_year(),
    day.month_unit.get_month(),
    day.get_day(),
  ).unwrap()
}

///|
// get_solar_term 节气
pub fn LunarFestival::get_solar_term(self : LunarFestival) -> SolarTerm? {
  let t = self.get_day().get_solar_day().get_term_day()
  if 0 == t.get_day_index() {
    return Some(t.get_solar_term())
  }
  None
}

///|
// next 推移
pub fn LunarFestival::next(self : LunarFestival, n : Int) -> LunarFestival? {
  let size = lunar_festival_names().length()
  let i = self.festival.index + n
  LunarFestival::from_index(
    (self.festival.day.month_unit.year_unit.get_year() * size + i) / size,
    AbstractCulture::index_of(i, size),
  )
}

///|
// get_name 名称
pub fn LunarFestival::get_name(self : LunarFestival) -> String {
  Culture::get_name(self.festival)
}

///|
// get_index 索引
pub fn LunarFestival::get_index(self : LunarFestival) -> Int {
  self.festival.get_index()
}

///|
impl Culture for LunarFestival with fn get_name(self : LunarFestival) -> String {
  Culture::get_name(self.festival)
}

///|
impl Show for LunarFestival with fn to_string(self : LunarFestival) -> String {
  self.get_day().to_string() + " " + self.get_name()
}

///|
extend LunarFestival with Show::{to_string}
