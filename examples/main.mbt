// Tyme4MB 示例工程
// 演示公历/农历转换、干支查询、八字排盘、节气查询等核心功能
//
// 注意：MoonBit 跨包不可见 trait 方法（Show/Culture），
// 因此使用 get_index + 名称数组的方式构建显示字符串。

///|
fn solar_day_str(d : @tyme.SolarDay) -> String {
  "\{d.get_year()}年\{d.get_month()}月\{d.get_day()}日"
}

///|
fn sixty_cycle_str(sc : @tyme.SixtyCycle) -> String {
  let stemNames = @tyme.heaven_stem_names()
  let branchNames = @tyme.earth_branch_names()
  let stem = stemNames[sc.get_heaven_stem().get_index()]
  let branch = branchNames[sc.get_earth_branch().get_index()]
  stem + branch
}

///|
fn zodiac_str(z : @tyme.Zodiac) -> String {
  @tyme.zodiac_names()[z.get_index()]
}

///|
fn week_str(w : @tyme.Week) -> String {
  let names = ["日", "一", "二", "三", "四", "五", "六"]
  "星期" + names[w.get_index()]
}

///|
fn constellation_str(c : @tyme.Constellation) -> String {
  @tyme.constellation_names()[c.get_index()]
}

///|
fn solar_term_str(t : @tyme.SolarTerm) -> String {
  let sd = t.get_solar_day()
  "\{solar_day_str(sd)} (" + (if t.is_jie() { "节" } else { "气" }) + ")"
}

///|
fn hijri_day_str(d : @tyme.HijriDay) -> String {
  "\{d.get_year()}年\{d.get_month()}月\{d.get_day()}日"
}

///|
fn rab_byung_day_str(d : @tyme.RabByungDay) -> String {
  let leap = if d.is_leap() { "闰" } else { "" }
  "\{d.get_year()}年\{leap}\{d.get_month()}月\{d.get_day()}日"
}

///|
fn god_str(g : @tyme.God) -> String {
  @tyme.god_names()[g.get_index()]
}

///|
fn taboo_str(t : @tyme.Taboo) -> String {
  @tyme.taboo_names()[t.get_index()]
}

