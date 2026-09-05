///|
// Event 事件
pub struct Event {
  name : String
  data : String
}

///|
// validate 校验
pub fn Event::validate(data : String) -> Result[Unit, String] {
  if data.length() != 9 || data.unsafe_get(0).to_int() != '@'.to_int() {
    return Err("illegal event data: " + data)
  }
  let chars = event_manager_chars()
  for i = 1; i < 9; i = i + 1 {
    let c = data.unsafe_get(i).to_int()
    let mut found = false
    for j = 0; j < chars.length(); j = j + 1 {
      if chars.unsafe_get(j).to_int() == c {
        found = true
        break
      }
    }
    if !found {
      return Err("illegal event data: " + data)
    }
  }
  Ok(())
}

///|
// builder 事件构造器
pub fn Event::builder() -> EventBuilder {
  EventBuilder::new()
}

///|
// new 构造
pub fn Event::new(name : String, data : String) -> Result[Event, String] {
  match Event::validate(data) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  Ok({ name, data, })
}

///|
fn Event::get_char_index(self : Event, index : Int) -> Int {
  // data 为 ASCII 字符
  let c = self.data.unsafe_get(index).to_int()
  let chars = event_manager_chars()
  let mut i = 0
  while i < chars.length() {
    if chars.unsafe_get(i).to_int() == c {
      return i
    }
    i = i + 1
  }
  -1
}

///|
// get_value 获取值
pub fn Event::get_value(self : Event, index : Int) -> Int {
  self.get_char_index(index) - 31
}

///|
// get_month 获取月
pub fn Event::get_month(self : Event, year : Int) -> (Int, Int) {
  let mut y = year
  let mut m = self.get_value(2)
  if m > 12 {
    m = 1
    y = y + 1
  }
  (y, m)
}

///|
// get_name 事件名称
pub fn Event::get_name(self : Event) -> String {
  self.name
}

///|
// get_data 事件数据
pub fn Event::get_data(self : Event) -> String {
  self.data
}

///|
// get_type 事件类型
pub fn Event::get_type(self : Event) -> EventType {
  EventType::from_code(self.get_char_index(1))
}

///|
// get_start_year 事件起始年
pub fn Event::get_start_year(self : Event) -> Int {
  let mut n = 0
  let size = event_manager_chars().length()
  for i = 0; i < 3; i = i + 1 {
    n = n * size + self.get_char_index(6 + i)
  }
  n
}

///|
// get_solar_day 公历日，如果当年没有该事件，返回 None
pub fn Event::get_solar_day(self : Event, year : Int) -> SolarDay? {
  if year < self.get_start_year() {
    return None
  }
  let d = match self.get_type() {
    SolarDay => self.get_solar_day_by_solar_day(year)
    SolarWeek => self.get_solar_day_by_week(year)
    LunarDay => self.get_solar_day_by_lunar_day(year)
    TermDay => self.get_solar_day_by_term(year)
    TermHs => self.get_solar_day_by_term_heaven_stem(year)
    TermEb => self.get_solar_day_by_term_earth_branch(year)
  }
  let d = match d {
    None => return None
    Some(v) => v
  }
  let offset = self.get_value(5)
  if offset == 0 {
    return Some(d)
  }
  Some(d.next(offset))
}

///|
fn Event::get_solar_day_by_solar_day(self : Event, year : Int) -> SolarDay? {
  let (y, m) = self.get_month(year)
  let d = self.get_value(3)
  let delay = self.get_value(4)
  let sm = match SolarMonth::from_ym(y, m) {
    Err(_) => return None
    Ok(v) => v
  }
  let last_day = sm.get_day_count()
  if d > last_day {
    if delay == 0 {
      return None
    }
    if delay < 0 {
      return match SolarDay::from_ymd(y, m, d + delay) {
        Err(_) => None
        Ok(t) => Some(t)
      }
    }
    let t = match SolarDay::from_ymd(y, m, last_day) {
      Err(_) => return None
      Ok(v) => v
    }
    return Some(t.next(delay))
  }
  match SolarDay::from_ymd(y, m, d) {
    Err(_) => None
    Ok(t) => Some(t)
  }
}

