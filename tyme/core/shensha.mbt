///|
// shensha_names 八字神煞 V2 名称（顺序与 shensha.json 的 55 条神煞一一对应，索引+1 = json id）
pub fn shensha_names() -> Array[String] {
  [
    "天乙贵人", "天德贵人", "月德贵人", "天德合", "月德合", "天赦日",
    "禄神", "驿马", "太极贵人", "将星", "学堂", "词馆", "国印贵人",
    "三奇贵人", "文昌贵人", "华盖", "天医", "金舆", "空亡", "灾煞",
    "劫煞", "亡神", "羊刃", "飞刃", "血刃", "流霞", "四废日", "天罗地网",
    "桃花", "孤辰", "寡宿", "阴差阳错", "魁罡", "孤鸾煞", "红鸾",
    "天喜", "勾绞煞", "红艳煞", "十恶大败", "元辰", "金神", "天转",
    "地转", "丧门", "吊客", "披麻", "十灵日", "六秀日", "八专", "九丑",
    "童子煞", "天厨贵人", "福星贵人", "德秀贵人", "拱禄",
  ]
}

///|
// ShenSha 八字神煞（V2，基于 shensha.json 求法）
pub struct ShenSha {
  loop_tyme : LoopTyme
}

///|
pub fn ShenSha::from_index(index : Int) -> ShenSha {
  { loop_tyme: LoopTyme::from_index(shensha_names(), index), }
}

