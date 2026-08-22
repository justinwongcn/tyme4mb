///|
// ============ 八字神煞 V2 · 类1：以日干/年干查地支 ============
// 依据 shensha.json 的求法（古诀/查法）实现。
// 约定：四柱（年/月/日/时）任一支命中即中；如注明"以日/年干"，则日干、年干任一作基准均可。

// hit_tianyi 天乙贵人
// 古诀：甲戊庚牛羊, 乙己鼠猴乡, 丙丁猪鸡位, 壬癸兔蛇藏, 六辛逢虎马
// 查法：以日/年干查四地支
fn hit_tianyi(ec : EightChar) -> Bool {
  // 天干 → 地支表（索引0-9对应甲乙丙丁戊己庚辛壬癸，值为命中地支集合）
  let table = [
    [1, 7], // 甲: 丑、未
    [0, 8], // 乙: 子、申
    [10, 11], // 丙: 戌、亥
    [10, 11], // 丁: 戌、亥
    [1, 7], // 戊: 丑、未
    [0, 8], // 己: 子、申
    [1, 7], // 庚: 丑、未
    [2, 6], // 辛: 寅、午
    [3, 9], // 壬: 卯、酉
    [3, 9], // 癸: 卯、酉
  ]
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  let bs = all_branches(ec)
  has_branch(bs, EarthBranch::from_index(table[day_stem][0])) ||
  has_branch(bs, EarthBranch::from_index(table[day_stem][1])) ||
  has_branch(bs, EarthBranch::from_index(table[year_stem][0])) ||
  has_branch(bs, EarthBranch::from_index(table[year_stem][1]))
}

// hit_lushen 禄神
// 古诀：甲禄寅。乙禄卯。丙禄巳。丁禄午。戊禄巳。己禄午。庚禄申。辛禄酉。壬禄亥。癸禄子。
// 查法：以日干查四地支

///|
fn hit_lushen(ec : EightChar) -> Bool {
  let table = [2, 3, 5, 6, 5, 6, 8, 9, 11, 0]
  let day_stem = pillar_stem(ec, 2).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem]))
}

// hit_taiji 太极贵人
// 古诀：甲乙生人子午中，丙丁鸡兔定亨通，戊己两干临四季，庚辛寅亥禄丰隆，壬癸巳申偏喜美
// 查法：以日/年干查四地支

///|
fn hit_taiji(ec : EightChar) -> Bool {
  let table = [
    [0, 6], // 甲: 子、午
    [0, 6], // 乙: 子、午
    [3, 9], // 丙: 卯、酉
    [3, 9], // 丁: 卯、酉
    [1, 4, 7, 10], // 戊: 辰戌丑未(四季)
    [1, 4, 7, 10], // 己: 辰戌丑未(四季)
    [2, 11], // 庚: 寅、亥
    [2, 11], // 辛: 寅、亥
    [5, 8], // 壬: 巳、申
    [5, 8], // 癸: 巳、申
  ]
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  for v in table[day_stem] {
    if has_branch_all(ec, EarthBranch::from_index(v)) {
      return true
    }
  }
  for v in table[year_stem] {
    if has_branch_all(ec, EarthBranch::from_index(v)) {
      return true
    }
  }
  false
}

// hit_xuetang 学堂
// 古诀：纳音之长生。金命见巳，木命见亥，水命见申，土命见申，火命见寅。
// 查法：以年/日柱纳音查地支

///|
fn hit_xuetang(ec : EightChar) -> Bool {
  // 年柱纳音五行 → 学堂支（纳音长生：金巳 木亥 水申 土申 火寅）
  let y_sound = year_sound_element(ec)
  let day_sound = sound_element(ec.get_day().get_sound().get_index())
  let b = [11, 2, 8, 5, 8] // 木亥 火寅 土申 金巳 水申
  has_branch_all(ec, EarthBranch::from_index(b[y_sound])) ||
  has_branch_all(ec, EarthBranch::from_index(b[day_sound]))
}

// hit_cinguan 词馆
// 古诀：纳音之临官（金命见申，木命见寅，水命见亥，火命见巳，土命见亥）
// 查法：以年/日柱纳音查地支（纳音临官位；shensha.json 原文误与学堂相同，此处按标准临官位实现）
// 依据《三命通会·论学堂词馆》"水土长生申，临官亥"：纳音体系水土同宫，土临官=亥

///|
fn hit_cinguan(ec : EightChar) -> Bool {
  let b = [2, 5, 11, 8, 11] // 木寅 火巳 土亥 金申 水亥（临官）
  let y_sound = year_sound_element(ec)
  let day_sound = sound_element(ec.get_day().get_sound().get_index())
  has_branch_all(ec, EarthBranch::from_index(b[y_sound])) ||
  has_branch_all(ec, EarthBranch::from_index(b[day_sound]))
}

// hit_guoyin 国印贵人
// 古诀：甲见戌, 乙见亥, 丙见丑, 丁见寅, 戊见丑, 己见寅, 庚见辰, 辛见巳, 壬见未, 癸见申。
// 查法：以年、日干查四支

