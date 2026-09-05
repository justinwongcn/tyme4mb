// 测试套件：EarthlyBranch（对应 Go test/EarthlyBranch_test.go，一比一翻译）

///|
test "earthly_branch_0" {
  expect_eq(
    EarthBranch::from_index(0).get_name(),
    "子",
    "EarthBranch.FromIndex(0).GetName()",
  )
}

///|
// earth_branch_1 六冲
test "earthly_branch_1" {
  let d = EarthBranch::from_name("子").unwrap()
  expect_eq(
    d.get_opposite().get_name(),
    "午",
    "EarthBranch(子).GetOpposite().GetName()",
  )
}

///|
// earth_branch_2 六合
test "earthly_branch_2" {
  let d = EarthBranch::from_name("申").unwrap()
  expect_eq(
    d.get_combine().get_name(),
    "巳",
    "EarthBranch(申).GetCombine().GetName()",
  )
}

///|
// earth_branch_3 六害
test "earthly_branch_3" {
  let d = EarthBranch::from_name("巳").unwrap()
  expect_eq(
    d.get_harm().get_name(),
    "寅",
    "EarthBranch(巳).GetHarm().GetName()",
  )
}

///|
// earth_branch_4 合化
test "earthly_branch_4" {
  let a = EarthBranch::from_name("卯").unwrap()
  let b = EarthBranch::from_name("戌").unwrap()
  expect_eq(
    a.combine(b).unwrap().get_name(),
    "火",
    "EarthBranch(卯).Combine(戌).GetName()",
  )
}

///|
// earth_branch_5 卯子无法合化，Combine 应返回 None
test "earthly_branch_5" {
  let a = EarthBranch::from_name("卯").unwrap()
  let b = EarthBranch::from_name("子").unwrap()
  expect_true(
    match a.combine(b) {
      None => true
      Some(_) => false
    },
    "EarthBranch(卯).Combine(子) 应返回 None",
  )
}

///|
// earth_branch_6 六破（子酉破、丑辰破、寅亥破、卯午破、巳申破、戌未破），互破对称
test "earthly_branch_6" {
  let pairs = [
    ("子", "酉"),
    ("丑", "辰"),
    ("寅", "亥"),
    ("卯", "午"),
    ("巳", "申"),
    ("戌", "未"),
  ]
  for p in pairs {
    let a = EarthBranch::from_name(p.0).unwrap()
    let b = EarthBranch::from_name(p.1).unwrap()
    expect_eq(
      a.get_po().get_name(),
      p.1,
      "EarthBranch(\{p.0}).GetPo().GetName()",
    )
    expect_eq(
      b.get_po().get_name(),
      p.0,
      "EarthBranch(\{p.1}).GetPo().GetName()",
    )
  }
}

///|
// earth_branch_7 三合局五行（申子辰合水局，寅午戌合火局，巳酉丑合金局，亥卯未合木局）
test "earthly_branch_7" {
  let groups = [
    (["申", "子", "辰"], "水"),
    (["寅", "午", "戌"], "火"),
    (["巳", "酉", "丑"], "金"),
    (["亥", "卯", "未"], "木"),
  ]
  for g in groups {
    for name in g.0 {
      let b = EarthBranch::from_name(name).unwrap()
      expect_eq(
        b.get_san_he_element().get_name(),
        g.1,
        "EarthBranch(\{name}).GetSanHeElement().GetName()",
      )
    }
  }
}

///|
// earth_branch_8 三会方局五行与方位（亥子丑会北方水，寅卯辰会东方木，巳午未会南方火，申酉戌会西方金）
test "earthly_branch_8" {
  let groups = [
    (["亥", "子", "丑"], "水", "北"),
    (["寅", "卯", "辰"], "木", "东"),
    (["巳", "午", "未"], "火", "南"),
    (["申", "酉", "戌"], "金", "西"),
  ]
  for g in groups {
    for name in g.0 {
      let b = EarthBranch::from_name(name).unwrap()
      expect_eq(
        b.get_san_hui_element().get_name(),
        g.1,
        "EarthBranch(\{name}).GetSanHuiElement().GetName()",
      )
      expect_eq(
        b.get_san_hui_direction().get_name(),
        g.2,
        "EarthBranch(\{name}).GetSanHuiDirection().GetName()",
      )
    }
  }
}

///|
// earthly_branch_9 地支绝（子巳、亥午、寅酉、卯申）
test "earthly_branch_9" {
  let pairs = [("子", "巳"), ("亥", "午"), ("寅", "酉"), ("卯", "申")]
  for p in pairs {
    let a = EarthBranch::from_name(p.0).unwrap()
    let b = EarthBranch::from_name(p.1).unwrap()
    expect_eq(a.get_jue().unwrap().get_name(), p.1, "绝关系正向")
    expect_eq(b.get_jue().unwrap().get_name(), p.0, "绝关系反向")
  }
  for name in ["丑", "辰", "未", "戌"] {
    expect_true(
      EarthBranch::from_name(name).unwrap().get_jue() is None,
      "土支不绝",
    )
  }
}

///|
// earthly_branch_10 三刑与自刑
test "earthly_branch_10" {
  let groups = [
    ("寅", ["巳", "申"]),
    ("巳", ["寅", "申"]),
    ("申", ["寅", "巳"]),
    ("丑", ["未", "戌"]),
    ("未", ["丑", "戌"]),
    ("戌", ["丑", "未"]),
    ("子", ["卯"]),
    ("卯", ["子"]),
    ("辰", ["辰"]),
    ("午", ["午"]),
    ("酉", ["酉"]),
    ("亥", ["亥"]),
  ]
  for g in groups {
    let actual = EarthBranch::from_name(g.0).unwrap().get_xing()
    expect_eq(actual.length(), g.1.length(), "刑关系数量")
    for i in 0..<g.1.length() {
      expect_eq(actual[i].get_name(), g.1[i], "刑关系成员")
    }
  }
}

///|
// earthly_branch_11 暗合（寅丑、卯申、午亥）
test "earthly_branch_11" {
  let pairs = [("寅", "丑"), ("卯", "申"), ("午", "亥")]
  for p in pairs {
    let a = EarthBranch::from_name(p.0).unwrap()
    let b = EarthBranch::from_name(p.1).unwrap()
    expect_eq(a.get_an_he().unwrap().get_name(), p.1, "暗合正向")
    expect_eq(b.get_an_he().unwrap().get_name(), p.0, "暗合反向")
  }
  for name in ["子", "辰", "巳", "未", "酉", "戌"] {
    expect_true(
      EarthBranch::from_name(name).unwrap().get_an_he() is None,
      "非暗合地支",
    )
  }
}
