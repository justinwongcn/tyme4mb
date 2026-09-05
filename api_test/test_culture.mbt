// 包外 API 测试：天干、地支、五行、九星、二十八宿等轮回类型
// 验证 api.md 中所有文化概念相关接口可从包外调用

///|
test "HeavenStem" {
  let hs = @tyme.HeavenStem::from_name("丙").unwrap()
  let _ = hs.get_element()
  let _ = hs.get_yin_yang()
  let _ = hs.get_direction()
  let _ = hs.get_joy_direction()
  let _ = hs.get_yang_direction()
  let _ = hs.get_yin_direction()
  let _ = hs.get_wealth_direction()
  let _ = hs.get_mascot_direction()
  let _ = hs.get_peng_zu_heaven_stem()
  let me = @tyme.HeavenStem::from_name("癸").unwrap()
  let _ = me.get_ten_star(@tyme.HeavenStem::from_name("丙").unwrap())
  let _ = me.get_terrain(@tyme.EarthBranch::from_name("寅").unwrap())
  let hs2 = @tyme.HeavenStem::from_name("甲").unwrap()
  let _ = hs2.get_combine()
  let _ = hs2.combine(@tyme.HeavenStem::from_name("己").unwrap())
  let _ = hs.get_size()
  let _ = hs.get_index()
  let _ = hs.steps_to(0)
  let _ = hs.steps_back_to(0)
  let _ = hs.steps_close_to(0)
  let _ = hs.equals(hs.next(0))
  let _ = hs.get_name()
  let _ = hs.to_string()
}

///|
test "EarthBranch" {
  let eb = @tyme.EarthBranch::from_name("寅").unwrap()
  let _ = eb.get_element()
  let _ = eb.get_yin_yang()
  let _ = eb.get_direction()
  let _ = eb.get_peng_zu_earth_branch()
  let _ = eb.get_zodiac()
  let _ = eb.get_opposite()
  let _ = eb.get_combine()
  let _ = eb.get_harm()
  let _ = eb.get_po()
  let _ = eb.get_jue()
  let _ = eb.get_xing()
  let _ = eb.get_an_he()
  let _ = eb.get_san_he_element()
  let _ = eb.get_san_hui_element()
  let _ = eb.get_san_hui_direction()
  let _ = eb.combine(@tyme.EarthBranch::from_name("丑").unwrap())
  let _ = eb.get_ominous()
  let _ = eb.get_hide_heaven_stem_main()
  let _ = eb.get_hide_heaven_stem_middle()
  let _ = eb.get_hide_heaven_stem_residual()
  let _ = eb.get_hide_heaven_stems()
  let _ = eb.get_size()
  let _ = eb.get_index()
  let _ = eb.steps_to(0)
  let _ = eb.steps_back_to(0)
  let _ = eb.steps_close_to(0)
  let _ = eb.equals(eb.next(0))
  let _ = eb.get_name()
  let _ = eb.to_string()
}

///|
test "Element" {
  let e = @tyme.Element::from_name("火").unwrap()
  let _ = e.get_reinforce()
  let _ = e.get_restrain()
  let e2 = @tyme.Element::from_name("土").unwrap()
  let _ = e2.get_reinforced()
  let e3 = @tyme.Element::from_name("木").unwrap()
  let _ = e3.get_restrained()
  let _ = e.get_direction()
  let _ = e.get_name()
  let _ = e.to_string()
}

///|
test "Zodiac" {
  let z = @tyme.Zodiac::from_name("牛").unwrap()
  let _ = z.get_name()
  let _ = z.to_string()
  let eb = @tyme.EarthBranch::from_name("子").unwrap()
  let z2 = eb.get_zodiac()
  let _ = z2.get_name()
}

///|
test "Direction" {
  let d = @tyme.Direction::from_name("北").unwrap()
  let _ = d.get_land()
  let _ = d.get_element()
  let _ = d.get_name()
  let _ = d.to_string()
}

///|
test "Land" {
  let l = @tyme.Land::from_name("玄天").unwrap()
  let _ = l.get_direction()
  let _ = l.get_name()
  let _ = l.to_string()
}

