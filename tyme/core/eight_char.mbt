///|
// eight_char_provider 八字计算接口实现（全局可变，可通过 LunarHour::set_provider 切换）
pub let eight_char_provider : Ref[&IEightCharProvider] = Ref::{
  val: DefaultEightCharProvider::{ },
}

///|
// EightChar 八字
pub struct EightChar {
  // 三柱
  three_pillars : ThreePillars
  // 时柱
  hour : SixtyCycle
}

///|
extend EightChar with Culture::{get_name}

///|
extend EightChar with Show::{to_string}

///|
// new 从年月日时柱名称构造
pub fn EightChar::new(
  year : String,
  month : String,
  day : String,
  hour : String,
) -> Result[EightChar, String] {
  let t = match ThreePillars::new(year, month, day) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let h = match SixtyCycle::from_name(hour) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok({ three_pillars: t, hour: h, })
}

///|
// from_sixty_cycle 从干支构造
pub fn EightChar::from_sixty_cycle(
  year : SixtyCycle,
  month : SixtyCycle,
  day : SixtyCycle,
  hour : SixtyCycle,
) -> EightChar {
  { three_pillars: ThreePillars::from_sixty_cycle(year, month, day), hour, }
}

///|
// get_year 年柱
pub fn EightChar::get_year(self : EightChar) -> SixtyCycle {
  self.three_pillars.get_year()
}

///|
// get_month 月柱
pub fn EightChar::get_month(self : EightChar) -> SixtyCycle {
  self.three_pillars.get_month()
}

///|
// get_day 日柱
pub fn EightChar::get_day(self : EightChar) -> SixtyCycle {
  self.three_pillars.get_day()
}

///|
// get_hour 时柱
pub fn EightChar::get_hour(self : EightChar) -> SixtyCycle {
  self.hour
}

///|
// get_fetal_origin 胎元
pub fn EightChar::get_fetal_origin(self : EightChar) -> SixtyCycle {
  let m = self.get_month()
  SixtyCycle::from_index(
    m.get_heaven_stem().next(1).get_index() * 6 -
    m.get_earth_branch().next(3).get_index() * 5,
  )
}

///|
// get_fetal_breath 胎息
pub fn EightChar::get_fetal_breath(self : EightChar) -> SixtyCycle {
  let d = self.get_day()
  SixtyCycle::from_index(
    d.get_heaven_stem().next(5).get_index() * 6 +
    d.get_earth_branch().get_index() * 5 -
    65,
  )
}

///|
// get_own_sign 命宫
pub fn EightChar::get_own_sign(self : EightChar) -> SixtyCycle {
  SixtyCycle::from_index(
    self.get_year().get_heaven_stem().get_index() * 12 +
    (
      27 -
      self.get_month().get_earth_branch().get_index() -
      self.hour.get_earth_branch().get_index()
    ) %
    12 +
    2,
  )
}

///|
// get_body_sign 身宫
pub fn EightChar::get_body_sign(self : EightChar) -> SixtyCycle {
  SixtyCycle::from_index(
    self.get_year().get_heaven_stem().get_index() * 12 +
    (
      11 +
      self.get_month().get_earth_branch().get_index() +
      self.hour.get_earth_branch().get_index()
    ) %
    12 +
    2,
  )
}

///|
// get_duty 建除十二值神（已标记 Deprecated）
pub fn EightChar::get_duty(self : EightChar) -> Duty {
  Duty::from_index(
    self.get_day().get_earth_branch().get_index() -
    self.get_month().get_earth_branch().get_index(),
  )
}

