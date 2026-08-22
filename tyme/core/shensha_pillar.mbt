///|
// ============ 八字神煞 V2 · 类4：查日柱固定列表 ============
// 依据 shensha.json 的求法（古诀/查法）实现。

// day_or_hour_is 日柱或时柱为指定干支
fn day_or_hour_is(ec : EightChar, name : String) -> Bool {
  ec.get_day().get_name() == name || ec.get_hour().get_name() == name
}

// day_hour_is 日柱=day 且 时柱=hour

///|
fn day_hour_is(ec : EightChar, day : String, hour : String) -> Bool {
  ec.get_day().get_name() == day && ec.get_hour().get_name() == hour
}

// hit_winchacuo 阴差阳错
// 古诀：丙子日。丙午日。丁丑日。丁未日。戊寅日。戊申日。辛卯日。辛酉日。壬辰日。壬戌日。癸巳日。癸亥日。
// 查法：查日柱

///|
fn hit_winchacuo(ec : EightChar) -> Bool {
  let list = [
    "丙子", "丙午", "丁丑", "丁未", "戊寅", "戊申", "辛卯", "辛酉",
    "壬辰", "壬戌", "癸巳", "癸亥",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_kuigang 魁罡
// 古诀：戊戌日。庚辰日。庚戌日。壬辰日。
// 查法：查日柱

///|
fn hit_kuigang(ec : EightChar) -> Bool {
  let list = ["戊戌", "庚辰", "庚戌", "壬辰"]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_guluan 孤鸾煞
// 古诀：甲寅日。乙巳日。丙午日。丁巳日。戊午日。戊申日。辛亥日。壬子日。
// 查法：查日柱

///|
fn hit_guluan(ec : EightChar) -> Bool {
  let list = [
    "甲寅", "乙巳", "丙午", "丁巳", "戊午", "戊申", "辛亥", "壬子",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_shiedabad 十恶大败
// 古诀：甲辰，乙巳，壬申，丙申，丁亥，庚辰，戊戍，癸亥，辛巳，己丑，日柱见着是。（戊戍即戊戌）
// 查法：查日柱

///|
fn hit_shiedabad(ec : EightChar) -> Bool {
  let list = [
    "甲辰", "乙巳", "壬申", "丙申", "丁亥", "庚辰", "戊戌", "癸亥",
    "辛巳", "己丑",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_jinshen 金神
// 古诀：乙丑，己巳，癸酉。
// 查法：查日柱或时柱

///|
fn hit_jinshen(ec : EightChar) -> Bool {
  day_or_hour_is(ec, "乙丑") ||
  day_or_hour_is(ec, "己巳") ||
  day_or_hour_is(ec, "癸酉")
}

// hit_shiling 十灵日
// 古诀：甲辰、乙亥、丙辰、丁酉、戊午、庚戌、庚寅、辛亥、壬寅、癸未
// 查法：查日柱

///|
fn hit_shiling(ec : EightChar) -> Bool {
  let list = [
    "甲辰", "乙亥", "丙辰", "丁酉", "戊午", "庚戌", "庚寅", "辛亥",
    "壬寅", "癸未",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_liuxiu 六秀日
// 古诀：丙午 丁未 戊子 戊午 己丑 己未
// 查法：查日柱

///|
fn hit_liuxiu(ec : EightChar) -> Bool {
  let list = ["丙午", "丁未", "戊子", "戊午", "己丑", "己未"]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_bazhuan 八专
// 古诀：甲寅日。乙卯日。丁未日。戊戌日。己未日。庚申日。辛酉日。癸丑日。
// 查法：查日柱

///|
fn hit_bazhuan(ec : EightChar) -> Bool {
  let list = [
    "甲寅", "乙卯", "丁未", "戊戌", "己未", "庚申", "辛酉", "癸丑",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_jiuchou 九丑
// 古诀：丁酉日。戊子日。戊午日。己卯日。己酉日。辛卯日。辛酉日。壬子日。壬午日。
// 查法：查日柱

///|
fn hit_jiuchou(ec : EightChar) -> Bool {
  let list = [
    "丁酉", "戊子", "戊午", "己卯", "己酉", "辛卯", "辛酉", "壬子",
    "壬午",
  ]
  let day = ec.get_day().get_name()
  for n in list {
    if day == n {
      return true
    }
  }
  false
}

// hit_gonglu 拱禄
// 古诀：拱禄有五日五时：癸亥日癸丑时, 癸丑日癸亥时, 拱子禄；丁巳日丁未时, 己未日己巳时, 拱午禄；戊辰日戊午时, 拱巳禄。
// 查法：以日柱配合时柱

///|
fn hit_gonglu(ec : EightChar) -> Bool {
  day_hour_is(ec, "癸亥", "癸丑") ||
  day_hour_is(ec, "癸丑", "癸亥") ||
  day_hour_is(ec, "丁巳", "丁未") ||
  day_hour_is(ec, "己未", "己巳") ||
  day_hour_is(ec, "戊辰", "戊午")
}