///|
test "Zone" {
  let z = @tyme.Zone::from_name("东").unwrap()
  let _ = z.get_direction()
  let _ = z.get_beast()
  let _ = z.get_name()
  let _ = z.to_string()
}

///|
test "Beast" {
  let b = @tyme.Beast::from_name("青龙").unwrap()
  let _ = b.get_zone()
  let _ = b.get_name()
  let _ = b.to_string()
}

///|
test "Animal" {
  let a = @tyme.Animal::from_index(0)
  let _ = a.get_size()
  let _ = a.get_index()
  let _ = a.steps_to(0)
  let _ = a.steps_back_to(0)
  let _ = a.steps_close_to(0)
  let _ = a.equals(a.next(0))
  let _ = a.get_name()
  let _ = a.to_string()
  let a2 = @tyme.Animal::from_name("蛟").unwrap()
  let _ = a2.get_name()
}

///|
test "NineStar" {
  let ns = @tyme.LunarYear::from_year(2024).unwrap().get_nine_star()
  let _ = ns.get_color()
  let _ = ns.get_element()
  let _ = ns.get_direction()
  let _ = ns.get_dipper()
  let _ = ns.get_name()
  let _ = ns.to_string()
  let ns2 = @tyme.NineStar::from_index(0)
  let _ = ns2.get_name()
  let ns3 = @tyme.NineStar::from_name("三").unwrap()
  let _ = ns3.get_name()
}

///|
test "Dipper" {
  let d = @tyme.LunarYear::from_year(2024).unwrap().get_nine_star().get_dipper()
  let _ = d.get_name()
  let _ = d.to_string()
  let d2 = @tyme.Dipper::from_index(0)
  let _ = d2.get_name()
}

///|
test "TwentyEightStar" {
  let d = @tyme.LunarDay::from_ymd(2020, 4, 13).unwrap()
  let star = d.get_twenty_eight_star()
  let _ = star.get_seven_star()
  let _ = star.get_land()
  let _ = star.get_zone()
  let _ = star.get_animal()
  let _ = star.get_luck()
  let _ = star.get_name()
  let _ = star.to_string()
}

///|
test "SevenStar" {
  let w = @tyme.Week::from_index(2)
  let sp = w.get_seven_star()
  let _ = sp.get_name()
  let _ = sp.get_week()
  let _ = sp.to_string()
  let sp2 = @tyme.SevenStar::from_name("土").unwrap()
  let _ = sp2.get_week()
}

///|
test "Week" {
  let w = @tyme.Week::from_index(0)
  let _ = w.get_size()
  let _ = w.get_index()
  let _ = w.steps_to(0)
  let _ = w.steps_back_to(0)
  let _ = w.steps_close_to(0)
  let _ = w.equals(w.next(0))
  let _ = w.get_name()
  let _ = w.to_string()
  let w2 = @tyme.Week::from_name("日").unwrap()
  let _ = w2.get_name()
  let w3 = w.next(1)
  let _ = w3.get_name()
}

///|
test "Luck" {
  let l = @tyme.Luck::from_name("吉").unwrap()
  let _ = l.get_name()
  let _ = l.to_string()
}

///|
test "Ecliptic" {
  let e = @tyme.Ecliptic::from_name("黄道").unwrap()
  let _ = e.get_luck()
  let _ = e.get_name()
  let _ = e.to_string()
}

///|
test "TwelveStar" {
  let ts = @tyme.TwelveStar::from_name("青龙").unwrap()
  let _ = ts.get_ecliptic()
  let _ = ts.get_name()
  let _ = ts.to_string()
}

///|
test "Duty" {
  let d = @tyme.LunarDay::from_ymd(2021, 1, 1).unwrap().get_duty()
  let _ = d.get_name()
  let _ = d.to_string()
  let d2 = @tyme.Duty::from_name("建").unwrap()
  let _ = d2.get_name()
}

///|
test "TenStar" {
  let ts = @tyme.HeavenStem::from_name("甲")
    .unwrap()
    .get_ten_star(@tyme.HeavenStem::from_name("甲").unwrap())
  let _ = ts.get_name()
  let _ = ts.to_string()
}

///|
test "Terrain" {
  let t = @tyme.HeavenStem::from_name("癸")
    .unwrap()
    .get_terrain(@tyme.EarthBranch::from_name("寅").unwrap())
  let _ = t.get_name()
  let _ = t.to_string()
}

