///|
// ============ 八字神煞 V2 · 类2：以年支/日支查余支 ============
// 依据 shensha.json 的求法（三合局/方局/对冲/偏移）实现。

// hit_rest_branches 以第 basis 柱为基准，其余三支是否含 target
fn hit_rest_branches(ec : EightChar, basis : Int, target : EarthBranch) -> Bool {
  has_branch(branches_except(ec, basis), target)
}

// hit_year_or_day 以年支或日支为基准（f 把基准支映射为目标支），查其余三支

///|
fn hit_year_or_day(ec : EightChar, f : (EarthBranch) -> EarthBranch) -> Bool {
  hit_rest_branches(ec, 0, f(pillar_branch(ec, 0))) ||
  hit_rest_branches(ec, 2, f(pillar_branch(ec, 2)))
}

// hit_yima 驿马
// 古诀：申子辰马在寅, 寅午戌马在申, 巳酉丑马在亥, 亥卯未马在巳（三合局长生位之冲）
// 查法：以年、日支查余三支

///|
fn hit_yima(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (c, _, _) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(c).get_opposite()
  }
  hit_year_or_day(ec, f)
}

// hit_jiangxing 将星
// 古诀：子日子。丑日酉。寅日午。卯日卯。辰日子…（三合局中神）
// 查法：以年、日支查余支

///|
fn hit_jiangxing(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (_, d, _) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(d)
  }
  hit_year_or_day(ec, f)
}

// hit_huagai 华盖
// 古诀：寅午戌见戌, 亥卯未见未, 申子辰见辰, 巳酉丑见丑（三合局墓库）
// 查法：以年、日支查余支

///|
fn hit_huagai(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (_, _, m) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(m)
  }
  hit_year_or_day(ec, f)
}

// hit_zaisha 灾煞
// 古诀：申子辰见午, 亥卯未见酉, 寅午戌见子, 巳酉丑见卯（三合局中神之冲）
// 查法：以年支查余三支

///|
fn hit_zaisha(ec : EightChar) -> Bool {
  let (_, d, _) = san_he_pos(san_he_group(pillar_branch(ec, 0)))
  hit_rest_branches(ec, 0, EarthBranch::from_index(d).get_opposite())
}

// hit_jiesha 劫煞
// 古诀：寅午戌见亥，申子辰见巳，巳酉丑见寅，亥卯未见申（三合局墓库下一位）
// 查法：以年、日支查余三支

///|
fn hit_jiesha(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (_, _, m) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(m + 1)
  }
  hit_year_or_day(ec, f)
}

// hit_wangshen 亡神
// 古诀：寅午戌见巳, 亥卯未见寅, 巳酉丑见申, 申子辰见亥（三合局中神前一位）
// 查法：以年、日支查余三支

///|
fn hit_wangshen(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (_, d, _) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(d - 1)
  }
  hit_year_or_day(ec, f)
}

// hit_taohua 桃花（咸池）
// 古诀：申子辰在酉, 寅午戌在卯, 巳酉丑在午, 亥卯未在子（三合局长生下一位，沐浴位）
// 查法：以年、日支查余三支

///|
fn hit_taohua(ec : EightChar) -> Bool {
  fn f(b : EarthBranch) -> EarthBranch {
    let (c, _, _) = san_he_pos(san_he_group(b))
    EarthBranch::from_index(c + 1)
  }
  hit_year_or_day(ec, f)
}

// hit_guchen 孤辰
// 古诀：亥子丑人见寅为孤；寅卯辰人见巳为孤；巳午未人见申为孤；申酉戌人见亥为孤（方局末字下一位）
// 查法：以年支查余三支

///|
fn hit_guchen(ec : EightChar) -> Bool {
  let first = fang_ju_first(fang_ju_group(pillar_branch(ec, 0)))
  hit_rest_branches(ec, 0, EarthBranch::from_index(first.get_index() + 3))
}

// hit_guasu 寡宿
// 古诀：亥子丑人见戌为寡；寅卯辰人见丑为寡；巳午未人见辰为寡；申酉戌人见未为寡（方局首字前一位）
// 查法：以年支查余三支

///|
fn hit_guasu(ec : EightChar) -> Bool {
  let first = fang_ju_first(fang_ju_group(pillar_branch(ec, 0)))
  hit_rest_branches(ec, 0, EarthBranch::from_index(first.get_index() - 1))
}

// hit_hongluan 红鸾
// 古诀：红鸾年支子丑寅卯辰巳午未申酉戌亥 三地支见卯寅丑子亥戌酉申未午巳辰（年支 3-i）
// 查法：以年支查余地支

///|
fn hit_hongluan(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(3 - i))
}

// hit_tianxi 天喜
// 古诀：天喜年支子丑寅卯辰巳午未申酉戌亥 三地支见酉申未午巳辰卯寅丑子亥戌（年支 9-i，即红鸾之冲）
// 查法：以年支查余地支

///|
fn hit_tianxi(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(9 - i))
}

// hit_goujiao 勾绞煞
// 古诀：阳男阴女，命前三辰为勾，命后三辰为绞；阴男阳女反之。如甲子年生男，命前三辰卯为勾，命后三辰酉为绞。
// 查法：以年支查余三支（无论阴阳，勾绞的命中集合均为 年支±3，仅勾/绞标签互换）

///|
fn hit_goujiao(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(i + 3)) ||
  hit_rest_branches(ec, 0, EarthBranch::from_index(i - 3))
}

// hit_yuanchen 元辰
// 古诀：阳男阴女子年未…亥年午（年支+7）；阴男阳女子年巳…亥年辰（年支+5）
// 查法：以年支查余三支

///|
fn hit_yuanchen(ec : EightChar, gender : Gender) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  // 阳年干：甲丙戊庚壬（索引为偶数）
  let yang_year = year_stem % 2 == 0
  // 阳男阴女：阳年+男 或 阴年+女
  let yang_man_yin_woman = match (yang_year, gender) {
    (true, Man) => true
    (false, Woman) => true
    _ => false
  }
  if yang_man_yin_woman {
    hit_rest_branches(ec, 0, EarthBranch::from_index(i + 7))
  } else {
    hit_rest_branches(ec, 0, EarthBranch::from_index(i + 5))
  }
}

// hit_sangmen 丧门
// 查法：年支前两位为丧门（年支+2），以年支查余三支

///|
fn hit_sangmen(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(i + 2))
}

// hit_diaoke 吊客
// 查法：后两位为吊客（年支-2），以年支查余三支

///|
fn hit_diaoke(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(i - 2))
}

// hit_pima 披麻
// 查法：后三位为披麻（年支-3），以年支查余三支

///|
fn hit_pima(ec : EightChar) -> Bool {
  let i = pillar_branch(ec, 0).get_index()
  hit_rest_branches(ec, 0, EarthBranch::from_index(i - 3))
}
