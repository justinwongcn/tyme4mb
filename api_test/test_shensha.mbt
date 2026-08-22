// 黑盒 API 测试：八字神煞 V2（基于 shensha.json 的 55 条求法）

///|
// sc 从名称构造六十甲子
fn sc(name : String) -> @tyme.SixtyCycle {
  match @tyme.SixtyCycle::from_name(name) {
    Ok(v) => v
    Err(e) => abort(e)
  }
}

///|
// ec 从四柱名称构造八字
fn ec(
  year : String,
  month : String,
  day : String,
  hour : String,
) -> @tyme.EightChar {
  @tyme.EightChar::from_sixty_cycle(sc(year), sc(month), sc(day), sc(hour))
}

///|
// has_shensha 八字是否带指定 id 的神煞
fn has_shensha(bc : @tyme.EightChar, gender : @tyme.Gender, id : Int) -> Bool {
  let list = @tyme.ShenSha::get_from_eight_char(bc, gender)
  for s in list {
    if s.get_id() == id {
      return true
    }
  }
  false
}

///|
test "shensha_names_count" {
  assert_true(@tyme.shensha_names().length() == 55, "shensha 共 55 个")
}

///|
test "shensha_from_index" {
  let s = @tyme.ShenSha::from_index(0)
  assert_true(s.get_id() == 1, "id=1")
  assert_true(s.get_name() == "天乙贵人", "天乙贵人")
}

///|
test "shensha_from_name" {
  let s = @tyme.ShenSha::from_name("驿马").unwrap()
  assert_true(s.get_id() == 8, "驿马 id=8")
}

///|
test "shensha_tianyi" {
  // 天乙贵人：甲日见丑
  let bc = ec("甲子", "丙寅", "甲子", "乙丑")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 1),
    "甲日时支丑 → 天乙贵人",
  )
  // 反例：甲日四支无丑未子申戌亥猪鸡
  let bc2 = ec("甲子", "丙寅", "甲子", "甲午")
  assert_true(!has_shensha(bc2, @tyme.Gender::Man, 1), "无天乙贵人")
}

///|
test "shensha_tiande_yuede" {
  // 天德贵人：寅月见丁
  let bc = ec("甲子", "丙寅", "丁卯", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 2),
    "寅月见丁 → 天德贵人",
  )
  // 月德贵人：寅午戌月见丙
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 3),
    "寅月见丙 → 月德贵人",
  )
}

///|
test "shensha_tiandehe_yuedehe" {
  // 天德合：寅月天德丁，丁壬合 → 见壬
  let bc = ec("甲子", "丙寅", "壬午", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 4),
    "寅月见壬 → 天德合",
  )
  // 月德合：寅午戌月见辛
  let bc2 = ec("甲子", "丙寅", "辛未", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 5),
    "寅月见辛 → 月德合",
  )
}

///|
test "shensha_tianshe" {
  // 天赦日：春（寅卯辰月）戊寅日
  let bc = ec("甲子", "丙寅", "戊寅", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 6),
    "寅月戊寅日 → 天赦日",
  )
  // 反例：春非戊寅日
  let bc2 = ec("甲子", "丙寅", "甲子", "甲午")
  assert_true(!has_shensha(bc2, @tyme.Gender::Man, 6), "非天赦日")
}

///|
test "shensha_lushen" {
  // 禄神：甲日见寅
  let bc = ec("甲子", "丙寅", "甲子", "丙寅")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 7), "甲日见寅 → 禄神")
  let bc2 = ec("甲子", "乙丑", "甲子", "丙午")
  assert_true(
    !has_shensha(bc2, @tyme.Gender::Man, 7),
    "甲日无寅 → 无禄神",
  )
}

///|
test "shensha_yima" {
  // 驿马：申子辰马在寅（年支申）
  let bc = ec("壬申", "丙寅", "甲子", "丙寅")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 8), "申年见寅 → 驿马")
}

///|
test "shensha_taiji_jiangxing_huagai" {
  // 太极贵人：甲乙生人子午中（甲日见子）
  let bc = ec("甲子", "丙寅", "甲子", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 9),
    "甲日见子 → 太极贵人",
  )
  // 将星：申子辰局中神子（年支申）
  let bc2 = ec("壬申", "丙寅", "甲子", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 10),
    "申年见子 → 将星",
  )
  // 华盖：申子辰见辰（年支申）
  let bc3 = ec("壬申", "丙寅", "戊辰", "甲午")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 16),
    "申年见辰 → 华盖",
  )
}

///|
test "shensha_xuetang_cinguan" {
  // 学堂：金命（甲子年海中金）见巳
  let bc = ec("甲子", "丙寅", "己巳", "甲午")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 11), "金命见巳 → 学堂")
  // 词馆：金命见申（临官）
  let bc2 = ec("甲子", "丙寅", "壬申", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 12),
    "金命见申 → 词馆",
  )
}

