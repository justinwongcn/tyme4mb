///|
// ============ 八字神煞 V2 · 类5：特殊规则 ============
// 依据 shensha.json 的求法（古诀/查法）实现。

// hit_sanqi 三奇贵人
// 古诀：天上三奇甲戊庚，地下三奇乙丙丁，人中三奇壬癸辛
// 查法：三天干相连（要不相隔而紧连，按顺布而排）
fn hit_sanqi(ec : EightChar) -> Bool {
  let stems = [
    pillar_stem(ec, 0).get_index(),
    pillar_stem(ec, 1).get_index(),
    pillar_stem(ec, 2).get_index(),
    pillar_stem(ec, 3).get_index(),
  ]
  let groups = [[0, 4, 6], [1, 2, 3], [8, 9, 7]] // 甲戊庚 乙丙丁 壬癸辛
  for g in groups {
    if (stems[0] == g[0] && stems[1] == g[1] && stems[2] == g[2]) ||
      (stems[1] == g[0] && stems[2] == g[1] && stems[3] == g[2]) {
      return true
    }
  }
  false
}

// hit_kongwang 空亡
// 古诀：甲子旬在戌亥。甲戌旬在申酉。甲申旬在午未。甲午旬在辰巳。甲辰旬在寅卯。甲寅旬在子丑。（旬空）
// 查法：以日/年柱，见余三地支

///|
fn hit_kongwang(ec : EightChar) -> Bool {
  let day_kw = ec.get_day().get_extra_earth_branches()
  let year_kw = ec.get_year().get_extra_earth_branches()
  // 以日柱为空亡基准：查年月时三支
  if has_branch(branches_except(ec, 2), day_kw[0]) ||
    has_branch(branches_except(ec, 2), day_kw[1]) {
    return true
  }
  // 以年柱为空亡基准：查月日时三支
  if has_branch(branches_except(ec, 0), year_kw[0]) ||
    has_branch(branches_except(ec, 0), year_kw[1]) {
    return true
  }
  false
}

// hit_tianluodiwang 天罗地网
// 古诀：凡纳音火命，见戌亥日为天罗；水土命，见辰巳日为地网，金木二命无之。

///|
fn hit_tianluodiwang(ec : EightChar) -> Bool {
  let e = year_sound_element(ec) // 木0 火1 土2 金3 水4
  let day_branch = pillar_branch(ec, 2).get_index()
  if e == 1 {
    // 火命见戌亥日（戌10 亥11）为天罗
    return day_branch == 10 || day_branch == 11
  }
  if e == 2 || e == 4 {
    // 水土命见辰巳日（辰4 巳5）为地网
    return day_branch == 4 || day_branch == 5
  }
  false
}

// hit_tongzisha 童子煞
// 古诀：春秋寅子贵，冬夏卯未辰；金木马卯合，水火鸡犬多；土命逢辰巳，童子定不错。
// 查法（5条规则，任一命中即中）：
// 1. 春秋月生，日支或时支见寅或子
// 2. 冬夏月生，日支或时支见卯、未或辰
// 3. 年柱纳音金或木，日支或时支见午或卯
// 4. 年柱纳音水或火，日支或时支见酉或戌
// 5. 年柱纳音土，日支或时支见辰或巳

///|
fn hit_tongzisha(ec : EightChar) -> Bool {
  let s = season_of_month(ec) // 0春 1夏 2秋 3冬
  let day_b = pillar_branch(ec, 2).get_index()
  let hour_b = pillar_branch(ec, 3).get_index()
  // 条件1：春秋月见寅(2)或子(0)
  if (s == 0 || s == 2) &&
    ((day_b == 2 || day_b == 0) || hour_b == 2 || hour_b == 0) {
    return true
  }
  // 条件2：冬夏月见卯(3)、未(7)或辰(4)
  if (s == 1 || s == 3) &&
    (
      (day_b == 3 || day_b == 7 || day_b == 4) ||
      hour_b == 3 ||
      hour_b == 7 ||
      hour_b == 4
    ) {
    return true
  }
  let e = year_sound_element(ec)
  // 条件3：金(3)木(0)命见午(6)或卯(3)
  if (e == 3 || e == 0) &&
    ((day_b == 6 || day_b == 3) || hour_b == 6 || hour_b == 3) {
    return true
  }
  // 条件4：水(4)火(1)命见酉(9)或戌(10)
  if (e == 4 || e == 1) &&
    ((day_b == 9 || day_b == 10) || hour_b == 9 || hour_b == 10) {
    return true
  }
  // 条件5：土(2)命见辰(4)或巳(5)
  if e == 2 && ((day_b == 4 || day_b == 5) || hour_b == 4 || hour_b == 5) {
    return true
  }
  false
}
