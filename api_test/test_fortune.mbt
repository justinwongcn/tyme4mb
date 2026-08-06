// 包外 API 测试：童限、大运、小运、性别、阴阳、内外
// 验证 api.md 中所有八字排盘相关接口可从包外调用

///|
test "Gender" {
  let g = @tyme.Gender::from_code(1)
  let _ = g.get_name()
  let _ = g.get_code()
  let g2 = @tyme.Gender::from_code(0)
  let _ = g2.get_name()
  let _ = g2.get_code()
}

///|
test "YinYang" {
  let yy = @tyme.YinYang::from_code(0)
  let _ = yy.get_name()
  let _ = yy.get_code()
  let yy2 = @tyme.YinYang::from_code(1)
  let _ = yy2.get_name()
  let _ = yy2.get_code()
}

///|
test "Side" {
  let s = @tyme.Side::from_code(0)
  let _ = s.get_name()
  let _ = s.get_code()
  let s2 = @tyme.Side::from_code(1)
  let _ = s2.get_name()
  let _ = s2.get_code()
}

///|
test "ChildLimit" {
  let cl = @tyme.ChildLimit::from_solar_time(
    @tyme.SolarTime::from_ymdhms(1992, 2, 2, 12, 0, 0).unwrap(),
    @tyme.Gender::Man,
  )
  let _ = cl.get_eight_char()
  let _ = cl.get_gender()
  let _ = cl.is_forward()
  let _ = cl.get_year_count()
  let _ = cl.get_month_count()
  let _ = cl.get_day_count()
  let _ = cl.get_hour_count()
  let _ = cl.get_minute_count()
  let _ = cl.get_start_time()
  let _ = cl.get_end_time()
  let _ = cl.get_start_decade_fortune()
  let _ = cl.get_start_fortune()
  // 额外公共方法
  let _ = cl.get_start_age()
  let _ = cl.get_end_age()
  let _ = cl.get_start_sixty_cycle_year()
  let _ = cl.get_end_sixty_cycle_year()
  let _ = cl.get_end_lunar_year()
  let _ = cl.get_decade_fortune()
}

///|
test "DecadeFortune" {
  let cl = @tyme.ChildLimit::from_solar_time(
    @tyme.SolarTime::from_ymdhms(1992, 2, 2, 12, 0, 0).unwrap(),
    @tyme.Gender::Man,
  )
  let df = cl.get_start_decade_fortune()
  let _ = df.get_start_age()
  let _ = df.get_end_age()
  let _ = df.get_start_lunar_year()
  let _ = df.get_end_lunar_year()
  let _ = df.get_start_sixty_cycle_year()
  let _ = df.get_end_sixty_cycle_year()
  let _ = df.get_sixty_cycle()
  let _ = df.get_start_fortune()
  let _ = df.get_name()
  let _ = df.to_string()
  // next 方法（Tyme trait）
  let df2 = df.next(1)
  let _ = df2.get_name()
  let df3 = df.next(-1)
  let _ = df3.get_name()
}

///|
test "Fortune" {
  let cl = @tyme.ChildLimit::from_solar_time(
    @tyme.SolarTime::from_ymdhms(1992, 2, 2, 12, 0, 0).unwrap(),
    @tyme.Gender::Man,
  )
  let f = cl.get_start_fortune()
  let _ = f.get_age()
  let _ = f.get_lunar_year()
  let _ = f.get_sixty_cycle_year()
  let _ = f.get_sixty_cycle()
  let _ = f.get_name()
  let _ = f.to_string()
  // next 方法（Tyme trait）
  let f2 = f.next(1)
  let _ = f2.get_name()
  let f3 = f.next(-1)
  let _ = f3.get_name()
}