///|
fn main {
  // ========== 1. 公历日 ==========
  println("========== 公历日 ==========")
  let solarDay = @tyme.SolarDay::from_ymd(2026, 8, 4).unwrap()
  println("公历日: \{solar_day_str(solarDay)}")
  println(week_str(solarDay.get_week()))
  println("星座: \{constellation_str(solarDay.get_constellation())}")

  // ========== 2. 公历转农历 ==========
  println("\n========== 公历转农历 ==========")
  let lunarDay = solarDay.get_lunar_day()
  println("农历日: \{lunar_day_str(lunarDay)}")
  let lunarMonth = lunarDay.get_lunar_month()
  println("农历月: \{lunar_month_str(lunarMonth)}")

  // ========== 3. 干支查询 ==========
  println("\n========== 干支查询 ==========")
  let sixtyCycleDay = solarDay.get_sixty_cycle_day()
  println("干支日: \{sixty_cycle_str(sixtyCycleDay.get_sixty_cycle())}")
  let sixtyCycleMonth = sixtyCycleDay.get_sixty_cycle_month()
  println("干支月: \{sixty_cycle_str(sixtyCycleMonth.get_sixty_cycle())}")
  let sixtyCycleYear = sixtyCycleMonth.get_sixty_cycle_year()
  println("干支年: \{sixty_cycle_str(sixtyCycleYear.get_sixty_cycle())}")
  let zodiac = sixtyCycleYear.get_sixty_cycle().get_earth_branch().get_zodiac()
  println("生肖: \{zodiac_str(zodiac)}")

  // ========== 4. 节气查询 ==========
  println("\n========== 节气查询 ==========")
  let term = solarDay.get_term()
  println("当前节气: \{solar_term_str(term)}")

  // ========== 5. 八字排盘 ==========
  println("\n========== 八字排盘 ==========")
  let solarTime = @tyme.SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0).unwrap()
  let lunarHour = solarTime.get_lunar_hour()
  let eightChar = @tyme.eight_char_provider.get_eight_char(lunarHour)
  println("出生时间: 1990年5月15日 14:30")
  println(
    "八字: \{sixty_cycle_str(eightChar.get_year())} \{sixty_cycle_str(eightChar.get_month())} \{sixty_cycle_str(eightChar.get_day())} \{sixty_cycle_str(eightChar.get_hour())}",
  )

  // ========== 6. 神煞宜忌 ==========
  println("\n========== 神煞宜忌 ==========")
  let gods = lunarDay.get_gods()
  match gods {
    Ok(list) => {
      let mut godNames = ""
      for g in list {
        godNames = godNames + god_str(g) + " "
      }
      println("当日神煞: \{godNames}")
    }
    Err(e) => println("神煞查询失败: \{e}")
  }
  let recommends = lunarDay.get_recommends()
  match recommends {
    Ok(list) => {
      let mut names = ""
      for t in list {
        names = names + taboo_str(t) + " "
      }
      println("当日宜: \{names}")
    }
    Err(e) => println("宜忌查询失败: \{e}")
  }
  let avoids = lunarDay.get_avoids()
  match avoids {
    Ok(list) => {
      let mut names = ""
      for t in list {
        names = names + taboo_str(t) + " "
      }
      println("当日忌: \{names}")
    }
    Err(e) => println("宜忌查询失败: \{e}")
  }

  // ========== 7. 回历 ==========
  println("\n========== 回历 ==========")
  let hijriDay = solarDay.get_hijri_day()
  println("回历日: \{hijri_day_str(hijriDay)}")

  // ========== 8. 藏历（饶迥历） ==========
  println("\n========== 藏历 ==========")
  let rabByungDay = solarDay.get_rab_byung_day()
  match rabByungDay {
    Ok(d) => println("藏历日: \{rab_byung_day_str(d)}")
    Err(e) => println("藏历查询失败: \{e}")
  }

  // ========== 9. 月相 ==========
  println("\n========== 月相 ==========")
  let phase = solarDay.get_phase()
  println("月相: \{phase.get_name()}")

  // ========== 10. 法定假日 ==========
  println("\n========== 法定假日 ==========")
  let holiday = solarDay.get_legal_holiday()
  match holiday {
    None => println("当日不是法定假日")
    Some(h) => println("法定假日: \{h.get_name()}")
  }

  // ========== 11. 事件管理 ==========
  println("\n========== 事件管理 ==========")
  let mgr = @tyme.EventManager::new()
  let chunjie = @tyme.Event::builder().lunar_day(1, 1, 0).build().unwrap()
  let mgr2 = mgr.update("春节", chunjie)
  match mgr2.from_name("春节") {
    Some(e) =>
      match e.get_solar_day(2026) {
        Some(d) => println("2026年春节: \{solar_day_str(d)}")
        None => println("未找到")
      }
    None => println("事件未找到")
  }

  println("\n========== 示例结束 ==========")
}

///|
fn lunar_day_str(d : @tyme.LunarDay) -> String {
  let monthNames = @tyme.lunar_month_names()
  let dayNames = @tyme.lunar_day_names()
  let m = d.get_lunar_month()
  let monthIdx = m.get_month()
  let monthName = if m.is_leap() {
    "闰" + monthNames[monthIdx]
  } else {
    monthNames[monthIdx]
  }
  "\{d.get_year()}年\{monthName}\{dayNames[d.get_day() - 1]}"
}

///|
fn lunar_month_str(m : @tyme.LunarMonth) -> String {
  let monthNames = @tyme.lunar_month_names()
  let monthName = if m.is_leap() {
    "闰" + monthNames[m.get_month()]
  } else {
    monthNames[m.get_month()]
  }
  "\{m.get_year()}年\{monthName}"
}