///|
test "shensha_tianyi_star" {
  // 天医：寅月（正月）见丑（月支前一位，查其他三支）
  let bc = ec("甲子", "丙寅", "甲子", "乙丑")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 17),
    "寅月时支丑 → 天医",
  )
  // 反例：寅月四支无丑
  let bc2 = ec("甲子", "丙寅", "甲子", "甲午")
  assert_true(!has_shensha(bc2, @tyme.Gender::Man, 17), "无天医")
  // 子月见亥（负索引取模边界）
  let bc3 = ec("甲子", "丙子", "甲子", "乙亥")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 17),
    "子月见亥 → 天医",
  )
}

///|
test "shensha_guoyin_wenchang_jinyu" {
  // 国印：甲见戌
  let bc = ec("甲子", "丙寅", "甲戌", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 13),
    "甲日见戌 → 国印贵人",
  )
  // 文昌：甲日见巳
  let bc2 = ec("甲子", "丙寅", "甲子", "己巳")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 15),
    "甲日见巳 → 文昌贵人",
  )
  // 金舆：甲见辰
  let bc3 = ec("甲子", "丙寅", "甲子", "戊辰")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 18),
    "甲日见辰 → 金舆",
  )
}

///|
test "shensha_sanqi" {
  // 三奇：地下三奇乙丙丁（年月日连续）
  let bc = ec("乙丑", "丙寅", "丁卯", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 14),
    "乙丙丁连续 → 三奇贵人",
  )
  // 反例：不连续
  let bc2 = ec("乙丑", "甲戌", "丁卯", "甲午")
  assert_true(
    !has_shensha(bc2, @tyme.Gender::Man, 14),
    "不连续 → 无三奇",
  )
}

///|
test "shensha_kongwang" {
  // 空亡：甲子旬空戌亥（日柱甲子，余支见戌）
  let bc = ec("甲子", "丙寅", "甲子", "戊戌")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 19),
    "甲子日余支见戌 → 空亡",
  )
  let bc2 = ec("甲子", "丙寅", "甲子", "庚午")
  assert_true(!has_shensha(bc2, @tyme.Gender::Man, 19), "无空亡")
}

///|
test "shensha_zaisha_jiesha_wangshen" {
  // 灾煞：申子辰见午（年支申）
  let bc = ec("壬申", "丙寅", "甲子", "甲午")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 20), "申年见午 → 灾煞")
  // 劫煞：申子辰见巳（年支申）
  let bc2 = ec("壬申", "丙寅", "甲子", "己巳")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 21),
    "申年见巳 → 劫煞",
  )
  // 亡神：申子辰见亥（年支申）
  let bc3 = ec("壬申", "丙寅", "甲子", "辛亥")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 22),
    "申年见亥 → 亡神",
  )
}

///|
test "shensha_yangren_feiren" {
  // 羊刃：甲日见卯
  let bc = ec("甲子", "丙寅", "甲子", "丁卯")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 23), "甲日见卯 → 羊刃")
  // 飞刃：羊刃卯之冲酉
  let bc2 = ec("甲子", "丙寅", "甲子", "癸酉")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 24),
    "甲日见酉 → 飞刃",
  )
}

///|
test "shensha_xueren_liuxia" {
  // 血刃：寅月见丑
  let bc = ec("甲子", "丙寅", "甲子", "乙丑")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 25), "寅月见丑 → 血刃")
  // 流霞：甲日见酉
  let bc2 = ec("甲子", "丙寅", "甲子", "癸酉")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 26),
    "甲日见酉 → 流霞",
  )
}

///|
test "shensha_sifei_tianzhuan_dizhuan" {
  // 四废：春庚申日
  let bc = ec("甲子", "丙寅", "庚申", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 27),
    "寅月庚申日 → 四废日",
  )
  // 天转：春乙卯日
  let bc2 = ec("甲子", "丙寅", "乙卯", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 42),
    "寅月乙卯日 → 天转",
  )
  // 地转：春辛卯日
  let bc3 = ec("甲子", "丙寅", "辛卯", "甲午")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 43),
    "寅月辛卯日 → 地转",
  )
}

///|
test "shensha_tianluodiwang" {
  // 天罗：火命（甲戌年山头火）见戌日
  let bc = ec("甲戌", "丙寅", "甲戌", "甲午")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 28), "火命戌日 → 天罗")
  // 地网：水命（甲子年海中金为金命，取水命年：丙子年涧下水）见巳日
  let bc2 = ec("丙子", "丙寅", "己巳", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 28),
    "水命巳日 → 地网",
  )
}

///|
test "shensha_taohua_guchen_guasu" {
  // 桃花：申子辰在酉（年支申）
  let bc = ec("壬申", "丙寅", "甲子", "癸酉")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 29), "申年见酉 → 桃花")
  // 孤辰：亥子丑人见寅（年支子）
  let bc2 = ec("甲子", "丙寅", "甲子", "丙寅")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 30),
    "子年见寅 → 孤辰",
  )
  // 寡宿：亥子丑人见戌（年支子）
  let bc3 = ec("甲子", "丙寅", "甲子", "戊戌")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 31),
    "子年见戌 → 寡宿",
  )
}

