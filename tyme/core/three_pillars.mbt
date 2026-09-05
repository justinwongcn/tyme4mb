///|
// ThreePillars 三柱（年柱、月柱、日柱）
pub struct ThreePillars {
  // 年柱
  year : SixtyCycle
  // 月柱
  month : SixtyCycle
  // 日柱
  day : SixtyCycle
}

///|
extend ThreePillars with Culture::{get_name}

///|
extend ThreePillars with Show::{to_string}

///|
// new 从年月日柱名称构造
pub fn ThreePillars::new(
  year : String,
  month : String,
  day : String,
) -> Result[ThreePillars, String] {
  let y = match SixtyCycle::from_name(year) {
    Err(e) => return Err(e)
    Ok(v) => v
  }
  let m = match SixtyCycle::from_name(month) {
    Err(e) => return Err(e)
    Ok(v) => v
  }
  let d = match SixtyCycle::from_name(day) {
    Err(e) => return Err(e)
    Ok(v) => v
  }
  Ok({ year: y, month: m, day: d, })
}

///|
// from_sixty_cycle 从干支构造
pub fn ThreePillars::from_sixty_cycle(
  year : SixtyCycle,
  month : SixtyCycle,
  day : SixtyCycle,
) -> ThreePillars {
  { year, month, day, }
}

///|
// get_year 年柱
pub fn ThreePillars::get_year(self : ThreePillars) -> SixtyCycle {
  self.year
}

///|
// get_month 月柱
pub fn ThreePillars::get_month(self : ThreePillars) -> SixtyCycle {
  self.month
}

///|
// get_day 日柱
pub fn ThreePillars::get_day(self : ThreePillars) -> SixtyCycle {
  self.day
}

///|
// equals 是否相等
pub fn ThreePillars::equals(self : ThreePillars, target : ThreePillars) -> Bool {
  self.to_string() == target.to_string()
}

// 注（部分功能优先，2026-08-03 02:20 更新）：
// get_solar_days 已于 2026-08-03 随 LunarDay + SixtyCycleDay 译完回填。

///|
// get_solar_days 公历日列表
pub fn ThreePillars::get_solar_days(
  self : ThreePillars,
  start_year : Int,
  end_year : Int,
) -> Array[SolarDay] {
  let l : Array[SolarDay] = []
  // 月地支距寅月的偏移值
  let m = self.month.get_earth_branch().next(-2).get_index()
  // 月天干要一致
  if !HeavenStem::from_index(
      (self.year.get_heaven_stem().get_index() + 1) * 2 + m,
    ).equals(self.month.get_heaven_stem()) {
    return l
  }
  // 1年的立春是辛酉，序号57
  let mut y = self.year.next(-57).get_index() + 1
  // 节令偏移值
  let m2 = m * 2
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
    let mut solar_day = term.get_solar_day()
    if solar_day.get_year() >= start_year {
      // 日干支和节令干支的偏移值
      let d = self.day
        .next(-solar_day.get_lunar_day().get_sixty_cycle().get_index())
        .get_index()
      if d > 0 {
        // 从节令推移天数
        solar_day = solar_day.next(d)
      }
      // 验证一下
      if solar_day.get_sixty_cycle_day().get_three_pillars().equals(self) {
        l.push(solar_day)
      }
    }
    y = y + 60
  }
  l
}

///|
pub impl Culture for ThreePillars with fn get_name(self : ThreePillars) -> String {
  self.year.to_string() +
  " " +
  self.month.to_string() +
  " " +
  self.day.to_string()
}

///|
pub impl Show for ThreePillars with fn to_string(self : ThreePillars) -> String {
  self.get_name()
}
