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
  let eightChar = lunarHour.get_eight_char()
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
  let chunjie = @tyme.Event::builder().lunar_day(1, 1, 0).build().unwrap()
  @tyme.EventManager::update("春节", chunjie).unwrap()
  match @tyme.Event::from_name("春节") {
    Some(e) =>
      match e.get_solar_day(2026) {
        Some(d) => println("2026年春节: \{d}")
        None => println("未找到")
      }
    None => println("事件未找到")
  }

  // ========== 12. 真太阳时 ==========
  println("\n========== 真太阳时 ==========")
  let birthTime = @tyme.SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0).unwrap()
  // 北京约 116.39°E
  let trueSolarTime = birthTime.to_true_solar_time(116.39)
  println("出生钟表时间: \{birthTime}")
  println("北京真太阳时: \{trueSolarTime}")
  // 上海约 121.47°E
  let shanghaiTST = birthTime.to_true_solar_time(121.47)
  println("上海真太阳时: \{shanghaiTST}")
  // 乌鲁木齐约 87.62°E
  let urumqiTST = birthTime.to_true_solar_time(87.62)
  println("乌鲁木齐真太阳时: \{urumqiTST}")
  // 时辰级功能按真太阳时读取：乌鲁木齐钟表 14:30 → 真太阳时 12:24，午时
  let tstHour = urumqiTST.get_lunar_hour()
  println("乌鲁木齐真太阳时时柱: \{tstHour.get_sixty_cycle().get_name()}")
  println("乌鲁木齐真太阳时黄黑道: \{tstHour.get_twelve_star().get_name()}")
  let tstEightChar = tstHour.get_eight_char()
  println("乌鲁木齐真太阳时八字: \{tstEightChar.to_string()}")
  println("乌鲁木齐真太阳时命宫: \{tstEightChar.get_own_sign().get_name()}")
  // 童限真太阳时版：四柱按真太阳时，起运差值不受经度/均时差扭曲
  let tstChildLimit = @tyme.ChildLimit::from_true_solar_time(
    birthTime,
    @tyme.Gender::Man,
    87.62,
  )
  println(
    "乌鲁木齐真太阳时童限: \{tstChildLimit.get_year_count()}年\{tstChildLimit.get_month_count()}个月\{tstChildLimit.get_day_count()}天\{tstChildLimit.get_hour_count()}小时\{tstChildLimit.get_minute_count()}分钟",
  )
  // 太阳正午（北京 116.39°E，出生当日）
  println("北京太阳正午: \{birthTime.get_solar_noon(116.39)}")
  // 日出日落（北京 39.90°N, 116.39°E，出生当日）
  match birthTime.get_sunrise(39.90, 116.39) {
    Some(t) => println("北京日出: \{t}")
    None => println("北京日出: 极昼/极夜")
  }
  match birthTime.get_sunset(39.90, 116.39) {
    Some(t) => println("北京日落: \{t}")
    None => println("北京日落: 极昼/极夜")
  }

  println("\n========== 示例结束 ==========")
}
