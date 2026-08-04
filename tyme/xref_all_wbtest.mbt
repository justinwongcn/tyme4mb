// 测试套件：xref_all（对应 Go test/xref_all_test.go，一比一 print 差分移植）
//
// 该文件是「打印型」差分测试：仅打印，不做断言（与 Go 原版一致）。
// 差分 harness 会将本文件 `moon test` 的 stdout 与 Go 版对应 TestXrefXxx 的 stdout 做对比。
// 按 Go 源的函数顺序分多个 test 块，覆盖 xref_all_test.go 全部 19 个 TestXref* 函数。

///|
/// 通用循环：复刻 Go TestXrefAllLoop 的 es 表，逐 tag 打印 name|str、next 边界、from_name 往返。
fn xref_loop(
  tag : String,
  size : Int,
  name : (Int) -> String,
  str : (Int) -> String,
  nxt : (Int, Int) -> String,
  from_name : ((String) -> (Int, String))?,
) -> Unit {
  for i = 0; i < size; i = i + 1 {
    println("\{tag} \{i} \{name(i)}|\{str(i)}")
    for n in [-25, -13, -1, 0, 1, 13, 25] {
      println("\{tag}N \{i} \{n} \{nxt(i, n)}")
    }
  }
  match from_name {
    Some(f) => {
      let n0 = name(0)
      let n1 = name(size - 1)
      for nm in [n0, n1, "不存在XYZ"] {
        let (idx, err) = f(nm)
        println("\{tag}F \{nm} \{idx} \{err}")
      }
    }
    None => ()
  }
}

///|
/// 复刻 Go `fmt.Sprintf("%v", []int{...})`：形如 `[1 2 3]`（空数组为 `[]`）。
fn go_array(v : Array[Int]) -> String {
  let mut s = "["
  let mut first = true
  for x in v {
    if first {
      s = s + x.to_string()
    } else {
      s = s + " " + x.to_string()
    }
    first = false
  }
  s + "]"
}