///|
// get_solar_times 公历时刻列表(支持1-9999年)
pub fn EightChar::get_solar_times(
  self : EightChar,
  start_year : Int,
  end_year : Int,
) -> Array[SolarTime] {
  let l : Array[SolarTime] = []
  let year = self.get_year()
  let month = self.get_month()
  let day = self.get_day()
  // 月地支距寅月的偏移值
  let m = month.get_earth_branch().next(-2).get_index()
  // 月天干要一致
  if !HeavenStem::from_index((year.get_heaven_stem().get_index() + 1) * 2 + m).equals(
      month.get_heaven_stem(),
    ) {
    return l
  }
  // 1年的立春是辛酉，序号57
  let mut y = year.next(-57).get_index() + 1
  // 节令偏移值
  let m2 = m * 2
  // 时辰地支转时刻
  let h = self.hour.get_earth_branch().get_index() * 2
  let hours = if h == 0 { [0, 23] } else { [h] }
  let base_year = start_year - 1
  if base_year > y {
    y = y + 60 * ((base_year - y + 59) / 60)
  }
  while y <= end_year {
    // 立春为寅月的开始
    let mut term = SolarTerm::from_index(y, 3)
    // 节令推移，年干支和月干支就都匹配上了
    if m2 > 0 {
      term = term.next(m2)
    }
    let solar_time = term.get_julian_day().get_solar_time_unchecked()
    if solar_time.get_year() >= start_year {
      // 日干支和节令干支的偏移值
      let solar_day = solar_time.get_solar_day()
      let d = day
        .next(-solar_day.get_lunar_day().get_sixty_cycle().get_index())
        .get_index()
      if d > 0 {
        let solar_day2 = solar_day.next(d)
        let mut time = SolarTime::from_ymdhms(
          solar_day2.get_year(),
          solar_day2.get_month(),
          solar_day2.get_day(),
          hours[0],
          if d == 0 && hours[0] == solar_time.get_hour() {
            solar_time.get_minute()
          } else {
            0
          },
          if d == 0 && hours[0] == solar_time.get_hour() {
            solar_time.get_second()
          } else {
            0
          },
        ).unwrap()
        if d == 30 {
          time = time.next(-3600)
        }
        // 验证一下
        if time.get_lunar_hour().get_eight_char().equals(self) {
          l.push(time)
        }
        if hours.length() > 1 {
          let mut time2 = SolarTime::from_ymdhms(
            solar_day2.get_year(),
            solar_day2.get_month(),
            solar_day2.get_day(),
            hours[1],
            if d == 0 && hours[1] == solar_time.get_hour() {
              solar_time.get_minute()
            } else {
              0
            },
            if d == 0 && hours[1] == solar_time.get_hour() {
              solar_time.get_second()
            } else {
              0
            },
          ).unwrap()
          if d == 30 {
            time2 = time2.next(-3600)
          }
          if time2.get_lunar_hour().get_eight_char().equals(self) {
            l.push(time2)
          }
        }
      } else {
        let mut time = SolarTime::from_ymdhms(
          solar_day.get_year(),
          solar_day.get_month(),
          solar_day.get_day(),
          hours[0],
          if d == 0 && hours[0] == solar_time.get_hour() {
            solar_time.get_minute()
          } else {
            0
          },
          if d == 0 && hours[0] == solar_time.get_hour() {
            solar_time.get_second()
          } else {
            0
          },
        ).unwrap()
        if d == 30 {
          time = time.next(-3600)
        }
        if time.get_lunar_hour().get_eight_char().equals(self) {
          l.push(time)
        }
        if hours.length() > 1 {
          let mut time2 = SolarTime::from_ymdhms(
            solar_day.get_year(),
            solar_day.get_month(),
            solar_day.get_day(),
            hours[1],
            if d == 0 && hours[1] == solar_time.get_hour() {
              solar_time.get_minute()
            } else {
              0
            },
            if d == 0 && hours[1] == solar_time.get_hour() {
              solar_time.get_second()
            } else {
              0
            },
          ).unwrap()
          if d == 30 {
            time2 = time2.next(-3600)
          }
          if time2.get_lunar_hour().get_eight_char().equals(self) {
            l.push(time2)
          }
        }
      }
    }
    y = y + 60
  }
  l
}

///|
// equals 是否相等
pub fn EightChar::equals(self : EightChar, target : EightChar) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub impl Culture for EightChar with fn get_name(self : EightChar) -> String {
  "\{self.three_pillars.to_string()} \{self.hour.to_string()}"
}

///|
pub impl Show for EightChar with fn to_string(self : EightChar) -> String {
  self.get_name()
}
