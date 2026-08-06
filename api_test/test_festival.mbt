// 包外 API 测试：节日、法定假日、事件
// 验证 api.md 中所有节日和事件相关接口可从包外调用

///|
test "SolarFestival" {
  // 通过公历日得到节日
  let sf = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap().get_festival()
  match sf {
    Some(f) => {
      let _ = f.get_name()
      let _ = f.get_day()
      let _ = f.get_index()
      let _ = f.get_start_year()
    }
    None => ()
  }
  // 通过索引初始化
  let sf2 = @tyme.SolarFestival::from_index(2023, 0)
  match sf2 {
    Some(f) => {
      let _ = f.get_name()
      let _ = f.get_day()
    }
    None => ()
  }
  // 通过年月日初始化
  let sf3 = @tyme.SolarFestival::from_ymd(2023, 1, 1)
  match sf3 {
    Some(f) => {
      let _ = f.get_name()
    }
    None => ()
  }
  // 非节日返回 None
  let sf4 = @tyme.SolarFestival::from_ymd(2023, 4, 20)
  let _ = sf4 is None
  // next 方法
  let sf5 = @tyme.SolarFestival::from_index(2023, 0)
  match sf5 {
    Some(f) => {
      let nf = f.next(1)
      match nf {
        Some(n) => {
          let _ = n.get_name()
        }
        None => ()
      }
    }
    None => ()
  }
}

///|
test "LunarFestival" {
  // 通过农历日得到节日
  let lf = @tyme.LunarDay::from_ymd(2023, 1, 15).unwrap().get_festival()
  match lf {
    Some(f) => {
      let _ = f.get_name()
      let _ = f.get_day()
      let _ = f.get_index()
      let _ = f.get_solar_term()
    }
    None => ()
  }
  // 通过索引初始化
  let lf2 = @tyme.LunarFestival::from_index(2023, 0)
  match lf2 {
    Some(f) => {
      let _ = f.get_name()
      let _ = f.get_day()
    }
    None => ()
  }
  // 通过年月日初始化
  let lf3 = @tyme.LunarFestival::from_ymd(2023, 1, 15)
  match lf3 {
    Some(f) => {
      let _ = f.get_name()
    }
    None => ()
  }
  // 非节日返回 None
  let lf4 = @tyme.LunarFestival::from_ymd(2023, 1, 2)
  let _ = lf4 is None
  // next 方法
  let lf5 = @tyme.LunarFestival::from_index(2023, 0)
  match lf5 {
    Some(f) => {
      let nf = f.next(1)
      match nf {
        Some(n) => {
          let _ = n.get_name()
        }
        None => ()
      }
    }
    None => ()
  }
}

///|
test "LegalHoliday" {
  // 通过公历日得到法定假日
  let lh = @tyme.SolarDay::from_ymd(2023, 10, 1).unwrap().get_legal_holiday()
  match lh {
    Some(h) => {
      let _ = h.get_name()
      let _ = h.get_day()
      let _ = h.is_work()
      // next 方法
      let nh = h.next(1)
      match nh {
        Some(n) => {
          let _ = n.get_name()
        }
        None => ()
      }
    }
    None => ()
  }
  // 通过年月日初始化
  let lh2 = @tyme.LegalHoliday::from_ymd(2023, 10, 1).unwrap()
  let _ = lh2.get_name()
  let _ = lh2.is_work()
  let _ = lh2.get_day()
  // 非法定假日返回 Err
  let lh3 = @tyme.LegalHoliday::from_ymd(2023, 4, 20)
  let _ = lh3 is Err(_)
  // 调休判断
  let lh4 = @tyme.LegalHoliday::from_ymd(2024, 2, 4).unwrap()
  let _ = lh4.is_work()
  let _ = lh4.get_name()
}

///|
test "EventType" {
  let et = @tyme.EventType::from_code(0)
  let _ = et.get_name()
  let _ = et.get_code()
  let et2 = @tyme.EventType::from_code(1)
  let _ = et2.get_name()
  let _ = et2.get_code()
}

///|
test "Event" {
  // 先添加事件
  @tyme.EventManager::update(
    "情人节",
    @tyme.Event::builder().solar_day(2, 14, 0).start_year(270).build().unwrap(),
  ).unwrap()
  let e = @tyme.Event::from_name("情人节").unwrap()
  let _ = e.get_name()
  let _ = e.get_data()
  let _ = e.get_start_year()
  let _ = e.get_type()
  // 获取某年的公历日
  let sd = e.get_solar_day(2026)
  match sd {
    Some(d) => {
      let _ = d.get_name()
    }
    None => ()
  }
  // 通过公历日获取事件列表
  let events = @tyme.Event::from_solar_day(
    @tyme.SolarDay::from_ymd(2025, 2, 14).unwrap(),
  )
  let _ = events.length()
  // 获取所有事件
  let all = @tyme.Event::all()
  let _ = all.length()
}

///|
test "EventManager" {
  // 通过事件构造器更新
  let e = @tyme.Event::builder()
    .solar_day(3, 8, 0)
    .start_year(1950)
    .build()
    .unwrap()
  @tyme.EventManager::update("测试节日", e).unwrap()
  // 通过字符串数据更新（data 为 9 字符编码串，不含名称）
  let data = e.get_data()
  @tyme.EventManager::update_data("测试节日2", data).unwrap()
  // 删除事件
  @tyme.EventManager::remove("测试节日").unwrap()
  @tyme.EventManager::remove("测试节日2").unwrap()
  // 一次性替换所有事件数据（先备份再恢复）
  // set_data 会替换所有数据，这里用空测试后恢复
  // 不实际调用 set_data 以免影响其他测试
}

///|
test "EventBuilder" {
  // 公历日事件
  let e1 = @tyme.Event::builder()
    .solar_day(1, 1, 0)
    .start_year(1950)
    .build()
    .unwrap()
  let _ = e1.get_name()
  // 农历日事件
  let e2 = @tyme.Event::builder().lunar_day(2, 2, 0).build().unwrap()
  let _ = e2.get_name()
  // 节气日事件
  let e3 = @tyme.Event::builder().term_day(7, 0).build().unwrap()
  let _ = e3.get_name()
  // 公历周事件
  let e4 = @tyme.Event::builder()
    .solar_week(5, 2, 0)
    .start_year(1914)
    .build()
    .unwrap()
  let _ = e4.get_name()
  // 节气天干事件
  let e5 = @tyme.Event::builder()
    .term_heaven_stem(3, 4, 30)
    .offset(10)
    .build()
    .unwrap()
  let _ = e5.get_name()
  // 节气地支事件
  let e6 = @tyme.Event::builder().term_earth_branch(3, 2, 0).build().unwrap()
  let _ = e6.get_name()
  // 带名称的事件
  let e7 = @tyme.Event::builder()
    .name("自定义节日")
    .solar_day(6, 1, 0)
    .start_year(2000)
    .build()
    .unwrap()
  let _ = e7.get_name()
  // 农历日偏移事件（除夕）
  let e8 = @tyme.Event::builder()
    .lunar_day(13, 1, 0)
    .offset(-1)
    .build()
    .unwrap()
  let _ = e8.get_name()
}
