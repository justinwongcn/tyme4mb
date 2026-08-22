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