///|
fn Event::get_solar_day_by_lunar_day(self : Event, year : Int) -> SolarDay? {
  let (y, m) = self.get_month(year)
  let d = self.get_value(3)
  let delay = self.get_value(4)
  let lm = match LunarMonth::from_ym(y, m) {
    Err(_) => return None
    Ok(v) => v
  }
  let last_day = lm.get_day_count()
  if d > last_day {
    if delay == 0 {
      return None
    }
    if delay < 0 {
      return match LunarDay::from_ymd(y, m, d + delay) {
        Err(_) => None
        Ok(t) => Some(t.get_solar_day())
      }
    }
    let t = match LunarDay::from_ymd(y, m, last_day) {
      Err(_) => return None
      Ok(v) => v
    }
    return Some(t.get_solar_day().next(delay))
  }
  match LunarDay::from_ymd(y, m, d) {
    Err(_) => None
    Ok(t) => Some(t.get_solar_day())
  }
}

///|
fn Event::get_solar_day_by_week(self : Event, year : Int) -> SolarDay? {
  let n = self.get_value(3)
  if n == 0 {
    return None
  }
  let m = match SolarMonth::from_ym(year, self.get_value(2)) {
    Err(_) => return None
    Ok(v) => v
  }
  let w = self.get_value(4)
  if n > 0 {
    let d = m.get_first_day()
    return Some(d.next(d.get_week().steps_to(w) + 7 * n - 7))
  }
  let d = match SolarDay::from_ymd(year, m.get_month(), m.get_day_count()) {
    Err(_) => return None
    Ok(v) => v
  }
  Some(d.next(d.get_week().steps_back_to(w) + 7 * n + 7))
}

///|
fn Event::get_solar_day_by_term(self : Event, year : Int) -> SolarDay? {
  let d = SolarTerm::from_index(year, self.get_value(2)).get_solar_day()
  let offset = self.get_value(4)
  if offset == 0 {
    return Some(d)
  }
  Some(d.next(offset))
}

///|
fn Event::get_solar_day_by_term_heaven_stem(
  self : Event,
  year : Int,
) -> SolarDay? {
  let d = match self.get_solar_day_by_term(year) {
    None => return None
    Some(v) => v
  }
  Some(
    d.next(
      d
      .get_lunar_day()
      .get_sixty_cycle()
      .get_heaven_stem()
      .steps_to(self.get_value(3)),
    ),
  )
}

///|
fn Event::get_solar_day_by_term_earth_branch(
  self : Event,
  year : Int,
) -> SolarDay? {
  let d = match self.get_solar_day_by_term(year) {
    None => return None
    Some(v) => v
  }
  Some(
    d.next(
      d
      .get_lunar_day()
      .get_sixty_cycle()
      .get_earth_branch()
      .steps_to(self.get_value(3)),
    ),
  )
}

///|
// from_name 从名称获取事件（从全局事件数据中查找）
pub fn Event::from_name(name : String) -> Event? {
  match event_manager_data.val.get(name) {
    None => None
    Some(d) =>
      match Event::new(name, d) {
        Err(_) => None
        Ok(e) => Some(e)
      }
  }
}

///|
// all 所有事件（从全局事件数据中枚举）
pub fn Event::all() -> Array[Event] {
  let l : Array[Event] = []
  event_manager_data.val.each(fn(k, v) {
    match Event::new(k, v) {
      Ok(e) => l.push(e)
      Err(_) => ()
    }
  })
  l
}

///|
// from_solar_day 指定公历日的事件列表（从全局事件数据中查找）
pub fn Event::from_solar_day(d : SolarDay) -> Array[Event] {
  let l : Array[Event] = []
  let all = Event::all()
  for i = 0; i < all.length(); i = i + 1 {
    let e = all[i]
    match e.get_solar_day(d.get_year()) {
      None => ()
      Some(t) => if d.equals(t) { l.push(e) } else { () }
    }
  }
  l
}

///|
pub impl Culture for Event with fn get_name(self : Event) -> String {
  self.name
}

///|
pub impl Show for Event with fn to_string(self : Event) -> String {
  self.name
}