///|
fn hit_guoyin(ec : EightChar) -> Bool {
  let table = [10, 11, 1, 2, 1, 2, 4, 5, 7, 8]
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem])) ||
  has_branch_all(ec, EarthBranch::from_index(table[year_stem]))
}

// hit_wenchang 文昌贵人
// 古诀：甲日巳。乙日午。丙日申。丁日酉。戊日申。己日酉。庚日亥。辛日子。壬日寅。癸日卯。
// 查法：以日/年干查四地支

///|
fn hit_wenchang(ec : EightChar) -> Bool {
  let table = [5, 6, 8, 9, 8, 9, 11, 0, 2, 3]
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem])) ||
  has_branch_all(ec, EarthBranch::from_index(table[year_stem]))
}

// hit_jinyu 金舆
// 古诀：甲龙乙蛇丙戊羊, 丁己猴歌庚犬方, 辛猪壬牛癸逢虎
// 查法：以日/年干查四地支

///|
fn hit_jinyu(ec : EightChar) -> Bool {
  let table = [4, 5, 7, 8, 7, 8, 10, 11, 1, 2] // 甲辰 乙巳 丙未 丁申 戊未 己申 庚戌 辛亥 壬丑 癸寅
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem])) ||
  has_branch_all(ec, EarthBranch::from_index(table[year_stem]))
}

// hit_yangren 羊刃
// 古诀：甲日卯。乙日寅。丙日午。丁日巳。戊日午。己日巳。庚日酉。辛日申。壬日子。癸日亥。
// 查法：以日干查四地支

///|
fn hit_yangren(ec : EightChar) -> Bool {
  let table = [3, 2, 6, 5, 6, 5, 9, 8, 0, 11]
  let day_stem = pillar_stem(ec, 2).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem]))
}

// hit_feiren 飞刃
// 古诀：羊刃的六冲（甲刃在卯，见酉为飞刃，其余类推）
// 查法：以日干查四地支

///|
fn hit_feiren(ec : EightChar) -> Bool {
  let table = [3, 2, 6, 5, 6, 5, 9, 8, 0, 11] // 羊刃表
  let day_stem = pillar_stem(ec, 2).get_index()
  let yang_ren = table[day_stem]
  let fei = EarthBranch::from_index(yang_ren).get_opposite()
  has_branch_all(ec, fei)
}

// hit_liuxia 流霞
// 古诀：甲日酉。乙日戌。丙日未。丁日申。戊日巳。己日午。庚日辰。辛日卯。壬日亥。癸日寅。
// 查法：以日干查四地支

///|
fn hit_liuxia(ec : EightChar) -> Bool {
  let table = [9, 10, 7, 8, 5, 6, 4, 3, 11, 2]
  let day_stem = pillar_stem(ec, 2).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem]))
}

// hit_hongyan 红艳煞
// 古诀：甲日午。乙日午。丙日寅。丁日未。戊日辰。己日辰。庚日戌。辛日酉。壬日子。癸日申。
// 查法：以日干查四地支

///|
fn hit_hongyan(ec : EightChar) -> Bool {
  let table = [6, 6, 2, 7, 4, 4, 10, 9, 0, 8]
  let day_stem = pillar_stem(ec, 2).get_index()
  has_branch_all(ec, EarthBranch::from_index(table[day_stem]))
}

// hit_tianchu 天厨贵人
// 查法：以年干、日干查余四支（丙干见巳，丁干见午，戊干见申，己干见酉，庚干见亥，辛干见子，壬干见寅，癸干见卯）

///|
fn hit_tianchu(ec : EightChar) -> Bool {
  let table = [0, 0, 5, 6, 8, 9, 11, 0, 2, 3] // 甲丙见巳…（甲无查法，默认0不命中；实际甲干无天厨）
  let day_stem = pillar_stem(ec, 2).get_index()
  let year_stem = pillar_stem(ec, 0).get_index()
  let bs = all_branches(ec)
  if day_stem >= 2 && day_stem <= 9 {
    let b = EarthBranch::from_index(table[day_stem])
    if has_branch(bs, b) {
      return true
    }
  }
  if year_stem >= 2 && year_stem <= 9 {
    let b = EarthBranch::from_index(table[year_stem])
    if has_branch(bs, b) {
      return true
    }
  }
  false
}

// hit_fuxing 福星贵人
// 古诀：凡甲、丙两干见寅或子，乙、癸两干见卯或丑，戊干见申，己干见未，丁干见亥，庚干见午，辛干见巳，壬干见辰是也。
// 查法：以年/月干查地支

///|
fn hit_fuxing(ec : EightChar) -> Bool {
  let table = [
    [2, 0], // 甲: 寅、子
    [3, 1], // 乙: 卯、丑
    [2, 0], // 丙: 寅、子
    [11], // 丁: 亥
    [8], // 戊: 申
    [7], // 己: 未
    [6], // 庚: 午
    [5], // 辛: 巳
    [4], // 壬: 辰
    [3, 1], // 癸: 卯、丑
  ]
  let stems = [pillar_stem(ec, 0), pillar_stem(ec, 1)]
  let bs = all_branches(ec)
  for s in stems {
    for v in table[s.get_index()] {
      if has_branch(bs, EarthBranch::from_index(v)) {
        return true
      }
    }
  }
  false
}
