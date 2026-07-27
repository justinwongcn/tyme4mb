// 测试套件：Event（对应 Go test/Event_test.go，一比一翻译 + 纯方案 C 形态）
//
// 历史：早期 EventManager 为不可变桩（update_event 空操作 / from_name 恒 None /
// all、from_solar_day 恒空），「按名查询 / 列表枚举」断言被省略。2026-08-03 先以
// 「方案 A（Ref 全局单例）+ 方案 C（值类型）」两层设计恢复注册表，随后按用户指令
// 迁移至纯方案 C：删除 global_mgr 单例与无参壳方法，全部查询走显式状态传递。
// 本测试对应 Go 的 initEvents（44 个事件）与 FromName/GetName/GetSolarDay/
// FromSolarDay/All 断言，统一以显式 EventManager 实例调用（mgr.update / mgr.from_name…）。

// 按名查询，未找到即失败（对应 Go `if e == nil { t.Fatal }`）
fn must_from_name(mgr : EventManager, name : String) -> Event {
  match mgr.from_name(name) {
    Some(e) => e
    None => abort("EventManager.from_name(\{name}) 事件未找到")
  }
}

// init_events 注册全部事件并返回管理器实例（对应 Go initEvents 的 44 个事件）
fn init_events() -> EventManager {
  let mut mgr = EventManager::new()
  // 公历现代节日
  mgr = mgr.update("公历现代节日:元旦", Event::builder().solar_day(1, 1, 0).start_year(1950).build().unwrap())
  mgr = mgr.update("公历现代节日:妇女节", Event::builder().solar_day(3, 8, 0).start_year(1950).build().unwrap())
  mgr = mgr.update("公历现代节日:植树节", Event::builder().solar_day(3, 12, 0).start_year(1979).build().unwrap())
  mgr = mgr.update("公历现代节日:劳动节", Event::builder().solar_day(5, 1, 0).start_year(1950).build().unwrap())
  mgr = mgr.update("公历现代节日:青年节", Event::builder().solar_day(5, 4, 0).start_year(1950).build().unwrap())
  mgr = mgr.update("公历现代节日:儿童节", Event::builder().solar_day(6, 1, 0).start_year(1950).build().unwrap())
  mgr = mgr.update("公历现代节日:建党节", Event::builder().solar_day(7, 1, 0).start_year(1941).build().unwrap())
  mgr = mgr.update("公历现代节日:建军节", Event::builder().solar_day(8, 1, 0).start_year(1933).build().unwrap())
  mgr = mgr.update("公历现代节日:教师节", Event::builder().solar_day(9, 10, 0).start_year(1985).build().unwrap())
  mgr = mgr.update("公历现代节日:国庆节", Event::builder().solar_day(10, 1, 0).start_year(1950).build().unwrap())
  // 农历传统节日
  mgr = mgr.update("农历传统节日:春节", Event::builder().lunar_day(1, 1, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:元宵节", Event::builder().lunar_day(1, 15, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:龙头节", Event::builder().lunar_day(2, 2, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:上巳节", Event::builder().lunar_day(3, 3, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:清明节", Event::builder().term_day(7, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:端午节", Event::builder().lunar_day(5, 5, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:七夕节", Event::builder().lunar_day(7, 7, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:中元节", Event::builder().lunar_day(7, 15, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:中秋节", Event::builder().lunar_day(8, 15, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:重阳节", Event::builder().lunar_day(9, 9, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:冬至节", Event::builder().term_day(24, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:腊八节", Event::builder().lunar_day(12, 8, 0).build().unwrap())
  mgr = mgr.update("农历传统节日:除夕", Event::builder().lunar_day(13, 1, 0).offset(-1).build().unwrap())
  // 其他节日
  mgr = mgr.update("情人节", Event::builder().solar_day(2, 14, 0).start_year(270).build().unwrap())
  mgr = mgr.update("国际消费者权益日", Event::builder().solar_day(3, 15, 0).start_year(1983).build().unwrap())
  mgr = mgr.update("愚人节", Event::builder().solar_day(4, 1, 0).start_year(1564).build().unwrap())
  mgr = mgr.update("万圣夜", Event::builder().solar_day(10, 31, 0).start_year(600).build().unwrap())
  mgr = mgr.update("万圣节", Event::builder().solar_day(11, 1, 0).start_year(600).build().unwrap())
  mgr = mgr.update("平安夜", Event::builder().solar_day(12, 24, 0).start_year(336).build().unwrap())
  mgr = mgr.update("圣诞节", Event::builder().solar_day(12, 25, 0).start_year(336).build().unwrap())
  // 周类
  mgr = mgr.update("全国中小学生安全教育日", Event::builder().solar_week(3, -1, 1).start_year(1996).build().unwrap())
  mgr = mgr.update("母亲节", Event::builder().solar_week(5, 2, 0).start_year(1914).build().unwrap())
  mgr = mgr.update("父亲节", Event::builder().solar_week(6, 3, 0).start_year(1972).build().unwrap())
  mgr = mgr.update("感恩节", Event::builder().solar_week(11, 4, 4).start_year(1941).build().unwrap())
  // 特殊节日
  mgr = mgr.update("寒食节", Event::builder().term_day(7, -1).build().unwrap())
  mgr = mgr.update("春社", Event::builder().term_heaven_stem(3, 4, 30).offset(10).build().unwrap())
  mgr = mgr.update("秋社", Event::builder().term_heaven_stem(15, 4, 30).offset(10).build().unwrap())
  // 三伏
  mgr = mgr.update("入伏", Event::builder().term_heaven_stem(12, 6, 20).build().unwrap())
  mgr = mgr.update("中伏", Event::builder().term_heaven_stem(12, 6, 30).build().unwrap())
  mgr = mgr.update("末伏", Event::builder().term_heaven_stem(15, 6, 0).build().unwrap())
  // 梅雨
  mgr = mgr.update("入梅", Event::builder().term_heaven_stem(11, 2, 0).build().unwrap())
  mgr = mgr.update("出梅", Event::builder().term_earth_branch(13, 7, 0).build().unwrap())
  // 生日
  mgr = mgr.update("公历生日", Event::builder().solar_day(2, 29, -1).start_year(2004).build().unwrap())
  mgr = mgr.update("农历生日", Event::builder().lunar_day(4, 21, 0).start_year(1986).build().unwrap())
  mgr
}

///|
test "event_0" {
  let mgr = init_events()
  // 公历生日：SolarDay(2,29,-1).StartYear(2004)，按名查询后验证日期
  let gongli = must_from_name(mgr, "公历生日")
  match gongli.get_solar_day(2008) {
    Some(d) => expect_eq(d.to_string(), "2008年2月29日", "公历生日.GetSolarDay(2008)")
    None => expect_true(false, "公历生日.GetSolarDay(2008) 不应为 nil")
  }
  // 2005 年没有 2 月 29，按设置应倒推 1 天
  match gongli.get_solar_day(2005) {
    Some(d) => expect_eq(d.to_string(), "2005年2月28日", "公历生日.GetSolarDay(2005)")
    None => expect_true(false, "公历生日.GetSolarDay(2005) 不应为 nil")
  }
  // 农历生日：LunarDay(4,21,0).StartYear(1986)
  let nongli = must_from_name(mgr, "农历生日")
  match nongli.get_solar_day(2026) {
    Some(d) => expect_eq(d.to_string(), "2026年6月6日", "农历生日.GetSolarDay(2026)")
    None => expect_true(false, "农历生日.GetSolarDay(2026) 不应为 nil")
  }
}

///|
test "event_1" {
  let mgr = init_events()
  // 公历生日 StartYear(2004)：1985 早于起始年，应返回 nil（对应 Go Test1）
  let gongli = must_from_name(mgr, "公历生日")
  match gongli.get_solar_day(1985) {
    None => expect_true(true, "公历生日.GetSolarDay(1985) 应为 nil")
    Some(_) => expect_true(false, "公历生日.GetSolarDay(1985) 应为 nil")
  }
}

///|
test "event_2" {
  let mgr = init_events()
  // 国际消费者权益日：SolarDay(3,15,0).StartYear(1983)
  let e = must_from_name(mgr, "国际消费者权益日")
  // GetName 应为注册名（语义与 Go 一致）
  expect_eq(e.get_name(), "国际消费者权益日", "e.GetName() 应为注册名")
  match e.get_solar_day(2026) {
    Some(d) => expect_eq(d.to_string(), "2026年3月15日", "国际消费者权益日.GetSolarDay(2026)")
    None => expect_true(false, "国际消费者权益日.GetSolarDay(2026) 不应为 nil")
  }
  // FromSolarDay：2026-03-15 当天应恰好只发生该事件（对应 Go 断言 [国际消费者权益日]）
  let d = SolarDay::from_ymd(2026, 3, 15).unwrap()
  let events = mgr.from_solar_day(d)
  expect_eq(events.length(), 1, "FromSolarDay(2026-03-15).length 应为 1")
  if events.length() > 0 {
    expect_eq(events[0].get_name(), "国际消费者权益日", "FromSolarDay(2026-03-15)[0] 名称")
  }
}

///|
test "event_3" {
  let mgr = init_events()
  // 全国中小学生安全教育日：SolarWeek(3,-1,1).StartYear(1996)
  let e = must_from_name(mgr, "全国中小学生安全教育日")
  expect_eq(e.get_name(), "全国中小学生安全教育日", "e.GetName() 应为注册名")
  let cases : Array[(Int, String)] = [
    (2008, "2008年3月31日"),
    (2015, "2015年3月30日"),
    (2018, "2018年3月26日"),
    (2019, "2019年3月25日"),
    (2021, "2021年3月29日"),
    (2023, "2023年3月27日"),
    (2024, "2024年3月25日"),
    (2025, "2025年3月31日"),
  ]
  for i = 0; i < cases.length(); i = i + 1 {
    let (year, want) = cases[i]
    match e.get_solar_day(year) {
      Some(d) =>
        expect_eq(d.to_string(), want, "全国中小学生安全教育日.GetSolarDay(\{year})")
      None => expect_true(false, "全国中小学生安全教育日.GetSolarDay(\{year}) 不应为 nil")
    }
  }
}

///|
test "event_all_coverage" {
  // 注册表完整性（对应 Go initEvents 的 44 个注册事件）：
  // 全部可按名查询且名称一致，all() 枚举数与注册数一致
  let mgr = init_events()
  let names : Array[String] = [
    // 公历现代节日（10）
    "公历现代节日:元旦",
    "公历现代节日:妇女节",
    "公历现代节日:植树节",
    "公历现代节日:劳动节",
    "公历现代节日:青年节",
    "公历现代节日:儿童节",
    "公历现代节日:建党节",
    "公历现代节日:建军节",
    "公历现代节日:教师节",
    "公历现代节日:国庆节",
    // 农历传统节日（13）
    "农历传统节日:春节",
    "农历传统节日:元宵节",
    "农历传统节日:龙头节",
    "农历传统节日:上巳节",
    "农历传统节日:清明节",
    "农历传统节日:端午节",
    "农历传统节日:七夕节",
    "农历传统节日:中元节",
    "农历传统节日:中秋节",
    "农历传统节日:重阳节",
    "农历传统节日:冬至节",
    "农历传统节日:腊八节",
    "农历传统节日:除夕",
    // 其他节日（7）
    "情人节",
    "国际消费者权益日",
    "愚人节",
    "万圣夜",
    "万圣节",
    "平安夜",
    "圣诞节",
    // 周类（4）
    "全国中小学生安全教育日",
    "母亲节",
    "父亲节",
    "感恩节",
    // 特殊节日（3）
    "寒食节",
    "春社",
    "秋社",
    // 三伏（3）
    "入伏",
    "中伏",
    "末伏",
    // 梅雨（2）
    "入梅",
    "出梅",
    // 生日（2）
    "公历生日",
    "农历生日",
  ]
  expect_eq(names.length(), 44, "注册事件名数量应为 44")
  expect_eq(mgr.all().length(), 44, "all() 枚举数应为 44")
  for i = 0; i < names.length(); i = i + 1 {
    match mgr.from_name(names[i]) {
      Some(e) => expect_eq(e.get_name(), names[i], "from_name(\{names[i]}) 名称一致")
      None => expect_true(false, "from_name(\{names[i]}) 不应为 None")
    }
  }
}

///|
test "event_2026_events" {
  // 对应 Go Test2 的调试打印（2026 年所有事件）：
  // 不用 println（会污染 moon test stdout、干扰 xref 排序对拍），
  // 改为构建字符串数组并逐行断言，黄金值取自 Go 实跑输出（go test -run Test2）。
  // 同时验证：无 StartYear 的事件 start_year 默认为 0（data 第 6-8 位为 '0'），任意年份均可计算日期。
  let mgr = init_events()
  let all = mgr.all()
  let want : Array[String] = [
    "公历现代节日:元旦 = 2026年1月1日",
    "公历现代节日:妇女节 = 2026年3月8日",
    "公历现代节日:植树节 = 2026年3月12日",
    "公历现代节日:劳动节 = 2026年5月1日",
    "公历现代节日:青年节 = 2026年5月4日",
    "公历现代节日:儿童节 = 2026年6月1日",
    "公历现代节日:建党节 = 2026年7月1日",
    "公历现代节日:建军节 = 2026年8月1日",
    "公历现代节日:教师节 = 2026年9月10日",
    "公历现代节日:国庆节 = 2026年10月1日",
    "农历传统节日:春节 = 2026年2月17日",
    "农历传统节日:元宵节 = 2026年3月3日",
    "农历传统节日:龙头节 = 2026年3月20日",
    "农历传统节日:上巳节 = 2026年4月19日",
    "农历传统节日:清明节 = 2026年4月5日",
    "农历传统节日:端午节 = 2026年6月19日",
    "农历传统节日:七夕节 = 2026年8月19日",
    "农历传统节日:中元节 = 2026年8月27日",
    "农历传统节日:中秋节 = 2026年9月25日",
    "农历传统节日:重阳节 = 2026年10月18日",
    "农历传统节日:冬至节 = 2026年12月22日",
    "农历传统节日:腊八节 = 2027年1月15日",
    "农历传统节日:除夕 = 2027年2月5日",
    "情人节 = 2026年2月14日",
    "国际消费者权益日 = 2026年3月15日",
    "愚人节 = 2026年4月1日",
    "万圣夜 = 2026年10月31日",
    "万圣节 = 2026年11月1日",
    "平安夜 = 2026年12月24日",
    "圣诞节 = 2026年12月25日",
    "全国中小学生安全教育日 = 2026年3月30日",
    "母亲节 = 2026年5月10日",
    "父亲节 = 2026年6月21日",
    "感恩节 = 2026年11月26日",
    "寒食节 = 2026年4月4日",
    "春社 = 2026年3月25日",
    "秋社 = 2026年9月21日",
    "入伏 = 2026年7月15日",
    "中伏 = 2026年7月25日",
    "末伏 = 2026年8月14日",
    "入梅 = 2026年6月11日",
    "出梅 = 2026年7月8日",
    "公历生日 = 2026年2月28日",
    "农历生日 = 2026年6月6日",
  ]
  expect_eq(all.length(), want.length(), "2026 年事件行数应为 44")
  for i = 0; i < want.length(); i = i + 1 {
    let line = match all[i].get_solar_day(2026) {
      Some(sd) => "\{all[i].get_name()} = \{sd.to_string()}"
      None => "\{all[i].get_name()} = 无对应日期"
    }
    expect_eq(line, want[i], "2026 事件第 \{i} 行")
  }
}

///|
test "event_value" {
  // 方案 C 形态：值类型 EventManager 的增删查改（显式状态传递，无全局态）
  let chunjie = Event::builder().lunar_day(1, 1, 0).build().unwrap()
  let yuanxiao = Event::builder().lunar_day(1, 15, 0).build().unwrap()
  let mut em = EventManager::new()
  em = em.update("春节", chunjie)
  em = em.update("元宵节", yuanxiao)
  // from_name
  match em.from_name("春节") {
    Some(e) => expect_eq(e.get_name(), "春节", "value.from_name(春节).name")
    None => expect_true(false, "value.from_name(春节) 不应为 None")
  }
  // all
  expect_eq(em.all().length(), 2, "value.all().length 应为 2")
  // 同名覆盖（update 语义）
  em = em.update("春节", yuanxiao)
  expect_eq(em.all().length(), 2, "覆盖后 all().length 仍为 2")
  match em.from_name("春节") {
    Some(e) => expect_eq(e.get_data(), yuanxiao.get_data(), "覆盖后 data 更新")
    None => expect_true(false, "覆盖后 from_name(春节) 不应为 None")
  }
  // remove
  em = em.remove("元宵节")
  expect_eq(em.all().length(), 1, "remove 后 all().length 应为 1")
  match em.from_name("元宵节") {
    None => expect_true(true, "remove 后 from_name(元宵节) 应为 None")
    Some(_) => expect_true(false, "remove 后 from_name(元宵节) 应为 None")
  }
  // from_solar_day（值形态）：start_year 默认为 0（无 StartYear 事件任意年份可算日期），
  // 2008-02-29 命中公历生日（2004 起）
  let gongli = Event::builder().solar_day(2, 29, -1).start_year(2004).build().unwrap()
  let mut em2 = EventManager::new()
  em2 = em2.update("公历生日", gongli)
  let sd = SolarDay::from_ymd(2008, 2, 29).unwrap()
  let es = em2.from_solar_day(sd)
  expect_eq(es.length(), 1, "value.from_solar_day(2008-02-29).length 应为 1")
  if es.length() > 0 {
    expect_eq(es[0].get_name(), "公历生日", "value.from_solar_day(2008-02-29)[0] 名称")
  }
}