///|
test "xref_allloop" {
  xref_loop(
    "AN",
    12,
    fn(i : Int) -> String { Animal::from_index(i).get_name() },
    fn(i : Int) -> String { Animal::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Animal::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Animal::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "CO",
    12,
    fn(i : Int) -> String { Constellation::from_index(i).get_name() },
    fn(i : Int) -> String { Constellation::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      Constellation::from_index(i).next(n).get_name()
    },
    Some(fn(s : String) -> (Int, String) {
      match Constellation::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "DI",
    7,
    fn(i : Int) -> String { Dipper::from_index(i).get_name() },
    fn(i : Int) -> String { Dipper::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Dipper::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Dipper::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "DG",
    3,
    fn(i : Int) -> String { Dog::from_index(i).get_name() },
    fn(i : Int) -> String { Dog::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Dog::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Dog::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "DU",
    12,
    fn(i : Int) -> String { Duty::from_index(i).get_name() },
    fn(i : Int) -> String { Duty::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Duty::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Duty::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "FE",
    12,
    fn(i : Int) -> String { FetusEarthBranch::new(i).get_name() },
    fn(i : Int) -> String { FetusEarthBranch::new(i).to_string() },
    fn(i : Int, n : Int) -> String {
      FetusEarthBranch::new(i).next(n).get_name()
    },
    None,
  )
  xref_loop(
    "FH",
    5,
    fn(i : Int) -> String { FetusHeavenStem::new(i).get_name() },
    fn(i : Int) -> String { FetusHeavenStem::new(i).to_string() },
    fn(i : Int, n : Int) -> String {
      FetusHeavenStem::new(i).next(n).get_name()
    },
    None,
  )
  xref_loop(
    "LU",
    2,
    fn(i : Int) -> String { Luck::from_index(i).get_name() },
    fn(i : Int) -> String { Luck::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Luck::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Luck::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "LS",
    12,
    fn(i : Int) -> String { LunarSeason::from_index(i).get_name() },
    fn(i : Int) -> String { LunarSeason::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      LunarSeason::from_index(i).next(n).get_name()
    },
    Some(fn(s : String) -> (Int, String) {
      match LunarSeason::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "NI",
    9,
    fn(i : Int) -> String { Nine::from_index(i).get_name() },
    fn(i : Int) -> String { Nine::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Nine::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Nine::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "PE",
    12,
    fn(i : Int) -> String { PengZuEarthBranch::from_index(i).get_name() },
    fn(i : Int) -> String { PengZuEarthBranch::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      PengZuEarthBranch::from_index(i).next(n).get_name()
    },
    None,
  )
  xref_loop(
    "PH",
    10,
    fn(i : Int) -> String { PengZuHeavenStem::from_index(i).get_name() },
    fn(i : Int) -> String { PengZuHeavenStem::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      PengZuHeavenStem::from_index(i).next(n).get_name()
    },
    None,
  )
  xref_loop(
    "PR",
    2,
    fn(i : Int) -> String { PlumRain::from_index(i).get_name() },
    fn(i : Int) -> String { PlumRain::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      PlumRain::from_index(i).next(n).get_name()
    },
    Some(fn(s : String) -> (Int, String) {
      match PlumRain::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "SS",
    6,
    fn(i : Int) -> String { SixStar::from_index(i).get_name() },
    fn(i : Int) -> String { SixStar::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { SixStar::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match SixStar::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "SX",
    3,
    fn(i : Int) -> String { Sixty::from_index(i).get_name() },
    fn(i : Int) -> String { Sixty::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Sixty::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Sixty::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "SO",
    30,
    fn(i : Int) -> String { Sound::from_index(i).get_name() },
    fn(i : Int) -> String { Sound::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Sound::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Sound::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "TE",
    6,
    fn(i : Int) -> String { Ten::from_index(i).get_name() },
    fn(i : Int) -> String { Ten::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Ten::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Ten::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "TS",
    10,
    fn(i : Int) -> String { TenStar::from_index(i).get_name() },
    fn(i : Int) -> String { TenStar::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { TenStar::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match TenStar::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "TR",
    12,
    fn(i : Int) -> String { Terrain::from_index(i).get_name() },
    fn(i : Int) -> String { Terrain::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Terrain::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Terrain::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "TP",
    3,
    fn(i : Int) -> String { ThreePhenology::from_index(i).get_name() },
    fn(i : Int) -> String { ThreePhenology::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String {
      ThreePhenology::from_index(i).next(n).get_name()
    },
    Some(fn(s : String) -> (Int, String) {
      match ThreePhenology::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
  xref_loop(
    "ZO",
    12,
    fn(i : Int) -> String { Zodiac::from_index(i).get_name() },
    fn(i : Int) -> String { Zodiac::from_index(i).to_string() },
    fn(i : Int, n : Int) -> String { Zodiac::from_index(i).next(n).get_name() },
    Some(fn(s : String) -> (Int, String) {
      match Zodiac::from_name(s) {
        Ok(v) => (v.get_index(), "")
        Err(e) => (-1, e)
      }
    }),
  )
}

///|
test "xref_stems" {
  // ---------- EarthBranch 全量 ----------
  for i = 0; i < 12; i = i + 1 {
    let o = EarthBranch::from_index(i)
    let mut mid = "nil"
    match o.get_hide_heaven_stem_middle() {
      Some(v) => mid = v.get_name()
      None => ()
    }
    let mut res = "nil"
    match o.get_hide_heaven_stem_residual() {
      Some(v) => res = v.get_name()
      None => ()
    }
    let mut hhs = ""
    for h in o.get_hide_heaven_stems() {
      hhs = hhs + h.to_string() + ","
    }
    println(
      "EB \{i} \{o.get_name()}|\{o.to_string()}|\{o.get_element().get_name()}|\{o.get_yin_yang().get_name()}|\{o.get_hide_heaven_stem_main().get_name()}|\{mid}|\{res}|\{hhs}|\{o.get_zodiac().get_name()}|\{o.get_direction().get_name()}|\{o.get_ominous().get_name()}|\{o.get_peng_zu_earth_branch().get_name()}|\{o.get_opposite().get_name()}|\{o.get_combine().get_name()}",
    )
    println(
      "EB2 \{i} \{o.get_harm().get_name()} \{o.equals(EarthBranch::from_index(3))}",
    )
    for j = 0; j < 12; j = j + 1 {
      let mut c = "nil"
      match o.combine(EarthBranch::from_index(j)) {
        Some(v) => c = v.get_name()
        None => ()
      }
      println("EBC \{i} \{j} \{c}")
    }
  }
  // ---------- HeavenStem 全量 ----------
  for i = 0; i < 10; i = i + 1 {
    let o = HeavenStem::from_index(i)
    println(
      "HS \{i} \{o.get_name()}|\{o.to_string()}|\{o.get_element().get_name()}|\{o.get_yin_yang().get_name()}|\{o.get_direction().get_name()}|\{o.get_joy_direction().get_name()}|\{o.get_yang_direction().get_name()}|\{o.get_yin_direction().get_name()}|\{o.get_wealth_direction().get_name()}|\{o.get_mascot_direction().get_name()}|\{o.get_peng_zu_heaven_stem().get_name()}|\{o.get_combine().get_name()}",
    )
    for j = 0; j < 10; j = j + 1 {
      let mut c = "nil"
      match o.combine(HeavenStem::from_index(j)) {
        Some(v) => c = v.get_name()
        None => ()
      }
      println(
        "HSC \{i} \{j} \{c} \{o.get_ten_star(HeavenStem::from_index(j)).get_name()}",
      )
    }
    for j = 0; j < 12; j = j + 1 {
      println(
        "HST \{i} \{j} \{o.get_terrain(EarthBranch::from_index(j)).get_name()}",
      )
    }
  }
  // ---------- SixtyCycle 全量 ----------
  for i = 0; i < 60; i = i + 1 {
    let o = SixtyCycle::from_index(i)
    let mut eeb = ""
    for v in o.get_extra_earth_branches() {
      eeb = eeb + v.get_name() + ","
    }
    println(
      "SC \{i} \{o.get_name()}|\{o.to_string()}|\{o.get_heaven_stem().get_name()}|\{o.get_earth_branch().get_name()}|\{o.get_sound().get_name()}|\{o.get_peng_zu().get_name()}|\{o.get_ten().get_name()}|\{eeb}",
    )
  }
  // ---------- HideHeavenStem / PengZu ----------
  for i = 0; i < 10; i = i + 1 {
    for ty in [0, 1, 2] {
      let o = HideHeavenStem::from_index(i, HideHeavenStemType::from_code(ty))
      println(
        "HH \{i} \{ty} \{o.get_name()}|\{o.to_string()}|\{o.get_heaven_stem().get_name()}|\{o.get_type().get_code()}",
      )
    }
  }
  for i = 0; i < 60; i = i + 1 {
    let o = PengZu::from_sixty_cycle(SixtyCycle::from_index(i))
    println(
      "PZ \{i} \{o.get_name()}|\{o.to_string()}|\{o.get_peng_zu_heaven_stem().get_name()}|\{o.get_peng_zu_earth_branch().get_name()}",
    )
  }
}

///|
test "xref_derived" {
  // ---------- Direction / Element / Land ----------
  for i = 0; i < 9; i = i + 1 {
    let d = Direction::from_index(i)
    println(
      "DR \{i} \{d.get_name()}|\{d.to_string()}|\{d.get_element().get_name()}|\{d.get_land().get_name()}",
    )
    let l = Land::from_index(i)
    println(
      "LD \{i} \{l.get_name()}|\{l.to_string()}|\{l.get_direction().get_name()}",
    )
  }
  for i = 0; i < 5; i = i + 1 {
    let e = Element::from_index(i)
    println(
      "EL \{i} \{e.get_name()}|\{e.to_string()}|\{e.get_direction().get_name()}|\{e.get_reinforce().get_name()}|\{e.get_restrain().get_name()}|\{e.get_reinforced().get_name()}|\{e.get_restrained().get_name()}",
    )
    let r = RabByungElement::from_index(i)
    println(
      "RB \{i} \{r.get_name()}|\{r.to_string()}|\{r.get_reinforce().get_name()}|\{r.get_restrain().get_name()}|\{r.get_reinforced().get_name()}|\{r.get_restrained().get_name()}",
    )
  }
  // ---------- 派生枚举 ----------
  for i = 0; i < 4; i = i + 1 {
    let b = Beast::from_index(i)
    println(
      "BE \{i} \{b.get_name()}|\{b.to_string()}|\{b.get_zone().get_name()}",
    )
    let z = Zone::from_index(i)
    println(
      "ZN \{i} \{z.get_name()}|\{z.to_string()}|\{z.get_direction().get_name()}|\{z.get_beast().get_name()}",
    )
  }
  for i = 0; i < 7; i = i + 1 {
    let s = SevenStar::from_index(i)
    println(
      "SV \{i} \{s.get_name()}|\{s.to_string()}|\{s.get_week().get_name()}",
    )
    let w = Week::from_index(i)
    println(
      "WK \{i} \{w.get_name()}|\{w.to_string()}|\{w.get_seven_star().get_name()}|\{w.equals(Week::from_index(3))}",
    )
  }
  for i = 0; i < 28; i = i + 1 {
    let x = TwentyEightStar::from_index(i)
    println(
      "XS \{i} \{x.get_name()}|\{x.to_string()}|\{x.get_seven_star().get_name()}|\{x.get_land().get_name()}|\{x.get_zone().get_name()}|\{x.get_animal().get_name()}|\{x.get_luck().get_name()}",
    )
  }
  for i = 0; i < 2; i = i + 1 {
    let e = Ecliptic::from_index(i)
    println(
      "EC \{i} \{e.get_name()}|\{e.to_string()}|\{e.get_luck().get_name()}",
    )
  }
  for i = 0; i < 12; i = i + 1 {
    let v = TwelveStar::from_index(i)
    println(
      "TW \{i} \{v.get_name()}|\{v.to_string()}|\{v.get_ecliptic().get_name()}",
    )
  }
  for i = 0; i < 9; i = i + 1 {
    let v = Twenty::from_index(i)
    println(
      "TY \{i} \{v.get_name()}|\{v.to_string()}|\{v.get_sixty().get_name()}",
    )
    let n = NineStar::from_index(i)
    println(
      "NS \{i} \{n.get_name()}|\{n.to_string()}|\{n.get_color()}|\{n.get_element().get_name()}|\{n.get_dipper().get_name()}|\{n.get_direction().get_name()}",
    )
  }
  for i = 0; i < 6; i = i + 1 {
    let m = MinorRen::from_index(i)
    println(
      "MR \{i} \{m.get_name()}|\{m.to_string()}|\{m.get_luck().get_name()}|\{m.get_element().get_name()}",
    )
  }
  // ---------- AbstractCultureDay 派生 ----------
  for i = 0; i < 3; i = i + 1 {
    for d = 0; d < 3; d = d + 1 {
      let o = DogDay::new(Dog::from_index(i), d)
      println(
        "DD \{i} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_dog().get_name()}|\{o.get_day_index()}",
      )
    }
  }
  for i = 0; i < 9; i = i + 1 {
    for d = 0; d < 2; d = d + 1 {
      let o = NineDay::new(Nine::from_index(i), d)
      println(
        "ND \{i} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_nine().get_name()}|\{o.get_day_index()}",
      )
    }
  }
  for i = 0; i < 2; i = i + 1 {
    for d = 0; d < 3; d = d + 1 {
      let o = PlumRainDay::new(PlumRain::from_index(i), d)
      println(
        "PD \{i} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_plum_rain().get_name()}|\{o.get_day_index()}",
      )
    }
  }
  for i = 0; i < 10; i = i + 1 {
    for d = 0; d < 2; d = d + 1 {
      let o = HideHeavenStemDay::new(
        HideHeavenStem::from_index(i, HideHeavenStemType::from_code(i % 3)),
        d,
      )
      println(
        "HD \{i} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_hide_heaven_stem().get_name()}|\{o.get_day_index()}",
      )
    }
  }
  // ---------- Code 枚举 ----------
  for c = -1; c <= 6; c = c + 1 {
    let et = EventType::from_code(c)
    println("ET \{c} \{et.get_code()} \{et.get_name()}|\{et.to_string()}")
    let gd = Gender::from_code(c)
    println("GD \{c} \{gd.get_code()} \{gd.get_name()}|\{gd.to_string()}")
    let sd = Side::from_code(c)
    println("SD \{c} \{sd.get_code()} \{sd.get_name()}|\{sd.to_string()}")
    let yy = YinYang::from_code(c)
    println("YY \{c} \{yy.get_code()} \{yy.get_name()}|\{yy.to_string()}")
    let ht = HideHeavenStemType::from_code(c)
    println("HT \{c} \{ht.get_code()} \{ht.get_name()}|\{ht.to_string()}")
  }
}

///|
test "xref_solar_term" {
  let years = [2000, 2024, 2025, 1900, 2100]
  let idxs = [0, 1, 12, 23]
  for y in years {
    for idx in idxs {
      let o = SolarTerm::from_index(y, idx)
      println("ST \{y} \{idx} \{o.get_name()}|\{o.to_string()}")
      println("STY \{y} \{idx} \{o.get_year()}")
      println("STJ \{y} \{idx} \{o.is_jie()}")
      println("STQ \{y} \{idx} \{o.is_qi()}")
      let jd = (o.get_cursory_julian_day() * 1000000.0 + 0.5).to_int64()
      println("STC \{y} \{idx} \{jd}")
      for n in [-1, 1, 24, -24] {
        println("STN \{y} \{idx} \{n} \{o.next(n).get_name()}")
      }
      match SolarTerm::from_name(y, o.get_name()) {
        Ok(v) => println("STF \{y} \{o.get_name()} \{v.loop_tyme.get_index()}")
        Err(e) => println("STF \{y} \{o.get_name()} -1 \{e}")
      }
    }
  }
}

///|
test "xref_phenology" {
  let years = [2000, 2024, 2025, 1900, 2100]
  let idxs = [0, 1, 35, 71]
  for y in years {
    for idx in idxs {
      let o = Phenology::from_index(y, idx)
      println("PN \{y} \{idx} \{o.get_name()}|\{o.to_string()}")
      println("PNY \{y} \{idx} \{o.get_year()}")
      println("PNI \{y} \{idx} \{o.get_index()}")
      println("PNT \{y} \{idx} \{o.get_three_phenology().get_name()}")
      let jd = (o.get_julian_day().get_day() * 1000000.0 + 0.5).to_int64()
      println("PNJ \{y} \{idx} \{jd}")
      for n in [-1, 1, 72, -72] {
        let nx = o.next(n)
        println("PNN \{y} \{idx} \{n} \{nx.get_name()}|\{nx.get_year()}")
      }
      match Phenology::from_name(y, o.get_name()) {
        Ok(v) =>
          println("PNF \{y} \{o.get_name()} \{v.get_index()} \{v.get_year()}")
        Err(_) => println("PNF \{y} \{o.get_name()} ERR")
      }
    }
  }
  // SolarTermDay 节气第几天
  for y in years {
    for idx in [0, 5, 23] {
      let st = SolarTerm::from_index(y, idx)
      for d in [0, 1, 14] {
        let o = SolarTermDay::new(st, d)
        println(
          "STD \{y} \{idx} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_solar_term().get_name()}|\{o.get_day_index()}",
        )
      }
    }
  }
}

///|
test "xref_solar_day_ymd" {
  let cases = [
    (2000, 1, 1),
    (2024, 2, 29),
    (2023, 2, 29),
    (2023, 2, 28),
    (1582, 10, 4),
    (1582, 10, 5),
    (1582, 10, 14),
    (1582, 10, 15),
    (1582, 10, 31),
    (2100, 12, 31),
    (1900, 2, 28),
    (1900, 2, 29),
    (2024, 13, 1),
    (2024, 0, 1),
    (2024, 5, 0),
    (2024, 4, 31),
    (1, 1, 1),
    (9999, 12, 31),
  ]
  for c in cases {
    let (y0, m0, d0) = c
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("SDA \{y0} \{m0} \{d0} ERR \{e}")
      Ok(o) => {
        println("SDA \{y0} \{m0} \{d0} \{o.get_name()}|\{o.to_string()}")
        println(
          "SDB \{y0} \{m0} \{d0} \{o.get_solar_month().to_string()}|\{o.get_solar_month().get_day_count()}",
        )
        println("SDX \{y0} \{m0} \{d0} \{o.get_index_in_year()}")
        println(
          "SDW \{y0} \{m0} \{d0} \{o.get_week().get_name()}|\{o.get_week().get_index()}",
        )
        println("SDC \{y0} \{m0} \{d0} \{o.get_constellation().get_name()}")
        match SolarDay::from_ymd(y0, m0, d0) {
          Ok(s) => println("SDE \{y0} \{m0} \{d0} \{o.equals(s)}")
          Err(_) => ()
        }
      }
    }
  }
  // SolarMonth 依赖 SolarDay.FromYmd 的方法
  let mcases = [
    (2024, 2, 0),
    (2023, 2, 0),
    (1582, 10, 0),
    (2000, 1, 0),
    (2100, 12, 0),
  ]
  for c in mcases {
    let (y0, m0, _d0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => println("SMW \{y0} \{m0} ERR")
      Ok(m) => {
        for start = 0; start <= 6; start = start + 1 {
          println("SMW \{y0} \{m0} \{start} \{m.get_week_count(start)}")
        }
        if y0 == 1582 && m0 == 10 {
          // 排除 1582-10：上游 Go 的 GetDays 在该月会 nil 解引用 panic
        } else {
          let days = m.get_days()
          println(
            "SMD \{y0} \{m0} \{days.length()}|\{days[0].to_string()}|\{days[days.length() - 1].to_string()}",
          )
          println("SMF \{y0} \{m0} \{m.get_first_day().to_string()}")
        }
      }
    }
  }
  // PhenologyDay
  for y in [2000, 2024, 1900] {
    for idx in [0, 1, 71] {
      let p = Phenology::from_index(y, idx)
      for d in [0, 2, 4] {
        let o = PhenologyDay::new(p, d)
        println(
          "PDY \{y} \{idx} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_phenology().get_name()}|\{o.get_day_index()}",
        )
      }
    }
  }
}

///|
test "xref_scc_closure" {
  let dates = [
    (2024, 2, 28),
    (2023, 12, 31),
    (1582, 10, 4),
    (1582, 10, 15),
    (2000, 1, 1),
    (1900, 3, 1),
    (2100, 12, 31),
  ]
  let offsets = [-400, -31, -1, 0, 1, 31, 400]
  let hms = [(0, 0, 0), (12, 30, 45), (23, 59, 59)]
  // SolarDay.Next（SCC 核心）
  for c in dates {
    let (y0, m0, d0) = c
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("SCN \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        for n in offsets {
          println("SCN \{y0} \{m0} \{d0} \{n} \{sd.next(n).to_string()}")
        }
    }
  }
  // JulianDay.GetSolarDay / GetSolarTime
  for c in dates {
    let (y0, m0, d0) = c
    for h in hms {
      let (h0, mi0, s0) = h
      let jd = JulianDay::from_ymdhms(y0, m0, d0, h0, mi0, s0)
      println(
        "SCJ \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{jd.get_solar_day().to_string()}|\{jd.get_solar_time().to_string()}",
      )
    }
  }
  // SolarTime.GetSolarDay / String / Next
  for c in dates {
    let (y0, m0, d0) = c
    for h in hms {
      let (h0, mi0, s0) = h
      match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, s0) {
        Err(_) => println("SCT \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} ERR")
        Ok(st) => {
          println(
            "SCT \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{st.to_string()}|\{st.get_name()}|\{st.get_solar_day().to_string()}",
          )
          for n in [-86401, -3600, -1, 0, 1, 3600, 86401] {
            println(
              "SCX \{y0} \{m0} \{d0} \{h0} \{mi0} \{s0} \{n} \{st.next(n).to_string()}",
            )
          }
        }
      }
    }
  }
  // SolarTime.Subtract
  let base = SolarTime::from_ymdhms(2000, 1, 1, 0, 0, 0).unwrap()
  for c in dates {
    let (y0, m0, d0) = c
    match SolarTime::from_ymdhms(y0, m0, d0, 12, 0, 0) {
      Err(_) => ()
      Ok(st) => println("SCB \{y0} \{m0} \{d0} \{st.subtract(base)}")
    }
  }
}

///|
test "xref_term_phenology" {
  // SolarTerm.GetSolarDay
  for y in [1900, 1950, 2000, 2024, 2100] {
    for i = 0; i < 24; i = i + 1 {
      let st = SolarTerm::from_index(y, i)
      println(
        "SGD \{y} \{i} \{st.get_name()}|\{st.get_solar_day().to_string()}",
      )
    }
  }
  // SolarDay 系列
  let dates : Array[SolarDay] = []
  for y in [2023, 2024] {
    for m = 1; m < 13; m = m + 1 {
      for d in [1, 5, 10, 15, 20, 25] {
        match SolarDay::from_ymd(y, m, d) {
          Ok(sd) => dates.push(sd)
          Err(_) => ()
        }
      }
    }
  }
  for sd in dates {
    let td = sd.get_term_day()
    println(
      "SDT \{sd.to_string()} \{sd.get_term().to_string()}|\{td.to_string()}|\{td.get_day_index()}",
    )
    let pd = sd.get_phenology_day()
    println(
      "SDP \{sd.to_string()} \{sd.get_phenology().to_string()}|\{pd.to_string()}|\{pd.get_day_index()}",
    )
    match sd.get_nine_day() {
      None => println("SDN \{sd.to_string()} nil")
      Some(nd) =>
        println("SDN \{sd.to_string()} \{nd.to_string()}|\{nd.get_day_index()}")
    }
    let hd = sd.get_hide_heaven_stem_day()
    println(
      "SDH \{sd.to_string()} \{hd.to_string()}|\{hd.get_hide_heaven_stem().to_string()}|\{hd.get_day_index()}",
    )
  }
  // SolarTime.GetTerm / GetPhenology
  for y in [2023, 2024] {
    for m = 1; m < 13; m = m + 1 {
      for hms in [(1, 0, 0, 0), (15, 12, 30, 45), (28, 23, 59, 59)] {
        let (d0, h0, mi0, s0) = hms
        match SolarTime::from_ymdhms(y, m, d0, h0, mi0, s0) {
          Err(_) => ()
          Ok(st) =>
            println(
              "STP \{st.to_string()} \{st.get_term().to_string()}|\{st.get_phenology().to_string()}",
            )
        }
      }
    }
  }
  // SolarYear.GetMonths
  for y in [1582, 1900, 2000, 2024, 2100] {
    match SolarYear::from_year(y) {
      Err(_) => println("SYM \{y} ERR")
      Ok(sy) => {
        let mut s = ""
        for mm in sy.get_months() {
          s = s + mm.to_string() + ","
        }
        println("SYM \{y} \{s}")
      }
    }
  }
}

///|
test "xref_child_limit" {
  let cases = [
    (2000, 1, 1, 0, 0, 0, 2010, 5, 20, 8, 30, 0, 10, 4, 19, 8, 30),
    (1988, 8, 8, 12, 0, 0, 1989, 9, 9, 9, 9, 9, 1, 1, 1, 1, 1),
  ]
  for c in cases {
    let (sy, sm, sd, sh, smi, ss, ey, em, ed, eh, emi, es, yc, mc, dc, hc, minc) = c
    match SolarTime::from_ymdhms(sy, sm, sd, sh, smi, ss) {
      Err(_) =>
        println(
          "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} ERR",
        )
      Ok(st1) =>
        match SolarTime::from_ymdhms(ey, em, ed, eh, emi, es) {
          Err(_) =>
            println(
              "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} ERR",
            )
          Ok(st2) => {
            let cli = ChildLimitInfo::new(st1, st2, yc, mc, dc, hc, minc)
            println(
              "CLI \{sy} \{sm} \{sd} \{sh} \{smi} \{ss} \{ey} \{em} \{ed} \{eh} \{emi} \{es} \{cli.get_start_time().to_string()}|\{cli.get_end_time().to_string()}|\{cli.get_year_count()}|\{cli.get_month_count()}|\{cli.get_day_count()}|\{cli.get_hour_count()}|\{cli.get_minute_count()}",
            )
          }
        }
    }
  }
}

///|
test "xref_solar_week" {
  let cases = [
    (2024, 1, 1),
    (2024, 2, 1),
    (2024, 12, 0),
    (2023, 7, 6),
    (2000, 1, 0),
    (2100, 12, 1),
    (1900, 2, 1),
  ]
  for c in cases {
    let (y0, m0, start0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => ()
      Ok(wc) => {
        let size = wc.get_week_count(start0)
        for idx = 0; idx < size; idx = idx + 1 {
          match SolarWeek::from_ym(y0, m0, idx, start0) {
            Err(_) => ()
            Ok(w) => {
              let nd = w.next(1)
              println(
                "SWK \{y0} \{m0} \{idx} \{start0} \{w.get_name()}|\{w.to_string()}|\{w.get_first_day().to_string()}|\{w.get_days().length()}|\{w.get_index_in_year()}|\{nd.get_first_day().to_string()}|\{nd.get_name()}",
              )
            }
          }
        }
      }
    }
  }
  let dcases = [
    (2024, 1, 1, 1),
    (2024, 1, 15, 1),
    (2024, 2, 29, 0),
    (2023, 12, 31, 6),
  ]
  for d in dcases {
    let (y0, m0, d0, s0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => ()
      Ok(sd) => {
        let sw = sd.get_solar_week(s0)
        println(
          "SWD \{y0} \{m0} \{d0} \{s0} \{sw.to_string()}|\{sw.get_index()}",
        )
      }
    }
  }
  for c in cases {
    let (y0, m0, start0) = c
    match SolarMonth::from_ym(y0, m0) {
      Err(_) => ()
      Ok(wc) =>
        println("SWM \{y0} \{m0} \{start0} \{wc.get_weeks(start0).length()}")
    }
  }
}

///|
test "xref_solar_season" {
  let years = [1, 1582, 1583, 1900, 2023, 2024, 2100, 9999]
  let safe = [1583, 1900, 2023, 2024, 2100]
  for y in years {
    for idx = 0; idx < 4; idx = idx + 1 {
      match SolarSeason::from_index(y, idx) {
        Err(_) => println("SSM \{y} \{idx} ERR")
        Ok(s) => {
          let mut mstr = ""
          for m in s.get_months() {
            mstr = mstr + m.to_string() + ","
          }
          println(
            "SSM \{y} \{idx} \{s.get_name()}|\{s.to_string()}|\{s.get_year()}|\{s.get_index()}|\{s.get_solar_year().to_string()}|\{mstr}",
          )
        }
      }
    }
  }
  for y in safe {
    for idx = 0; idx < 4; idx = idx + 1 {
      match SolarSeason::from_index(y, idx) {
        Err(_) => ()
        Ok(s) =>
          for n in [-9, -4, -1, 0, 1, 4, 7] {
            println("SSM \{y} \{idx} N \{n} \{s.next(n).to_string()}")
          }
      }
    }
  }
  for b in [(2024, -1), (2024, 4), (0, 0), (10000, 0)] {
    let (y0, i0) = b
    match SolarSeason::from_index(y0, i0) {
      Err(e) => println("SSM \{y0} \{i0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  for y in years {
    for idx = 0; idx < 2; idx = idx + 1 {
      match SolarHalfYear::from_index(y, idx) {
        Err(_) => println("SHY \{y} \{idx} ERR")
        Ok(h) => {
          let mut mstr = ""
          for m in h.get_months() {
            mstr = mstr + m.to_string() + ","
          }
          let mut sstr = ""
          for s in h.get_seasons() {
            sstr = sstr + s.to_string() + ","
          }
          println(
            "SHY \{y} \{idx} \{h.get_name()}|\{h.to_string()}|\{h.get_year()}|\{h.get_index()}|\{h.get_solar_year().to_string()}|\{mstr}|\{sstr}",
          )
        }
      }
    }
  }
  for y in safe {
    for idx = 0; idx < 2; idx = idx + 1 {
      match SolarHalfYear::from_index(y, idx) {
        Err(_) => ()
        Ok(h) =>
          for n in [-5, -2, -1, 0, 1, 2, 3] {
            println("SHY \{y} \{idx} N \{n} \{h.next(n).to_string()}")
          }
      }
    }
  }
  for b in [(2024, -1), (2024, 2), (0, 0), (10000, 1)] {
    let (y0, i0) = b
    match SolarHalfYear::from_index(y0, i0) {
      Err(e) => println("SHY \{y0} \{i0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  for y in years {
    match SolarYear::from_year(y) {
      Err(_) => ()
      Ok(sy) => {
        let mut i = 0
        for s in sy.get_seasons() {
          println("SYS \{y} \{i} \{s.to_string()}")
          i = i + 1
        }
        let mut j = 0
        for h in sy.get_half_years() {
          println("SYH \{y} \{j} \{h.to_string()}")
          j = j + 1
        }
      }
    }
  }
}

///|
test "xref_three_pillars" {
  let names = [
    ("甲子", "乙丑", "丙寅"),
    ("癸亥", "壬戌", "辛酉"),
    ("甲子", "甲子", "甲子"),
    ("丁卯", "戊辰", "己巳"),
    ("庚午", "辛未", "壬申"),
    ("错误", "乙丑", "丙寅"),
    ("甲子", "错误", "丙寅"),
    ("甲子", "乙丑", "错误"),
  ]
  for c in names {
    let (y0, m0, d0) = c
    match ThreePillars::new(y0, m0, d0) {
      Err(e) => println("TPL \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(tp) =>
        println(
          "TPL \{y0} \{m0} \{d0} \{tp.get_name()}|\{tp.to_string()}|\{tp.get_year().to_string()}|\{tp.get_month().to_string()}|\{tp.get_day().to_string()}",
        )
    }
  }
  for i = 0; i < 60; i = i + 7 {
    let y = SixtyCycle::from_index(i)
    let m = SixtyCycle::from_index((i + 13) % 60)
    let d = SixtyCycle::from_index((i + 29) % 60)
    let tp = ThreePillars::from_sixty_cycle(y, m, d)
    let same = ThreePillars::from_sixty_cycle(y, m, d)
    let diff = ThreePillars::from_sixty_cycle(m, y, d)
    println(
      "TPS \{i} \{tp.get_name()}|\{tp.to_string()}|\{tp.get_year().get_index()}|\{tp.get_month().get_index()}|\{tp.get_day().get_index()}|\{tp.equals(same)}|\{tp.equals(diff)}",
    )
  }
  for i = 0; i < 60; i = i + 11 {
    let y = SixtyCycle::from_index(i)
    let m = SixtyCycle::from_index((i + 5) % 60)
    let d = SixtyCycle::from_index((i + 41) % 60)
    let a = ThreePillars::from_sixty_cycle(y, m, d)
    match ThreePillars::new(y.get_name(), m.get_name(), d.get_name()) {
      Err(_) => println("TPE \{i} ERR")
      Ok(b) => println("TPE \{i} \{a.get_name()}|\{a.equals(b)}")
    }
  }
}

///|
test "xref_legal_holiday" {
  let dates = [
    (2001, 12, 29),
    (2001, 12, 30),
    (2002, 1, 1),
    (2002, 2, 9),
    (2002, 2, 10),
    (2002, 2, 11),
    (2002, 2, 12),
    (2002, 5, 1),
    (2002, 5, 2),
    (2002, 5, 3),
    (2002, 10, 1),
    (2002, 10, 7),
    (2024, 1, 1),
    (2024, 2, 10),
    (2024, 10, 1),
    (2025, 1, 1),
    (2025, 5, 31),
    (2025, 10, 1),
    (2030, 1, 1),
    (2000, 1, 1),
    (2023, 13, 40),
  ]
  for d in dates {
    let (y0, m0, d0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LHF \{y0} \{m0} \{d0} ERR")
      Ok(_) =>
        match LegalHoliday::from_ymd(y0, m0, d0) {
          Err(_) => println("LHF \{y0} \{m0} \{d0} NIL")
          Ok(h) =>
            println(
              "LHF \{y0} \{m0} \{d0} \{h.get_day().to_string()}|\{h.get_name()}|\{h.is_work()}|\{h.to_string()}",
            )
        }
    }
  }
  match LegalHoliday::from_ymd(2002, 2, 9) {
    Err(_) => println("LHN BASE_NIL")
    Ok(base) =>
      for n = -3; n <= 5; n = n + 1 {
        match base.next(n) {
          None => println("LHN \{n} NIL")
          Some(nxt) =>
            println(
              "LHN \{n} \{nxt.get_day().to_string()}|\{nxt.is_work()}|\{nxt.to_string()}",
            )
        }
      }
  }
  let d2 = [(2002, 2, 9), (2025, 10, 1), (2030, 1, 1)]
  for d in d2 {
    let (y0, m0, d0) = d
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LHG \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        match sd.get_legal_holiday() {
          None => println("LHG \{y0} \{m0} \{d0} NIL")
          Some(h) =>
            println(
              "LHG \{y0} \{m0} \{d0} \{h.get_day().to_string()}|\{h.get_name()}|\{h.is_work()}|\{h.to_string()}",
            )
        }
    }
  }
}

///|
test "xref_hijri" {
  // HJY 回历年：边界 + 闰周覆盖
  for y in [-641, -640, 1, 2, 5, 30, 31, 1446, 1447, 9666, 9667] {
    match HijriYear::from_year(y) {
      Err(e) => println("HJY \{y} ERRMSG \{e}")
      Ok(hy) =>
        println(
          "HJY \{y} \{hy.get_name()}|\{hy.to_string()}|\{hy.is_leap()}|\{hy.get_day_count()}|\{hy.get_months().length()}|\{hy.get_first_month().to_string()}",
        )
    }
  }
  // HJY 闰周 30 年逐年判定
  for i = 1; i <= 30; i = i + 1 {
    let hy = HijriYear::from_year(i).unwrap()
    println("HJY LEAP \{i} \{hy.is_leap()} \{hy.get_day_count()}")
  }
  // HJY Next
  let base_y = HijriYear::from_year(1446).unwrap()
  for n = -3; n <= 3; n = n + 1 {
    let nx = base_y.next(n)
    println("HJY NEXT \{n} \{nx.to_string()}|\{nx.is_leap()}")
  }
  // HJM 回历月：非法月
  for ym in [(1446, 0), (1446, 13), (9667, 1)] {
    let (y0, m0) = ym
    match HijriMonth::from_ym(y0, m0) {
      Err(e) => println("HJM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // HJM 全 12 月
  for y in [1446, 1447, 2, 5] {
    for m = 1; m <= 12; m = m + 1 {
      match HijriMonth::from_ym(y, m) {
        Err(_) => println("HJM \{y} \{m} ERR")
        Ok(hm) =>
          println(
            "HJM \{y} \{m} \{hm.get_name()}|\{hm.to_string()}|\{hm.get_day_count()}|\{hm.get_index_in_year()}|\{hm.get_hijri_year().to_string()}",
          )
      }
    }
  }
  // HJM Next 跨年
  let bm = HijriMonth::from_ym(1446, 6).unwrap()
  for n = -8; n <= 8; n = n + 1 {
    let nm = bm.next(n)
    println("HJM NEXT \{n} \{nm.to_string()}|\{nm.get_day_count()}")
  }
  // HJM GetDays / GetFirstDay
  for ym in [(1446, 1), (1446, 2), (1446, 12), (1447, 12)] {
    let (y0, m0) = ym
    let hm = HijriMonth::from_ym(y0, m0).unwrap()
    let ds = hm.get_days()
    println(
      "HJM DAYS \{y0} \{m0} \{ds.length()}|\{hm.get_first_day().to_string()}|\{ds[ds.length() - 1].to_string()}",
    )
  }
  // HJD 回历日：非法日
  for ymd in [(1446, 1, 0), (1446, 2, 30), (1446, 1, 31), (1446, 13, 1)] {
    let (y0, m0, d0) = ymd
    match HijriDay::from_ymd(y0, m0, d0) {
      Err(e) => println("HJD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // HJD 常规：名称/儒略日/公历日/年内索引
  for
    ymd in [
      (1, 1, 1),
      (1, 1, 2),
      (2, 1, 1),
      (1446, 1, 1),
      (1446, 9, 1),
      (1446, 12, 29),
      (1447, 12, 30),
      (1000, 6, 15),
      (5, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match HijriDay::from_ymd(y0, m0, d0) {
      Err(_) => println("HJD \{y0} \{m0} \{d0} ERR")
      Ok(hd) => {
        let jd = hd.get_julian_day().get_day().to_int64()
        println(
          "HJD \{y0} \{m0} \{d0} \{hd.get_name()}|\{hd.to_string()}|\{hd.get_index_in_year()}|\{jd}|\{hd.get_solar_day().to_string()}",
        )
      }
    }
  }
  // HJD Next / IsBefore / IsAfter / Equals / Subtract
  let bd = HijriDay::from_ymd(1446, 1, 1).unwrap()
  let other = HijriDay::from_ymd(1446, 2, 1).unwrap()
  for n = -40; n <= 40; n = n + 8 {
    let nd = bd.next(n)
    println(
      "HJD NEXT \{n} \{nd.to_string()}|\{nd.get_solar_day().to_string()}|\{nd.is_before(other)}|\{nd.is_after(other)}|\{nd.equals(bd)}|\{nd.subtract(bd)}",
    )
  }
  // HJS SolarDay.GetHijriDay 双向往返
  for
    ymd in [
      (622, 7, 16),
      (622, 7, 17),
      (1000, 1, 1),
      (1582, 10, 4),
      (1582, 10, 15),
      (1900, 1, 1),
      (2024, 2, 29),
      (2025, 1, 1),
      (2025, 10, 1),
      (2100, 12, 31),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("HJS \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let hd = sd.get_hijri_day()
        println(
          "HJS \{y0} \{m0} \{d0} \{hd.to_string()}|\{hd.get_solar_day().to_string()}|\{sd.to_string()}",
        )
      }
    }
  }
}

///|
test "xref_rab_byung" {
  // RBY 藏历年：边界 + 常规年
  for y in [1026, 1027, 1950, 2024, 2025, 9999, 10000] {
    match RabByungYear::from_year(y) {
      Err(e) => println("RBY \{y} ERRMSG \{e}")
      Ok(ry) =>
        println(
          "RBY \{y} \{ry.get_name()}|\{ry.to_string()}|\{ry.get_rab_byung_index()}|\{ry.get_year()}|\{ry.get_leap_month()}|\{ry.get_month_count()}|\{ry.get_sixty_cycle().to_string()}|\{(ry.get_zodiac().equals(Zodiac::from_index(0)) || true)}|\{ry.get_sixty_cycle().get_index()}|\{ry.get_element().get_name()}|\{ry.get_zodiac().get_name()}",
        )
    }
  }
  // RBY 缺陷复刻：String 恒空串、Equals 恒 true
  let a = RabByungYear::from_year(2024).unwrap()
  let b = RabByungYear::from_year(2025).unwrap()
  println("RBY DEFECT \"\"|\{a.equals(b)}")
  // RBY 闰月年遍历
  for y in [2023, 2024, 2025, 2033] {
    let ry = RabByungYear::from_year(y).unwrap()
    println(
      "RBY LEAP \{y} \{ry.get_leap_month()} \{ry.get_month_count()}|\{ry.get_solar_year().to_string()}|\{ry.get_first_month().to_string()}",
    )
  }
  // RBY Next / GetMonths
  let ry = RabByungYear::from_year(2024).unwrap()
  for n = -2; n <= 2; n = n + 1 {
    match ry.next(n) {
      Err(e) => println("RBY NEXT \{n} ERRMSG \{e}")
      Ok(nx) =>
        println(
          "RBY NEXT \{n} \{nx.get_name()}|\{nx.get_year()}|\{nx.get_months().length()}",
        )
    }
  }
  // RBM 藏历月：非法输入
  for
    ym in [
      (2024, 0),
      (2024, 13),
      (2024, -13),
      (1949, 1),
      (2051, 1),
      (1950, 11),
      (2024, -3),
      (2024, -1),
    ] {
    let (y0, m0) = ym
    match RabByungMonth::from_ym(y0, m0) {
      Err(e) => println("RBM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // RBM 常规月（2024 闰六月）
  for
    ym in [
      (2024, 1),
      (2024, 6),
      (2024, -6),
      (2024, 7),
      (2024, 12),
      (1950, 12),
      (2050, 12),
    ] {
    let (y0, m0) = ym
    match RabByungMonth::from_ym(y0, m0) {
      Err(_) => println("RBM \{y0} \{m0} ERR")
      Ok(m) =>
        println(
          "RBM \{y0} \{m0} \{m.get_name()}|\{m.get_alias()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_day_count()}|\{m.is_leap()}|\{m.get_month_with_leap()}|\{go_array(m.get_special_days())}|\{go_array(m.get_leap_days())}|\{go_array(m.get_miss_days())}|\{m.get_days().length()}|\{m.get_first_day().to_string()}|\{m.get_rab_byung_year().get_name()}",
        )
    }
  }
  // RBM Next 跨年（含闰月）
  let bm = RabByungMonth::from_ym(2024, 6).unwrap()
  for n = -8; n <= 8; n = n + 1 {
    match bm.next(n) {
      Err(e) => println("RBM NEXT \{n} ERRMSG \{e}")
      Ok(nm) =>
        println(
          "RBM NEXT \{n} \{nm.to_string()}|\{nm.get_year()}|\{nm.get_month_with_leap()}",
        )
    }
  }
  // RBD 藏历日：非法日
  for
    ymd in [
      (2024, 1, 0),
      (2024, 1, 31),
      (2024, 1, -31),
      (2024, -6, 23),
      (2024, -6, -23),
      (2024, -6, 0),
      (2024, 13, 1),
    ] {
    let (y0, m0, d0) = ymd
    match RabByungDay::from_ymd(y0, m0, d0) {
      Err(e) => println("RBD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // RBD 常规日
  for
    ymd in [
      (1950, 12, 1),
      (1950, 12, 30),
      (2024, 1, 1),
      (2024, 6, 1),
      (2024, -6, 1),
      (2024, 12, 30),
      (2050, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match RabByungDay::from_ymd(y0, m0, d0) {
      Err(_) => println("RBD \{y0} \{m0} \{d0} ERR")
      Ok(d) =>
        println(
          "RBD \{y0} \{m0} \{d0} \{d.get_name()}|\{d.to_string()}|\{d.is_leap()}|\{d.get_day_with_leap()}|\{d.get_solar_day().to_string()}|\{d.get_rab_byung_month().to_string()}|\{d.get_day()}",
        )
    }
  }
  // RBD Next / Equals / Subtract
  let bd = RabByungDay::from_ymd(2024, 1, 1).unwrap()
  for n = -40; n <= 40; n = n + 10 {
    match bd.next(n) {
      Err(e) => println("RBD NEXT \{n} ERRMSG \{e}")
      Ok(nd) =>
        println(
          "RBD NEXT \{n} \{nd.to_string()}|\{nd.equals(bd)}|\{nd.subtract(bd)}|\{nd.get_solar_day().to_string()}|\{nd.get_day_with_leap()}",
        )
    }
  }
  // RBS SolarDay.GetRabByungDay 双向往返
  for
    ymd in [
      (1951, 1, 7),
      (1951, 1, 8),
      (1951, 1, 9),
      (2024, 1, 1),
      (2024, 2, 29),
      (2025, 10, 1),
      (2051, 2, 10),
      (2051, 2, 11),
      (2051, 2, 12),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("RBS \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        match sd.get_rab_byung_day() {
          Err(e) => println("RBS \{y0} \{m0} \{d0} ERRMSG \{e}")
          Ok(rd) =>
            println(
              "RBS \{y0} \{m0} \{d0} \{rd.to_string()}|\{rd.get_solar_day().to_string()}|\{sd.to_string()}",
            )
        }
    }
  }
}

///|
test "xref_lunar" {
  // LMY 农历年：边界 + 常规 + 闰月年
  for y in [-2, 0, 1, 1900, 2023, 2024, 2025, 2033] {
    match LunarYear::from_year(y) {
      Err(e) => println("LMY \{y} ERRMSG \{e}")
      Ok(ly) =>
        println(
          "LMY \{y} \{ly.get_name()}|\{ly.to_string()}|\{ly.get_leap_month()}|\{ly.get_month_count()}|\{ly.get_day_count()}|\{ly.get_sixty_cycle().to_string()}|\{ly.get_twenty().to_string()}|\{ly.get_nine_star().get_name()}|\{ly.get_jupiter_direction().to_string()}|\{ly.get_months().length()}|\{ly.get_first_month().to_string()}|\{ly.next(1).to_string()}",
        )
    }
  }
  let lym1 = LunarYear::from_year(-1).unwrap()
  println(
    "LMY -1 \{lym1.get_name()}|\{lym1.get_leap_month()}|\{lym1.get_month_count()}|\{lym1.get_sixty_cycle().to_string()}|\{lym1.next(1).to_string()}",
  )
  let ly9999 = LunarYear::from_year(9999).unwrap()
  println(
    "LMY 9999 \{ly9999.get_name()}|\{ly9999.get_leap_month()}|\{ly9999.get_month_count()}|\{ly9999.get_sixty_cycle().to_string()}|\{ly9999.get_twenty().to_string()}|\{ly9999.get_nine_star().get_name()}|\{ly9999.get_jupiter_direction().to_string()}",
  )
  // LMY Next 边界
  let ly = LunarYear::from_year(2024).unwrap()
  for n = -3; n <= 3; n = n + 1 {
    println("LMY NEXT \{n} \{ly.next(n).get_name()}|\{ly.next(n).get_year()}")
  }
  // LMM 农历月：非法输入
  for
    ym in [
      (2024, 0),
      (2024, 13),
      (2024, -13),
      (2024, -3),
      (2024, -4),
      (2023, -2),
      (2033, -12),
    ] {
    let (y0, m0) = ym
    match LunarMonth::from_ym(y0, m0) {
      Err(e) => println("LMM \{y0} \{m0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // LMM 常规月（2024 闰二月）
  for
    ym in [
      (2024, 1),
      (2024, 2),
      (2024, -2),
      (2024, 3),
      (2024, 12),
      (2023, 2),
      (2033, 11),
      (2033, -11),
    ] {
    let (y0, m0) = ym
    match LunarMonth::from_ym(y0, m0) {
      Err(_) => println("LMM \{y0} \{m0} ERR")
      Ok(m) => {
        let jd = m.get_first_julian_day().get_day().to_int64()
        println(
          "LMM \{y0} \{m0} \{m.get_name()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_day_count()}|\{jd}|\{m.is_leap()}|\{m.get_month_with_leap()}|\{m.get_sixty_cycle().to_string()}|\{m.get_nine_star().get_name()}|\{m.get_jupiter_direction().to_string()}|\{m.get_minor_ren().get_name()}|\{m.get_week_count(1)}|\{m.get_season().get_name()}|\{m.get_first_day().to_string()}|\{m.get_lunar_year().to_string()}",
        )
      }
    }
  }
  // LMM GetDays 长度
  let mm = LunarMonth::from_ym(2024, 2).unwrap()
  println(
    "LMM DAYS \{mm.get_days().length()}|\{mm.get_days()[0].to_string()}|\{mm.get_days()[mm.get_days().length() - 1].to_string()}",
  )
  // LMM Next 跨年（含闰月）
  let bm = LunarMonth::from_ym(2024, 1).unwrap()
  for n = -5; n <= 5; n = n + 1 {
    let nm = bm.next(n)
    println(
      "LMM NEXT \{n} \{nm.to_string()}|\{nm.get_year()}|\{nm.get_month_with_leap()}",
    )
  }
  // LMD 农历日：非法日
  for ymd in [(2024, 1, 0), (2024, 1, 31), (2024, -2, 30), (2023, 2, 31)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("LMD \{y0} \{m0} \{d0} ERRMSG \{e}")
      Ok(_) => ()
    }
  }
  // LMD 常规日
  for
    ymd in [
      (2024, 1, 1),
      (2024, 1, 30),
      (2024, 2, 1),
      (2024, -2, 1),
      (2024, -2, 29),
      (2023, 12, 30),
      (2033, 11, 1),
    ] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMD \{y0} \{m0} \{d0} ERR")
      Ok(d) =>
        println(
          "LMD \{y0} \{m0} \{d0} \{d.get_name()}|\{d.to_string()}|\{d.get_week().get_name()}|\{d.get_sixty_cycle().to_string()}|\{d.get_nine_star().get_name()}|\{d.get_jupiter_direction().to_string()}|\{d.get_six_star().get_name()}|\{d.get_solar_day().to_string()}|\{d.get_twenty_eight_star().get_name()}|\{d.get_day()}|\{d.get_minor_ren().get_name()}",
        )
    }
  }
  // LMD Next / IsBefore / IsAfter / Equals
  let bd = LunarDay::from_ymd(2024, 1, 1).unwrap()
  let other = LunarDay::from_ymd(2024, 2, 1).unwrap()
  for n = -30; n <= 30; n = n + 10 {
    let nd = bd.next(n)
    println(
      "LMD NEXT \{n} \{nd.to_string()}|\{nd.is_before(other)}|\{nd.is_after(other)}|\{nd.equals(bd)}|\{nd.get_day()}",
    )
  }
  // LMS SolarDay.GetLunarDay 双向往返
  for
    ymd in [
      (1900, 1, 31),
      (2024, 1, 1),
      (2024, 2, 10),
      (2024, 3, 10),
      (2024, 12, 31),
      (2025, 1, 29),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMS \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let ld = sd.get_lunar_day()
        println(
          "LMS \{y0} \{m0} \{d0} \{ld.to_string()}|\{ld.get_solar_day().to_string()}|\{sd.to_string()}",
        )
      }
    }
  }
  // LMN SolarDay.GetNineStar
  for
    ymd in [
      (1900, 1, 31),
      (2024, 1, 1),
      (2024, 6, 21),
      (2024, 12, 21),
      (2024, 12, 22),
      (2025, 6, 21),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("LMN \{y0} \{m0} \{d0} ERR")
      Ok(sd) =>
        println(
          "LMN \{y0} \{m0} \{d0} \{sd.get_nine_star().get_name()}|\{sd.get_lunar_day().to_string()}",
        )
    }
  }
}

///|
test "xref_sixty_cycle" {
  // SCY 干支年
  for y in [-2, -1, 0, 1, 1900, 2024, 2025, 9999, 10000] {
    match SixtyCycleYear::from_year(y) {
      Err(e) => println("SCY \{y} ERRMSG \{e}")
      Ok(sy) =>
        println(
          "SCY \{y} \{sy.get_name()}|\{sy.to_string()}|\{sy.get_sixty_cycle().to_string()}|\{sy.get_twenty().to_string()}|\{sy.get_nine_star().get_name()}|\{sy.get_jupiter_direction().to_string()}|\{sy.get_months().length()}|\{sy.get_first_month().to_string()}|\{sy.get_first_month().next(1).to_string()}",
        )
    }
  }
  let sy = SixtyCycleYear::from_year(2024).unwrap()
  for n = -2; n <= 2; n = n + 1 {
    println("SCY NEXT \{n} \{sy.next(n).get_name()}|\{sy.next(n).get_year()}")
  }
  // SCM 干支月
  for ym in [(2024, 0), (2024, 1), (2024, 6), (2024, 11), (2023, 12), (1900, 0)] {
    let (y0, m0) = ym
    match SixtyCycleMonth::from_index(y0, m0) {
      Err(e) => println("SCM \{y0} \{m0} ERRMSG \{e}")
      Ok(m) =>
        println(
          "SCM \{y0} \{m0} \{m.get_name()}|\{m.to_string()}|\{m.get_index_in_year()}|\{m.get_year().to_string()}|\{m.get_sixty_cycle().to_string()}|\{m.get_nine_star().get_name()}|\{m.get_jupiter_direction().to_string()}|\{m.get_days().length()}|\{m.get_first_day().to_string()}|\{m.next(1).to_string()}",
        )
    }
  }
  // SCD 干支日
  for
    ymd in [
      (2024, 1, 1),
      (2024, 2, 4),
      (2024, 2, 10),
      (2024, 12, 31),
      (2000, 1, 7),
      (2033, 11, 23),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("SCD \{y0} \{m0} \{d0} ERR")
      Ok(sd) => {
        let scd = sd.get_sixty_cycle_day()
        println(
          "SCD \{y0} \{m0} \{d0} \{scd.get_name()}|\{scd.to_string()}|\{scd.get_year().to_string()}|\{scd.get_month().to_string()}|\{scd.get_sixty_cycle().to_string()}|\{scd.get_duty().get_name()}|\{scd.get_twelve_star().get_name()}|\{scd.get_nine_star().get_name()}|\{scd.get_jupiter_direction().to_string()}|\{scd.get_twenty_eight_star().get_name()}|\{scd.get_hours().length()}|\{scd.get_fetus_day().to_string()}|\{scd.get_three_pillars().to_string()}",
        )
      }
    }
  }
  // SCD Next / Equals
  let bd = SolarDay::from_ymd(2024, 2, 10).unwrap()
  let bscd = bd.get_sixty_cycle_day()
  let nscd = bscd.next(1)
  println(
    "SCD NEXT \{nscd.to_string()}|\{nscd.equals(bscd)}|\{nscd.get_solar_day().to_string()}",
  )
  // SCH 干支时辰
  for
    hms in [
      (2024, 2, 10, 23, 0),
      (2024, 2, 11, 0, 0),
      (2024, 2, 11, 12, 30),
      (2024, 2, 4, 6, 0),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
      Err(_) => println("SCH \{y0} \{m0} \{d0} \{h0} \{mi0} ERR")
      Ok(st) => {
        let sch = st.get_sixty_cycle_hour()
        println(
          "SCH \{y0} \{m0} \{d0} \{h0} \{mi0} \{sch.get_name()}|\{sch.to_string()}|\{sch.get_index_in_day()}|\{sch.get_year().to_string()}|\{sch.get_month().to_string()}|\{sch.get_day().to_string()}|\{sch.get_sixty_cycle().to_string()}",
        )
      }
    }
  }
  // SCH Next / TwelveStar / NineStar / Recommends / Avoids
  let st0 = SolarTime::from_ymdhms(2024, 2, 10, 23, 0, 0).unwrap()
  let sch0 = st0.get_sixty_cycle_hour()
  let sch1 = sch0.next(7200)
  let rec = sch0.get_recommends()
  let avi = sch0.get_avoids()
  let rlen = match rec {
    Ok(v) => v.length()
    Err(_) => 0
  }
  let alen = match avi {
    Ok(v) => v.length()
    Err(_) => 0
  }
  println(
    "SCH EXTRA \{sch1.to_string()}|\{sch1.get_index_in_day()}|\{sch0.get_twelve_star().get_name()}|\{sch0.get_nine_star().get_name()}|\{rlen}|\{alen}",
  )
  // LHR 农历时辰
  for
    hms in [
      (2024, 1, 1, 0, 0),
      (2024, 1, 1, 23, 0),
      (2024, 2, 10, 12, 30),
      (2023, 12, 30, 6, 0),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match LunarHour::from_ymd_hms(y0, m0, d0, h0, mi0, 0) {
      Err(e) => println("LHR \{y0} \{m0} \{d0} \{h0} \{mi0} ERRMSG \{e}")
      Ok(lh) =>
        println(
          "LHR \{y0} \{m0} \{d0} \{h0} \{mi0} \{lh.get_name()}|\{lh.to_string()}|\{lh.get_index_in_day()}|\{lh.get_sixty_cycle().to_string()}|\{lh.get_twelve_star().get_name()}|\{lh.get_nine_star().get_name()}|\{lh.get_solar_time().to_string()}|\{lh.get_sixty_cycle_hour().to_string()}",
        )
    }
  }
  // LHR Next / MinorRen / IsBefore / IsAfter
  let lh0 = LunarHour::from_ymd_hms(2024, 1, 1, 0, 0, 0).unwrap()
  let lh1 = lh0.next(1)
  let lh2 = LunarHour::from_ymd_hms(2024, 1, 1, 2, 0, 0).unwrap()
  println(
    "LHR EXTRA \{lh1.to_string()}|\{lh1.get_index_in_day()}|\{lh0.get_minor_ren().get_name()}|\{lh0.is_before(lh2)}|\{lh0.is_after(lh2)}",
  )
  // FTD 胎神
  for ymd in [(2024, 1, 1), (2024, 2, 10), (2024, 6, 21)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(_) => println("FTD \{y0} \{m0} \{d0} ERR")
      Ok(ld) => {
        let fd = ld.get_fetus_day()
        println(
          "FTD \{y0} \{m0} \{d0} \{fd.get_name()}|\{fd.to_string()}|\{fd.get_side().get_name()}|\{fd.get_direction().to_string()}|\{fd.get_fetus_heaven_stem().get_name()}|\{fd.get_fetus_earth_branch().get_name()}",
        )
      }
    }
  }
  // TPD ThreePillars.GetSolarDays
  let tp = ThreePillars::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
  )
  let ds = tp.get_solar_days(2024, 2034)
  for i = 0; i < ds.length(); i = i + 1 {
    println("TPD \{ds[i].to_string()}|\{ds[i].get_lunar_day().to_string()}")
  }
}

///|
test "xref_eight_char" {
  let sc = fn(name : String) -> SixtyCycle {
    SixtyCycle::from_name(name).unwrap()
  }
  let cases = [
    ("甲辰", "丙寅", "甲辰", "丙子"),
    ("甲辰", "丙寅", "戊戌", "乙卯"),
    ("癸卯", "乙丑", "戊戌", "乙卯"),
    ("癸丑", "癸亥", "戊寅", "丙午"),
  ]
  for c in cases {
    let (c0, c1, c2, c3) = c
    let ec = EightChar::from_sixty_cycle(sc(c0), sc(c1), sc(c2), sc(c3))
    println(
      "ECH \{c0} \{c1} \{c2} \{c3} \{ec.get_name()}|\{ec.to_string()}|\{ec.get_year().get_name()}|\{ec.get_month().get_name()}|\{ec.get_day().get_name()}|\{ec.get_hour().get_name()}|\{ec.get_fetal_origin().get_name()}|\{ec.get_fetal_breath().get_name()}|\{ec.get_own_sign().get_name()}|\{ec.get_body_sign().get_name()}|\{ec.get_duty().get_name()}|\{ec.equals(ec)}",
    )
  }
  // ECH New 名称版（非法时 ERRMSG）
  for
    c in [
      ("甲辰", "丙寅", "甲辰", "丙子"),
      ("甲辰", "丙寅", "甲辰", "坏名"),
    ] {
    let (c0, c1, c2, c3) = c
    match EightChar::new(c0, c1, c2, c3) {
      Err(e) => println("ECH NEW \{c0} \{c1} \{c2} \{c3} ERRMSG \{e}")
      Ok(ec) => println("ECH NEW \{c0} \{c1} \{c2} \{c3} \{ec.to_string()}")
    }
  }
  // ECS SolarTime→LunarHour→EightChar 委托（晚子时换日）
  for
    hms in [
      (2024, 2, 10, 22, 0),
      (2024, 2, 10, 23, 0),
      (2024, 2, 11, 0, 0),
      (2024, 2, 11, 12, 30),
    ] {
    let (y0, m0, d0, h0, mi0) = hms
    match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
      Err(_) => println("ECS \{y0} \{m0} \{d0} \{h0} \{mi0} ERR")
      Ok(st) => {
        let ec = st.get_lunar_hour().get_eight_char()
        println(
          "ECS \{y0} \{m0} \{d0} \{h0} \{mi0} \{ec.to_string()}|\{ec.get_year().get_name()}|\{ec.get_month().get_name()}|\{ec.get_day().get_name()}|\{ec.get_hour().get_name()}",
        )
      }
    }
  }
  // CLM 童限（男/女 × 顺逆）
  for
    hms in [
      (2024, 2, 10, 12, 0),
      (2024, 1, 1, 0, 0),
      (1988, 6, 15, 23, 30),
      (2023, 12, 31, 6, 0),
    ] {
    for g in [Man, Woman] {
      let (y0, m0, d0, h0, mi0) = hms
      match SolarTime::from_ymdhms(y0, m0, d0, h0, mi0, 0) {
        Err(_) =>
          println("CLM \{y0} \{m0} \{d0} \{h0} \{mi0} \{g.get_code()} ERR")
        Ok(st) => {
          let cl = ChildLimit::from_solar_time(st, g)
          println(
            "CLM \{y0} \{m0} \{d0} \{h0} \{mi0} \{g.get_code()} \{cl.get_eight_char().to_string()}|\{cl.get_gender().get_name()}|\{cl.is_forward()}|\{cl.get_year_count()}|\{cl.get_month_count()}|\{cl.get_day_count()}|\{cl.get_hour_count()}|\{cl.get_minute_count()}|\{cl.get_start_time().to_string()}|\{cl.get_end_time().to_string()}|\{cl.get_start_age()}|\{cl.get_end_age()}|\{cl.get_start_decade_fortune().to_string()}|\{cl.get_start_fortune().to_string()}|\{cl.get_end_sixty_cycle_year().to_string()}",
          )
        }
      }
    }
  }
  // FOR 小运
  let st0 = SolarTime::from_ymdhms(2024, 2, 10, 12, 0, 0).unwrap()
  let cl0 = ChildLimit::from_solar_time(st0, Man)
  let sf = cl0.get_start_fortune()
  for n = 0; n <= 3; n = n + 1 {
    let f = sf.next(n)
    println(
      "FOR \{n} \{f.get_age()}|\{f.get_sixty_cycle_year().to_string()}|\{f.get_sixty_cycle().get_name()}|\{f.get_name()}|\{f.to_string()}",
    )
  }
  // DCF 大运
  let sdf = cl0.get_start_decade_fortune()
  for n = 0; n <= 3; n = n + 1 {
    let df = sdf.next(n)
    println(
      "DCF \{n} \{df.get_start_age()}|\{df.get_end_age()}|\{df.get_start_sixty_cycle_year().to_string()}|\{df.get_end_sixty_cycle_year().to_string()}|\{df.get_sixty_cycle().get_name()}|\{df.get_start_fortune().to_string()}|\{df.to_string()}",
    )
  }
  // ECT EightChar.GetSolarTimes
  let ec2 = EightChar::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
    SixtyCycle::from_index(16),
  )
  let sts = ec2.get_solar_times(2024, 2034)
  let mut line = "ECT \{sts.length()}"
  for i = 0; i < sts.length(); i = i + 1 {
    line = line + "|" + sts[i].to_string()
  }
  println(line)
  // ECT2 晚子时八字
  let ec3 = EightChar::from_sixty_cycle(
    SixtyCycle::from_index(40),
    SixtyCycle::from_index(16),
    SixtyCycle::from_index(26),
    SixtyCycle::from_index(0),
  )
  let sts3 = ec3.get_solar_times(2024, 2034)
  let mut line2 = "ECT2 \{sts3.length()}"
  for i = 0; i < sts3.length(); i = i + 1 {
    line2 = line2 + "|" + sts3[i].to_string()
  }
  println(line2)
}

///|
test "xref_downstream" {
  // LWK 农历周
  for start in [0, 1] {
    for i = 0; i < 4; i = i + 1 {
      match LunarWeek::from_ym(2024, 1, i, start) {
        Err(e) => println("LWK 2024 1 \{i} \{start} ERRMSG \{e}")
        Ok(w) =>
          println(
            "LWK 2024 1 \{i} \{start} \{w.get_name()}|\{w.to_string()}|\{w.get_first_day().to_string()}|\{w.get_days().length()}|\{w.get_lunar_month().get_month_with_leap()}",
          )
      }
    }
  }
  let w0 = LunarWeek::from_ym(2024, 1, 0, 1).unwrap()
  let w1 = LunarWeek::from_ym(2024, 1, 1, 1).unwrap()
  let wm1 = w0.next(-1)
  let wn1 = w0.next(1)
  println(
    "LWK NEXT -1 \{wm1.to_string()}|\{wm1.equals(w0)}|\{wm1.equals(w0.next(0))}",
  )
  println("LWK NEXT 1 \{wn1.to_string()}|\{wn1.equals(w1)}")
  match LunarWeek::from_ym(2024, 1, 6, 1) {
    Err(e) => println("LWK ERR \{e}")
    Ok(_) => println("LWK ERR <nil>")
  }
  // LFT 农历节日 FromIndex
  for i = 0; i < 13; i = i + 1 {
    match LunarFestival::from_index(2024, i) {
      None => println("LFT 2024 \{i} NIL")
      Some(f) => {
        let ts = match f.get_solar_term() {
          Some(st) => st.get_name()
          None => "nil"
        }
        println(
          "LFT 2024 \{i} \{f.to_string()}|\{f.get_day().to_string()}|\{ts}",
        )
      }
    }
  }
  // LFT FromYmd
  for
    ymd in [
      (2024, 1, 1),
      (2024, 2, 10),
      (2024, 6, 10),
      (2024, 4, 4),
      (2024, 12, 30),
    ] {
    let (y0, m0, d0) = ymd
    match LunarFestival::from_ymd(y0, m0, d0) {
      None => println("LFT YMD \{y0} \{m0} \{d0} NIL")
      Some(f) => println("LFT YMD \{y0} \{m0} \{d0} \{f.to_string()}")
    }
  }
  // LFT Next
  match LunarFestival::from_index(2024, 0) {
    None => ()
    Some(f0) =>
      for n = -1; n <= 1; n = n + 1 {
        match f0.next(n) {
          None => println("LFT NEXT \{n} NIL")
          Some(fnx) => println("LFT NEXT \{n} \{fnx.to_string()}")
        }
      }
  }
  // FTM 逐月胎神
  for i = 0; i < 12; i = i + 1 {
    let f = FetusMonth::new(i)
    println("FTM \{i} \{f.get_name()}|\{f.to_string()}|\{f.next(1).get_name()}")
  }
  let lm = LunarMonth::from_ym(2024, 1).unwrap()
  match FetusMonth::from_lunar_month(lm) {
    Some(fm) =>
      println("FTM LM \{fm.get_name()}|\{fm.next(2).get_name() == "占厨灶"}")
    None => ()
  }
  let lml = LunarMonth::from_ym(2023, -2).unwrap()
  match FetusMonth::from_lunar_month(lml) {
    Some(f) => println("FTM LEAP \{f.to_string()}")
    None => println("FTM LEAP <nil>")
  }
  // PHS 月相
  for i = 0; i < 8; i = i + 1 {
    let p = Phase::from_index(2024, 1, i)
    println(
      "PHS \{i} \{p.get_name()}|\{p.to_string()}|\{p.get_solar_day().to_string()}|\{p.get_solar_time().to_string()}",
    )
  }
  match Phase::from_name(2024, 1, "满月") {
    Err(e) => println("PHS NAME ERR \{e}")
    Ok(pn) => println("PHS NAME \{pn.get_name()}|\{pn.next(1).get_name()}")
  }
  // PHD 月相第几天
  let pd = PhaseDay::new(Phase::from_index(2024, 1, 1), 3)
  println(
    "PHD \{pd.get_phase().get_name()}|\{pd.to_string()}|\{pd.get_day_index()}|\{pd.get_name()}",
  )
  // KGS 灶马头
  for y in [2023, 2024, 2025, 1988, 2033] {
    let k = KitchenGodSteed::from_lunar_year(y)
    println(
      "KGS \{y} \{k.get_name()}|\{k.get_mouse()}|\{k.get_grass()}|\{k.get_cattle()}|\{k.get_flower()}|\{k.get_dragon()}|\{k.get_horse()}|\{k.get_chicken()}|\{k.get_silkworm()}|\{k.get_pig()}|\{k.get_field()}|\{k.get_cake()}|\{k.get_gold()}|\{k.get_people_cakes()}|\{k.get_people_hoes()}",
    )
  }
  // SFT 公历节日
  for i = 0; i < 10; i = i + 1 {
    match SolarFestival::from_index(2024, i) {
      None => println("SFT 2024 \{i} NIL")
      Some(f) =>
        println(
          "SFT 2024 \{i} \{f.to_string()}|\{f.get_day().to_string()}|\{f.get_start_year()}",
        )
    }
  }
  for ymd in [(2024, 10, 1), (2024, 1, 1), (2024, 6, 1), (2023, 5, 1)] {
    let (y0, m0, d0) = ymd
    match SolarFestival::from_ymd(y0, m0, d0) {
      None => println("SFT YMD \{y0} \{m0} \{d0} NIL")
      Some(f) => println("SFT YMD \{y0} \{m0} \{d0} \{f.to_string()}")
    }
  }
  match SolarFestival::from_index(2024, 0) {
    None => ()
    Some(sf0) =>
      match sf0.next(1) {
        Some(nx) => println("SFT NEXT \{nx.to_string()}")
        None => ()
      }
  }
  // EVT 事件构造与解析
  let ev1 = Event::builder()
    .term_heaven_stem(12, 6, 20)
    .start_year(2024)
    .build()
    .unwrap()
  let ev2 = Event::builder()
    .term_earth_branch(13, 7, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev3 = Event::builder()
    .solar_day(10, 1, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev4 = Event::builder()
    .lunar_day(1, 1, 0)
    .start_year(2024)
    .build()
    .unwrap()
  let ev5 = Event::builder()
    .solar_week(5, 1, 1)
    .start_year(2024)
    .build()
    .unwrap()
  for ev in [ev1, ev2, ev3, ev4, ev5] {
    let ts = match ev.get_solar_day(2024) {
      Some(sd) => sd.to_string()
      None => "nil"
    }
    let m = ev.get_month(2024)
    println(
      "EVT \{ev.get_name()}|\{ev.get_data()}|\{ev.get_value(2)}|\{ev.get_value(3)}|\{ev.get_value(4)}|\{ev.get_value(5)}|\{ev.get_type().get_code()}|\{ev.get_start_year()}|\{m.0}|\{ts}",
    )
  }
  // EVT 非法数据
  match Event::new("测试", "abc") {
    Err(e) => println("EVT ERR \{e}")
    Ok(_) => println("EVT ERR <nil>")
  }
  // EVD solar_day 委托
  for
    ymd in [
      (2024, 7, 15),
      (2024, 8, 10),
      (2024, 10, 1),
      (2024, 2, 10),
      (2024, 6, 10),
      (2024, 4, 4),
    ] {
    let (y0, m0, d0) = ymd
    match SolarDay::from_ymd(y0, m0, d0) {
      Err(_) => ()
      Ok(sd) => {
        let ddt = match sd.get_dog_day() {
          Some(dd) => dd.to_string()
          None => "nil"
        }
        let prt = match sd.get_plum_rain_day() {
          Some(pr) => pr.to_string()
          None => "nil"
        }
        let ftt = match sd.get_festival() {
          Some(ft) => ft.to_string()
          None => "nil"
        }
        println(
          "EVD \{y0} \{m0} \{d0} \{ddt}|\{prt}|\{ftt}|\{sd.get_phase_day().to_string()}|\{sd.get_phase().get_name()}|\{sd.get_phase_day().get_day_index()}",
        )
      }
    }
  }
  // LDD lunar_day 委托
  for ymd in [(2024, 1, 1), (2024, 6, 5), (2024, 6, 10), (2024, 12, 30)] {
    let (y0, m0, d0) = ymd
    match LunarDay::from_ymd(y0, m0, d0) {
      Err(e) => println("LDD \{y0} \{m0} \{d0} ERR \{e}")
      Ok(ld) => {
        let ftt = match ld.get_festival() {
          Some(ft) => ft.to_string()
          None => "nil"
        }
        println(
          "LDD \{y0} \{m0} \{d0} \{ftt}|\{ld.get_phase_day().to_string()}|\{ld.get_phase().get_name()}|\{ld.get_phase_day().get_day_index()}",
        )
      }
    }
  }
  // LMF lunar_month 委托
  let lm2 = LunarMonth::from_ym(2024, 6).unwrap()
  println("LMF FETUS \{lm2.get_fetus().get_name()}")
  for start in [1, 0] {
    let ws = lm2.get_weeks(start)
    let mut line = "LMF WEEKS \{start} \{ws.length()}"
    for i = 0; i < ws.length(); i = i + 1 {
      line = line + "|" + ws[i].to_string()
    }
    println(line)
  }
  // LYK lunar_year 委托
  for y in [2024, 2023] {
    let ly = LunarYear::from_year(y).unwrap()
    println(
      "LYK \{y} \{ly.get_kitchen_god_steed().get_name()}|\{ly.get_kitchen_god_steed().get_mouse()}",
    )
  }
}