///|
test "Sound" {
  let sc = @tyme.SixtyCycle::from_index(1)
  let s = sc.get_sound()
  let _ = s.get_name()
  let _ = s.to_string()
}

///|
test "PengZu" {
  let pz = @tyme.SixtyCycle::from_name("甲子").unwrap().get_peng_zu()
  let _ = pz.get_peng_zu_heaven_stem()
  let _ = pz.get_peng_zu_earth_branch()
  let phs = @tyme.HeavenStem::from_name("甲")
    .unwrap()
    .get_peng_zu_heaven_stem()
  let _ = phs.get_name()
  let peb = @tyme.EarthBranch::from_name("子")
    .unwrap()
    .get_peng_zu_earth_branch()
  let _ = peb.get_name()
}

///|
test "Ten" {
  let sc = @tyme.SixtyCycle::from_name("乙卯").unwrap()
  let t = sc.get_ten()
  let _ = t.get_name()
  let _ = t.to_string()
}

///|
test "Twenty" {
  let t = @tyme.LunarYear::from_year(1863).unwrap().get_twenty()
  let _ = t.get_sixty()
  let _ = t.get_name()
  let _ = t.to_string()
}

///|
test "Sixty" {
  let t = @tyme.LunarYear::from_year(1863).unwrap().get_twenty().get_sixty()
  let _ = t.get_name()
  let _ = t.to_string()
  let s = @tyme.Sixty::from_name("上元").unwrap()
  let _ = s.get_name()
}

///|
test "SixStar" {
  let ss = @tyme.SolarDay::from_ymd(2020, 4, 10)
    .unwrap()
    .get_lunar_day()
    .get_six_star()
  let _ = ss.get_name()
  let _ = ss.to_string()
}

///|
test "MinorRen" {
  let mr = @tyme.LunarMonth::from_ym(1991, 3).unwrap().get_minor_ren()
  let _ = mr.get_luck()
  let _ = mr.get_element()
  let _ = mr.get_name()
  let _ = mr.to_string()
  let mr2 = @tyme.LunarDay::from_ymd(2024, 3, 5).unwrap().get_minor_ren()
  let _ = mr2.get_name()
  let mr3 = @tyme.LunarHour::from_ymd_hms(2024, 9, 7, 10, 0, 0)
    .unwrap()
    .get_minor_ren()
  let _ = mr3.get_name()
}

///|
test "God" {
  let d = @tyme.SolarDay::from_ymd(1954, 7, 16).unwrap().get_lunar_day()
  let gods = d.get_gods().unwrap()
  let _ = gods.length()
  let g = @tyme.God::from_name("天德").unwrap()
  let _ = g.get_name()
}

///|
test "Taboo" {
  let d = @tyme.SolarDay::from_ymd(2024, 6, 26).unwrap().get_lunar_day()
  let recs = d.get_recommends().unwrap()
  let _ = recs.length()
  let avoids = d.get_avoids().unwrap()
  let _ = avoids.length()
  let h = @tyme.SolarTime::from_ymdhms(2024, 4, 22, 0, 0, 0)
    .unwrap()
    .get_lunar_hour()
  let hrecs = h.get_recommends().unwrap()
  let _ = hrecs.length()
  let havoids = h.get_avoids().unwrap()
  let _ = havoids.length()
}

///|
test "HideHeavenStem" {
  let eb = @tyme.EarthBranch::from_name("寅").unwrap()
  let hhs = eb.get_hide_heaven_stems()
  let _ = hhs.length()
  for hhs_item in hhs {
    let _ = hhs_item.get_heaven_stem().get_name()
    let _ = hhs_item.get_type().get_name()
  }
  let hsd = @tyme.SolarDay::from_ymd(2024, 12, 4)
    .unwrap()
    .get_hide_heaven_stem_day()
  let hs = hsd.get_hide_heaven_stem()
  let _ = hs.get_heaven_stem().get_name()
  let _ = hs.get_type().get_name()
  let _ = hsd.get_day_index()
}

///|
test "HideHeavenStemType" {
  let t = @tyme.HideHeavenStemType::from_code(0)
  let _ = t.get_name()
  let _ = t.get_code()
}

