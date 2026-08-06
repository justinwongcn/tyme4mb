// 包外 API 测试：藏历、回历、节气、月相、星座
// 验证 api.md 中所有历法相关接口可从包外调用

///|
test "RabByungYear" {
  let y = @tyme.RabByungYear::from_year(1950).unwrap()
  let _ = y.get_year()
  let _ = y.get_leap_month()
  let _ = y.get_month_count()
  let _ = y.get_rab_byung_index()
  let _ = y.get_sixty_cycle()
  let _ = y.get_element()
  let _ = y.get_zodiac()
  let _ = y.get_solar_year()
  let _ = y.get_first_month()
  let _ = y.get_months()
  let _ = y.get_name()
  let _ = y.to_string()
  let sc = @tyme.SixtyCycle::from_name("丁卯").unwrap()
  let y2 = @tyme.RabByungYear::from_sixty_cycle(0, sc).unwrap()
  let _ = y2.get_year()
  let e = @tyme.RabByungElement::from_name("火").unwrap()
  let z = @tyme.Zodiac::from_name("兔").unwrap()
  let y3 = @tyme.RabByungYear::from_element_zodiac(0, e, z).unwrap()
  let _ = y3.get_year()
  let sy = @tyme.SolarYear::from_year(1950).unwrap()
  let y4 = sy.get_rab_byung_year().unwrap()
  let _ = y4.get_year()
}

///|
test "RabByungMonth" {
  let m = @tyme.RabByungMonth::from_ym(1950, 12).unwrap()
  let _ = m.get_rab_byung_year()
  let _ = m.get_month()
  let _ = m.get_month_with_leap()
  let _ = m.is_leap()
  let _ = m.get_alias()
  let _ = m.get_index_in_year()
  let _ = m.get_day_count()
  let _ = m.get_leap_days()
  let _ = m.get_miss_days()
  let _ = m.get_first_day()
  let _ = m.get_days()
  let _ = m.get_name()
  let _ = m.to_string()
  let m2 = @tyme.RabByungMonth::from_ym(2043, -5).unwrap()
  let _ = m2.is_leap()
  let _ = m2.get_month_with_leap()
  let _ = m2.get_alias()
}

///|
test "RabByungDay" {
  let d = @tyme.RabByungDay::from_ymd(1950, 12, 1).unwrap()
  let _ = d.get_rab_byung_month()
  let _ = d.get_day()
  let d2 = @tyme.RabByungDay::from_ymd(1950, 12, -16).unwrap()
  let _ = d2.get_day()
  let _ = d2.get_day_with_leap()
  let _ = d2.is_leap()
  let _ = d2.subtract(@tyme.RabByungDay::from_ymd(1950, 12, 16).unwrap())
  let _ = d2.get_solar_day()
  let sd = @tyme.SolarDay::from_ymd(1951, 1, 8).unwrap()
  let d3 = sd.get_rab_byung_day().unwrap()
  let _ = d3.get_day()
  let _ = d.get_name()
  let _ = d.to_string()
}

///|
test "RabByungElement" {
  let e = @tyme.RabByungElement::from_name("火").unwrap()
  let _ = e.get_element()
  let _ = e.get_reinforce()
  let _ = e.get_reinforced()
  let _ = e.get_restrain()
  let _ = e.get_restrained()
  let _ = e.get_name()
  let _ = e.to_string()
}

///|
test "HijriYear" {
  let y = @tyme.HijriYear::from_year(1).unwrap()
  let _ = y.get_year()
  let _ = y.get_day_count()
  let _ = y.is_leap()
  let _ = y.get_first_month()
  let _ = y.get_months()
  let _ = y.get_name()
  let _ = y.to_string()
  let y2 = @tyme.HijriYear::from_year(2).unwrap()
  let _ = y2.is_leap()
  let _ = y2.get_day_count()
}

///|
test "HijriMonth" {
  let m = @tyme.HijriMonth::from_ym(1, 1).unwrap()
  let _ = m.get_hijri_year()
  let _ = m.get_month()
  let _ = m.get_index_in_year()
  let _ = m.get_day_count()
  let _ = m.get_first_day()
  let _ = m.get_days()
  let _ = m.get_name()
  let _ = m.to_string()
}

///|
test "HijriDay" {
  let d = @tyme.HijriDay::from_ymd(1, 1, 1).unwrap()
  let _ = d.get_hijri_month()
  let _ = d.get_day()
  let _ = d.get_julian_day()
  let _ = d.get_solar_day()
  let _ = d.is_before(@tyme.HijriDay::from_ymd(1, 1, 2).unwrap())
  let _ = d.is_after(@tyme.HijriDay::from_ymd(1, 1, 2).unwrap())
  let _ = d.subtract(@tyme.HijriDay::from_ymd(1, 1, 2).unwrap())
  let _ = d.get_index_in_year()
  let _ = d.get_name()
  let _ = d.to_string()
  let sd = @tyme.SolarDay::from_ymd(622, 7, 16).unwrap()
  let d2 = sd.get_hijri_day()
  let _ = d2.get_day()
}

///|
test "SolarTerm" {
  let t = @tyme.SolarTerm::from_index(2013, 0)
  let _ = t.is_jie()
  let _ = t.is_qi()
  let _ = t.get_julian_day()
  let _ = t.get_solar_day()
  let _ = t.get_name()
  let _ = t.to_string()
  let t2 = @tyme.SolarTerm::from_name(2013, "立春").unwrap()
  let _ = t2.get_solar_day()
  let sd = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap()
  let _ = sd.get_term()
  let td = sd.get_term_day()
  let _ = td.get_day_index()
  let _ = td.get_solar_term().get_name()
  let st = @tyme.SolarTime::from_ymdhms(2023, 1, 1, 13, 5, 20).unwrap()
  let _ = st.get_term()
}

///|
test "Phase" {
  let p = @tyme.LunarDay::from_ymd(2000, 1, 1).unwrap().get_phase()
  let _ = p.get_name()
  let p2 = @tyme.LunarDay::from_ymd(2000, 1, 2).unwrap().get_phase()
  let _ = p2.get_name()
  let sd = @tyme.SolarDay::from_ymd(2023, 9, 15).unwrap()
  let _ = sd.get_phase()
  let pd = @tyme.SolarDay::from_ymd(2023, 9, 15).unwrap().get_phase_day()
  let _ = pd.get_day_index()
  let _ = pd.get_phase().get_name()
  let st = @tyme.SolarTime::from_ymdhms(2025, 9, 22, 3, 54, 7).unwrap()
  let _ = st.get_phase()
  let p3 = @tyme.Phase::from_index(2025, 7, 6)
  let _ = p3.get_solar_day()
  let _ = p3.get_solar_time()
  let p4 = @tyme.Phase::from_name(2025, 7, "下弦月").unwrap()
  let _ = p4.get_solar_day()
  let _ = p4.get_solar_time()
  let p5 = p.next(1)
  let _ = p5.get_name()
}

///|
test "Constellation" {
  let sd = @tyme.SolarDay::from_ymd(2023, 1, 1).unwrap()
  let c = sd.get_constellation()
  let _ = c.get_name()
  let _ = c.to_string()
  let c2 = @tyme.Constellation::from_index(0)
  let _ = c2.get_name()
  let c3 = @tyme.Constellation::from_name("白羊").unwrap()
  let _ = c3.get_name()
}