///|
pub fn ShenSha::from_name(name : String) -> Result[ShenSha, String] {
  match LoopTyme::from_name(shensha_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
// get_id 神煞编号（1~55，与 shensha.json 的 id 一致）
pub fn ShenSha::get_id(self : ShenSha) -> Int {
  self.loop_tyme.get_index() + 1
}

///|
pub fn ShenSha::get_name(self : ShenSha) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Culture for ShenSha with fn get_name(self : ShenSha) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for ShenSha with fn to_string(self : ShenSha) -> String {
  self.loop_tyme.get_name()
}

///|
// get_from_eight_char 八字神煞 V2 求法聚合入口
// 依据 shensha.json 的 55 条求法规则，返回命中所带神煞（按五类求法分组顺序，组内按枚举序）
pub fn ShenSha::get_from_eight_char(
  eight_char : EightChar,
  gender : Gender,
) -> Array[ShenSha] {
  let l : Array[ShenSha] = []
  // 以日/年干查地支类
  if hit_tianyi(eight_char) {
    l.push(ShenSha::from_index(0))
  }
  if hit_lushen(eight_char) {
    l.push(ShenSha::from_index(6))
  }
  if hit_taiji(eight_char) {
    l.push(ShenSha::from_index(8))
  }
  if hit_xuetang(eight_char) {
    l.push(ShenSha::from_index(10))
  }
  if hit_cinguan(eight_char) {
    l.push(ShenSha::from_index(11))
  }
  if hit_guoyin(eight_char) {
    l.push(ShenSha::from_index(12))
  }
  if hit_wenchang(eight_char) {
    l.push(ShenSha::from_index(14))
  }
  if hit_jinyu(eight_char) {
    l.push(ShenSha::from_index(17))
  }
  if hit_yangren(eight_char) {
    l.push(ShenSha::from_index(22))
  }
  if hit_feiren(eight_char) {
    l.push(ShenSha::from_index(23))
  }
  if hit_liuxia(eight_char) {
    l.push(ShenSha::from_index(25))
  }
  if hit_hongyan(eight_char) {
    l.push(ShenSha::from_index(37))
  }
  if hit_tianchu(eight_char) {
    l.push(ShenSha::from_index(51))
  }
  if hit_fuxing(eight_char) {
    l.push(ShenSha::from_index(52))
  }
  // 以年/日支查余支类
  if hit_yima(eight_char) {
    l.push(ShenSha::from_index(7))
  }
  if hit_jiangxing(eight_char) {
    l.push(ShenSha::from_index(9))
  }
  if hit_huagai(eight_char) {
    l.push(ShenSha::from_index(15))
  }
  if hit_zaisha(eight_char) {
    l.push(ShenSha::from_index(19))
  }
  if hit_jiesha(eight_char) {
    l.push(ShenSha::from_index(20))
  }
  if hit_wangshen(eight_char) {
    l.push(ShenSha::from_index(21))
  }
  if hit_taohua(eight_char) {
    l.push(ShenSha::from_index(28))
  }
  if hit_guchen(eight_char) {
    l.push(ShenSha::from_index(29))
  }
  if hit_guasu(eight_char) {
    l.push(ShenSha::from_index(30))
  }
  if hit_hongluan(eight_char) {
    l.push(ShenSha::from_index(34))
  }
  if hit_tianxi(eight_char) {
    l.push(ShenSha::from_index(35))
  }
  if hit_goujiao(eight_char) {
    l.push(ShenSha::from_index(36))
  }
  if hit_yuanchen(eight_char, gender) {
    l.push(ShenSha::from_index(39))
  }
  if hit_sangmen(eight_char) {
    l.push(ShenSha::from_index(43))
  }
  if hit_diaoke(eight_char) {
    l.push(ShenSha::from_index(44))
  }
  if hit_pima(eight_char) {
    l.push(ShenSha::from_index(45))
  }
  // 以月支查类
  if hit_tiande(eight_char) {
    l.push(ShenSha::from_index(1))
  }
  if hit_yuede(eight_char) {
    l.push(ShenSha::from_index(2))
  }
  if hit_tiandehe(eight_char) {
    l.push(ShenSha::from_index(3))
  }
  if hit_yuedehe(eight_char) {
    l.push(ShenSha::from_index(4))
  }
  if hit_tianshe(eight_char) {
    l.push(ShenSha::from_index(5))
  }
  if hit_tianyi_star(eight_char) {
    l.push(ShenSha::from_index(16))
  }
  if hit_xueren(eight_char) {
    l.push(ShenSha::from_index(24))
  }
  if hit_sifei(eight_char) {
    l.push(ShenSha::from_index(26))
  }
  if hit_tianzhuan(eight_char) {
    l.push(ShenSha::from_index(41))
  }
  if hit_dizhuan(eight_char) {
    l.push(ShenSha::from_index(42))
  }
  if hit_dexiu(eight_char) {
    l.push(ShenSha::from_index(53))
  }
  // 查日柱固定列表类
  if hit_winchacuo(eight_char) {
    l.push(ShenSha::from_index(31))
  }
  if hit_kuigang(eight_char) {
    l.push(ShenSha::from_index(32))
  }
  if hit_guluan(eight_char) {
    l.push(ShenSha::from_index(33))
  }
  if hit_shiedabad(eight_char) {
    l.push(ShenSha::from_index(38))
  }
  if hit_jinshen(eight_char) {
    l.push(ShenSha::from_index(40))
  }
  if hit_shiling(eight_char) {
    l.push(ShenSha::from_index(46))
  }
  if hit_liuxiu(eight_char) {
    l.push(ShenSha::from_index(47))
  }
  if hit_bazhuan(eight_char) {
    l.push(ShenSha::from_index(48))
  }
  if hit_jiuchou(eight_char) {
    l.push(ShenSha::from_index(49))
  }
  if hit_gonglu(eight_char) {
    l.push(ShenSha::from_index(54))
  }
  // 特殊规则类
  if hit_sanqi(eight_char) {
    l.push(ShenSha::from_index(13))
  }
  if hit_kongwang(eight_char) {
    l.push(ShenSha::from_index(18))
  }
  if hit_tianluodiwang(eight_char) {
    l.push(ShenSha::from_index(27))
  }
  if hit_tongzisha(eight_char) {
    l.push(ShenSha::from_index(50))
  }
  l
}

///|
// 通用辅助：四柱干支访问（0年 1月 2日 3时）

// ec_pillars 四柱
fn ec_pillars(ec : EightChar) -> Array[SixtyCycle] {
  [ec.get_year(), ec.get_month(), ec.get_day(), ec.get_hour()]
}

// pillar_stem 第 i 柱天干

///|
fn pillar_stem(ec : EightChar, i : Int) -> HeavenStem {
  ec_pillars(ec)[i].get_heaven_stem()
}

// pillar_branch 第 i 柱地支

///|
fn pillar_branch(ec : EightChar, i : Int) -> EarthBranch {
  ec_pillars(ec)[i].get_earth_branch()
}

// all_branches 四柱地支

///|
fn all_branches(ec : EightChar) -> Array[EarthBranch] {
  let p = ec_pillars(ec)
  [
    p[0].get_earth_branch(),
    p[1].get_earth_branch(),
    p[2].get_earth_branch(),
    p[3].get_earth_branch(),
  ]
}

// branches_except 除第 except_i 柱外其余三支

///|
fn branches_except(ec : EightChar, except_i : Int) -> Array[EarthBranch] {
  let l : Array[EarthBranch] = []
  for i in 0..<4 {
    if i != except_i {
      l.push(pillar_branch(ec, i))
    }
  }
  l
}

// has_branch 数组是否含指定地支

///|
fn has_branch(bs : Array[EarthBranch], b : EarthBranch) -> Bool {
  for x in bs {
    if x.get_index() == b.get_index() {
      return true
    }
  }
  false
}

// has_branch_all 四柱是否含指定地支

///|
fn has_branch_all(ec : EightChar, b : EarthBranch) -> Bool {
  has_branch(all_branches(ec), b)
}

// has_stem 四柱是否含指定天干

///|
fn has_stem(ec : EightChar, stem : HeavenStem) -> Bool {
  for i in 0..<4 {
    if pillar_stem(ec, i).get_index() == stem.get_index() {
      return true
    }
  }
  false
}

///|
// 三合局：0水(申子辰) 1火(寅午戌) 2金(巳酉丑) 3木(亥卯未)

// san_he_group 支所在三合局编号
fn san_he_group(b : EarthBranch) -> Int {
  let m = [0, 2, 1, 3, 0, 2, 1, 3, 0, 2, 1, 3]
  m[b.get_index()]
}

// san_he_pos 三合局长生、中神、墓库位

///|
fn san_he_pos(g : Int) -> (Int, Int, Int) {
  match g {
    0 => (8, 0, 4) // 申子辰
    1 => (2, 6, 10) // 寅午戌
    2 => (5, 9, 1) // 巳酉丑
    _ => (11, 3, 7) // 亥卯未
  }
}

///|
// 方局：0水(亥子丑) 1木(寅卯辰) 2火(巳午未) 3金(申酉戌)

// fang_ju_group 支所在方局编号
fn fang_ju_group(b : EarthBranch) -> Int {
  let m = [0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 0]
  m[b.get_index()]
}

// fang_ju_first 方局首字

///|
fn fang_ju_first(g : Int) -> EarthBranch {
  match g {
    0 => EarthBranch::from_index(11) // 亥
    1 => EarthBranch::from_index(2) // 寅
    2 => EarthBranch::from_index(5) // 巳
    _ => EarthBranch::from_index(8) // 申
  }
}

///|
// 纳音五行（index 0-29 → 木0 火1 土2 金3 水4）
fn sound_element(index : Int) -> Int {
  let m = [
    3, 1, 0, 2, 3, 1, 4, 2, 3, 0, 4, 2, 1, 0, 4, 3, 1, 0, 2, 3, 1, 4, 2, 3, 0, 4,
    2, 1, 0, 4,
  ]
  m[index]
}

// year_sound_element 年柱纳音五行

///|
fn year_sound_element(ec : EightChar) -> Int {
  sound_element(ec.get_year().get_sound().get_index())
}

///|
// 季节：0春(寅卯辰) 1夏(巳午未) 2秋(申酉戌) 3冬(亥子丑)，以月支论
fn season_of_month(ec : EightChar) -> Int {
  let m = [3, 3, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3]
  m[pillar_branch(ec, 1).get_index()]
}

// month_branch_index 月支索引

///|
fn month_branch_index(ec : EightChar) -> Int {
  pillar_branch(ec, 1).get_index()
}