///|
test "shensha_winchacuo_kuigang_guluan" {
  // 阴差阳错：丙子日
  let bc = ec("甲子", "丙寅", "丙子", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 32),
    "丙子日 → 阴差阳错",
  )
  // 魁罡：戊戌日
  let bc2 = ec("甲子", "丙寅", "戊戌", "甲午")
  assert_true(has_shensha(bc2, @tyme.Gender::Man, 33), "戊戌日 → 魁罡")
  // 孤鸾：甲寅日
  let bc3 = ec("甲子", "丙寅", "甲寅", "甲午")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 34),
    "甲寅日 → 孤鸾煞",
  )
}

///|
test "shensha_hongluan_tianxi_goujiao" {
  // 红鸾：子年生见卯
  let bc = ec("甲子", "丙寅", "甲子", "乙卯")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 35), "子年见卯 → 红鸾")
  // 天喜：子年生见酉
  let bc2 = ec("甲子", "丙寅", "甲子", "癸酉")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 36),
    "子年见酉 → 天喜",
  )
  // 勾绞：子年生见卯/酉
  let bc3 = ec("甲子", "丙寅", "甲子", "乙卯")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 37),
    "子年见卯 → 勾绞煞",
  )
}

///|
test "shensha_hongyan_shiedabad_yuanchen" {
  // 红艳：甲日见午
  let bc = ec("甲子", "丙寅", "甲子", "庚午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 38),
    "甲日见午 → 红艳煞",
  )
  // 十恶大败：甲辰日
  let bc2 = ec("甲子", "丙寅", "甲辰", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 39),
    "甲辰日 → 十恶大败",
  )
  // 元辰：阳男阴女 子年未；男命子年（阳年干甲）→ 未
  let bc3 = ec("甲子", "丙寅", "甲子", "辛未")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 40),
    "阳男子年见未 → 元辰",
  )
  // 元辰：阴男阳女 子年巳；男命乙丑年（阴年干乙，丑=1）→ 丑+5=午
  let bc4 = ec("乙丑", "丙寅", "甲子", "庚午")
  assert_true(
    has_shensha(bc4, @tyme.Gender::Man, 40),
    "阴男子年见午 → 元辰",
  )
}

///|
test "shensha_jinshen_shiling_liuxiu" {
  // 金神：乙丑日
  let bc = ec("甲子", "丙寅", "乙丑", "甲午")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 41), "乙丑日 → 金神")
  // 十灵日：甲辰日
  let bc2 = ec("甲子", "丙寅", "甲辰", "甲午")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 47),
    "甲辰日 → 十灵日",
  )
  // 六秀日：丙午日
  let bc3 = ec("甲子", "丙寅", "丙午", "甲午")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 48),
    "丙午日 → 六秀日",
  )
}

///|
test "shensha_sangmen_diaoke_pima" {
  // 丧门：子年+2 = 寅
  let bc = ec("甲子", "丙寅", "甲子", "丙寅")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 44), "子年见寅 → 丧门")
  // 吊客：子年-2 = 戌
  let bc2 = ec("甲子", "丙寅", "甲子", "戊戌")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 45),
    "子年见戌 → 吊客",
  )
  // 披麻：子年-3 = 酉
  let bc3 = ec("甲子", "丙寅", "甲子", "癸酉")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 46),
    "子年见酉 → 披麻",
  )
}

///|
test "shensha_bazhuan_jiuchou_gonglu" {
  // 八专：甲寅日
  let bc = ec("甲子", "丙寅", "甲寅", "甲午")
  assert_true(has_shensha(bc, @tyme.Gender::Man, 49), "甲寅日 → 八专")
  // 九丑：丁酉日
  let bc2 = ec("甲子", "丙寅", "丁酉", "甲午")
  assert_true(has_shensha(bc2, @tyme.Gender::Man, 50), "丁酉日 → 九丑")
  // 拱禄：癸亥日癸丑时
  let bc3 = ec("甲子", "丙寅", "癸亥", "癸丑")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 55),
    "癸亥日癸丑时 → 拱禄",
  )
}

///|
test "shensha_tongzisha_tianchu_fuxing_dexiu" {
  // 童子煞：春秋月日支见寅（春寅月，日支寅）
  let bc = ec("甲子", "丙寅", "甲寅", "甲午")
  assert_true(
    has_shensha(bc, @tyme.Gender::Man, 51),
    "寅月寅日 → 童子煞",
  )
  // 天厨贵人：丙日见巳
  let bc2 = ec("甲子", "丙寅", "丙子", "己巳")
  assert_true(
    has_shensha(bc2, @tyme.Gender::Man, 52),
    "丙日见巳 → 天厨贵人",
  )
  // 福星贵人：甲年干见寅/子
  let bc3 = ec("甲子", "丙寅", "庚午", "甲午")
  assert_true(
    has_shensha(bc3, @tyme.Gender::Man, 53),
    "甲年见子 → 福星贵人",
  )
  // 德秀贵人：寅月见丙丁（火局为德）
  let bc4 = ec("甲子", "丙寅", "丙子", "甲午")
  assert_true(
    has_shensha(bc4, @tyme.Gender::Man, 54),
    "寅月见丙 → 德秀贵人",
  )
}