///|
test "FetusDay" {
  let fd = @tyme.LunarDay::from_ymd(2024, 4, 22).unwrap().get_fetus_day()
  let _ = fd.get_side()
  let _ = fd.get_direction()
  let _ = fd.get_fetus_heaven_stem()
  let _ = fd.get_fetus_earth_branch()
  let _ = fd.get_name()
  let _ = fd.to_string()
}

///|
test "FetusMonth" {
  let lm = @tyme.LunarMonth::from_ym(2024, 4).unwrap()
  let fm = lm.get_fetus().unwrap()
  let _ = fm.get_name()
  let _ = fm.to_string()
}

///|
test "KitchenGodSteed" {
  let kgs = @tyme.KitchenGodSteed::from_lunar_year(2017)
  let _ = kgs.get_mouse()
  let _ = kgs.get_grass()
  let _ = kgs.get_cattle()
  let _ = kgs.get_flower()
  let _ = kgs.get_dragon()
  let _ = kgs.get_horse()
  let _ = kgs.get_chicken()
  let _ = kgs.get_silkworm()
  let _ = kgs.get_pig()
  let _ = kgs.get_field()
  let _ = kgs.get_cake()
  let _ = kgs.get_gold()
  let _ = kgs.get_people_cakes()
  let _ = kgs.get_people_hoes()
}

///|
test "Dog" {
  let d = @tyme.Dog::from_index(0)
  let _ = d.get_name()
  let _ = d.to_string()
  let d2 = @tyme.Dog::from_name("初伏").unwrap()
  let _ = d2.get_name()
}

///|
test "DogDay" {
  let sd = @tyme.SolarDay::from_ymd(2012, 8, 8).unwrap()
  let dd = sd.get_dog_day()
  match dd {
    Some(d) => {
      let dog = d.get_dog()
      let _ = dog.get_name()
      let _ = d.get_day_index()
    }
    None => ()
  }
}

///|
test "Nine" {
  let n = @tyme.Nine::from_index(0)
  let _ = n.get_name()
  let _ = n.to_string()
  let n2 = @tyme.Nine::from_name("一九").unwrap()
  let _ = n2.get_name()
}

///|
test "NineDay" {
  let sd = @tyme.SolarDay::from_ymd(2020, 12, 22).unwrap()
  let nd = sd.get_nine_day()
  match nd {
    Some(d) => {
      let nine = d.get_nine()
      let _ = nine.get_name()
      let _ = d.get_day_index()
    }
    None => ()
  }
}

///|
test "PlumRain" {
  let pr = @tyme.PlumRain::from_index(0)
  let _ = pr.get_name()
  let _ = pr.to_string()
  let pr2 = @tyme.PlumRain::from_name("入梅").unwrap()
  let _ = pr2.get_name()
}

///|
test "PlumRainDay" {
  let sd = @tyme.SolarDay::from_ymd(2024, 6, 11).unwrap()
  let prd = sd.get_plum_rain_day()
  match prd {
    Some(d) => {
      let pr = d.get_plum_rain()
      let _ = pr.get_name()
      let _ = d.get_day_index()
    }
    None => ()
  }
}

///|
test "Phenology" {
  let sd = @tyme.SolarDay::from_ymd(2020, 4, 23).unwrap()
  let pd = sd.get_phenology_day()
  let _ = pd.get_day_index()
  let p = pd.get_phenology()
  let _ = p.get_three_phenology()
  let _ = p.get_julian_day()
  let _ = p.get_name()
  let p2 = @tyme.Phenology::from_index(2026, 1)
  let _ = p2.get_name()
  let p3 = @tyme.Phenology::from_name(2026, "麋角解").unwrap()
  let _ = p3.get_name()
  let st = @tyme.SolarTime::from_ymdhms(2025, 12, 26, 20, 49, 36).unwrap()
  let _ = st.get_phenology()
}

///|
test "ThreePhenology" {
  let tp = @tyme.SolarDay::from_ymd(2020, 4, 23)
    .unwrap()
    .get_phenology_day()
    .get_phenology()
    .get_three_phenology()
  let _ = tp.get_name()
  let _ = tp.to_string()
}
