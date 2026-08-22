///|
// ============ 八字神煞 V2 · 类3：以月支查 ============
// 依据 shensha.json 的求法（古诀/查法）实现。

// hit_tiande 天德贵人
// 古诀：寅月丁。卯月申。辰月壬。巳月辛。午月亥。未月甲。申月癸。酉月寅。戌月丙。亥月乙。子月巳。丑月庚。
// 查法：以月支查四柱干支（值为天干者查天干，为地支者查地支）
fn hit_tiande(ec : EightChar) -> Bool {
  let m = month_branch_index(ec)
  let stem_t = [-1, 6, 3, -1, 8, 7, -1, 0, 9, -1, 2, 1] // 丑庚 寅丁 辰壬 巳辛 未甲 申癸 戌丙 亥乙
  let branch_t = [5, -1, -1, 8, -1, -1, 11, -1, -1, 2, -1, -1] // 子巳 卯申 午亥 酉寅
  if stem_t[m] >= 0 && has_stem(ec, HeavenStem::from_index(stem_t[m])) {
    return true
  }
  if branch_t[m] >= 0 &&
    has_branch_all(ec, EarthBranch::from_index(branch_t[m])) {
    return true
  }
  false
}

// hit_yuede 月德贵人
// 古诀：寅午戌月生者见丙, 申子辰月生者见壬, 亥卯未月生者见甲, 巳酉丑月生者见庚。
// 查法：以月支查四柱天干

///|
fn hit_yuede(ec : EightChar) -> Bool {
  let g = san_he_group(pillar_branch(ec, 1))
  let stem = match g {
    0 => 8 // 水局见壬
    1 => 2 // 火局见丙
    2 => 6 // 金局见庚
    _ => 0 // 木局见甲
  }
  has_stem(ec, HeavenStem::from_index(stem))
}

// hit_tiandehe 天德合
// 古诀：天德与天干五合或地支六合者即为天德合。如正月见丁为天德，壬与丁合，壬即为天德合。

///|
fn hit_tiandehe(ec : EightChar) -> Bool {
  let m = month_branch_index(ec)
  let stem_t = [-1, 6, 3, -1, 8, 7, -1, 0, 9, -1, 2, 1]
  let branch_t = [5, -1, -1, 8, -1, -1, 11, -1, -1, 2, -1, -1]
  if stem_t[m] >= 0 {
    return has_stem(ec, HeavenStem::from_index(stem_t[m]).get_combine())
  }
  if branch_t[m] >= 0 {
    return has_branch_all(
      ec,
      EarthBranch::from_index(branch_t[m]).get_combine(),
    )
  }
  false
}

// hit_yuedehe 月德合
// 古诀：寅午戌见辛，申子辰见丁，巳酉丑见乙，亥卯未见己（月德之五合干）

///|
fn hit_yuedehe(ec : EightChar) -> Bool {
  let g = san_he_group(pillar_branch(ec, 1))
  let stem = match g {
    0 => 3 // 水局壬 → 丁
    1 => 7 // 火局丙 → 辛
    2 => 1 // 金局庚 → 乙
    _ => 5 // 木局甲 → 己
  }
  has_stem(ec, HeavenStem::from_index(stem))
}

// hit_tianshe 天赦日
// 古诀：春戊寅, 夏甲午, 秋戊申, 冬甲子。
// 查法：寅卯辰月生戊寅日, 巳午未月生甲午日, 申酉戌月生戊申日, 亥子丑月生甲子日（以月支查日柱）

///|
fn hit_tianshe(ec : EightChar) -> Bool {
  let s = season_of_month(ec)
  let day = ec.get_day().get_name()
  match s {
    0 => day == "戊寅"
    1 => day == "甲午"
    2 => day == "戊申"
    _ => day == "甲子"
  }
}

// hit_tianyi_star 天医
// 古诀：正月生见丑, 二月生见寅…十二月生见子（月支前一位）
// 查法：以月支查其他三支

///|
fn hit_tianyi_star(ec : EightChar) -> Bool {
  let m = month_branch_index(ec)
  hit_rest_branches(ec, 1, EarthBranch::from_index(m - 1))
}

// hit_xueren 血刃
// 古诀：寅月丑。卯月未。辰月寅。巳月申。午月卯。未月酉。申月辰。酉月戌。戌月巳。亥月亥。子月午。丑月子。
// 查法：以月支查四柱地支

///|
fn hit_xueren(ec : EightChar) -> Bool {
  let table = [6, 0, 1, 7, 2, 8, 3, 9, 4, 10, 5, 11] // 子午 丑子 寅丑 卯未 辰寅 巳申 午卯 未酉 申辰 酉戌 戌巳 亥亥
  let m = month_branch_index(ec)
  has_branch_all(ec, EarthBranch::from_index(table[m]))
}

// hit_sifei 四废日
// 古诀：春庚申辛酉，夏壬子癸亥，秋甲寅乙卯，冬丙午丁巳。
// 查法：以日柱见之即是（月令季节限定）

///|
fn hit_sifei(ec : EightChar) -> Bool {
  let s = season_of_month(ec)
  let day = ec.get_day().get_name()
  match s {
    0 => day == "庚申" || day == "辛酉"
    1 => day == "壬子" || day == "癸亥"
    2 => day == "甲寅" || day == "乙卯"
    _ => day == "丙午" || day == "丁巳"
  }
}

// hit_tianzhuan 天转
// 古诀：春兔夏马天地转，秋鸡冬鼠便为殃（寅卯辰月见乙卯日，巳午未月见丙午日，申酉戌月见辛酉日，亥子丑月见壬子日）
// 查法：以月支查日柱

///|
fn hit_tianzhuan(ec : EightChar) -> Bool {
  let s = season_of_month(ec)
  let day = ec.get_day().get_name()
  match s {
    0 => day == "乙卯"
    1 => day == "丙午"
    2 => day == "辛酉"
    _ => day == "壬子"
  }
}

// hit_dizhuan 地转
// 古诀：春季辛卯日，夏季戊午日，秋季癸酉日，冬季丙子日。
// 查法：以月支查日柱

///|
fn hit_dizhuan(ec : EightChar) -> Bool {
  let s = season_of_month(ec)
  let day = ec.get_day().get_name()
  match s {
    0 => day == "辛卯"
    1 => day == "戊午"
    2 => day == "癸酉"
    _ => day == "丙子"
  }
}

// hit_dexiu 德秀贵人
// 古诀：寅午戌月, 丙丁为德, 戊癸为秀；申子辰月, 壬癸戊己为德, 丙辛甲己为秀；巳酉丑月, 庚辛为德, 乙庚为秀；亥卯未月, 甲乙为德, 丁壬为秀。
// 查法：以月令查四柱天干

///|
fn hit_dexiu(ec : EightChar) -> Bool {
  let g = san_he_group(pillar_branch(ec, 1))
  let stems = match g {
    0 => [8, 9, 4, 5, 2, 7, 0, 5] // 水局：壬癸戊己 德，丙辛甲己 秀
    1 => [2, 3, 4, 9] // 火局：丙丁 德，戊癸 秀
    2 => [6, 7, 1, 6] // 金局：庚辛 德，乙庚 秀
    _ => [0, 1, 3, 8] // 木局：甲乙 德，丁壬 秀
  }
  for s in stems {
    if has_stem(ec, HeavenStem::from_index(s)) {
      return true
    }
  }
  false
}
