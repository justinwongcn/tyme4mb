// Tyme4MB 示例工程
// 演示公历/农历转换、干支查询、八字排盘、节气查询等核心功能

///|
fn week_str(w : @tyme.Week) -> String {
  "星期" + w.to_string()
}

///|
fn solar_term_str(t : @tyme.SolarTerm) -> String {
  "\{t.to_string()} (" + (if t.is_jie() { "节" } else { "气" }) + ")"
}

///|
fn main {
  // ========== 1. 公历日 ==========
  println("========== 公历日 ==========")
  let solarDay = @tyme.SolarDay::from_ymd(2026, 8, 4).unwrap()
  println("公历日: \{solarDay}")
  println(week_str(solarDay.get_week()))
  println("星座: \{solarDay.get_constellation()}")

  // ========== 2. 公历转农历 ==========
  println("\n========== 公历转农历 ==========")
  let lunarDay = solarDay.get_lunar_day()
  println("农历日: \{lunarDay}")
  let lunarMonth = lunarDay.get_lunar_month()
  println("农历月: \{lunarMonth}")

  // ========== 3. 干支查询 ==========
  println("\n========== 干支查询 ==========")
  let sixtyCycleDay = solarDay.get_sixty_cycle_day()
  println("干支日: \{sixtyCycleDay.get_sixty_cycle()}")
  let sixtyCycleMonth = sixtyCycleDay.get_sixty_cycle_month()
  println("干支月: \{sixtyCycleMonth.get_sixty_cycle()}")
  let sixtyCycleYear = sixtyCycleMonth.get_sixty_cycle_year()
  println("干支年: \{sixtyCycleYear.get_sixty_cycle()}")
  let zodiac = sixtyCycleYear.get_sixty_cycle().get_earth_branch().get_zodiac()
  println("生肖: \{zodiac}")

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
    "八字: \{eightChar.get_year()} \{eightChar.get_month()} \{eightChar.get_day()} \{eightChar.get_hour()}",
  )

  // ========== 6. 神煞宜忌 ==========
  println("\n========== 神煞宜忌 ==========")
  let gods = lunarDay.get_gods()
  match gods {
    Ok(list) => {
      let mut godNames = ""
      for g in list {
        godNames = godNames + g.to_string() + " "
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
        names = names + t.to_string() + " "
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
        names = names + t.to_string() + " "
      }
      println("当日忌: \{names}")
    }
    Err(e) => println("宜忌查询失败: \{e}")
  }

  // ========== 7. 回历 ==========
  println("\n========== 回历 ==========")
  let hijriDay = solarDay.get_hijri_day()
  println("回历日: \{hijriDay}")

  // ========== 8. 藏历（饶迥历） ==========
  println("\n========== 藏历 ==========")
  let rabByungDay = solarDay.get_rab_byung_day()
  match rabByungDay {
    Ok(d) => println("藏历日: \{d}")
    Err(e) => println("藏历查询失败: \{e}")
  }

  // ========== 9. 月相 ==========
  println("\n========== 月相 ==========")
  let phase = solarDay.get_phase()
  println("月相: \{phase}")

  // ========== 10. 法定假日 ==========
  println("\n========== 法定假日 ==========")
  let holiday = solarDay.get_legal_holiday()
  match holiday {
    None => println("当日不是法定假日")
    Some(h) => println("法定假日: \{h}")
  }

  // ========== 11. 事件管理 ==========
  println("\n========== 事件管理 ==========")
  let mgr = @tyme.EventManager::new()
  let chunjie = @tyme.Event::builder().lunar_day(1, 1, 0).build().unwrap()
  let mgr2 = mgr.update("春节", chunjie)
  match mgr2.from_name("春节") {
    Some(e) =>
      match e.get_solar_day(2026) {
        Some(d) => println("2026年春节: \{d}")
        None => println("未找到")
      }
    None => println("事件未找到")
  }

  println("\n========== 示例结束 ==========")
}
