---
type: "参考"
title: "关键工作流"
openwiki_generated: true
---

---
title: 关键工作流
type: page
description: 常用计算流程的完整指南，包含代码示例
---

# 关键工作流

## 1. 公历转农历

```
SolarDay → LunarDay
```

**流程**：
1. 构造 `SolarDay`：`SolarDay::from_ymd(year, month, day)`
2. 调用 `get_lunar_day()` 获取对应农历日
3. 通过农历日获取年/月/日信息

**示例代码**：
```moonbit
let solar = SolarDay::from_ymd(2026, 1, 29)?
let lunar = solar.get_lunar_day()
let lunar_year = lunar.get_year()    // 2025
let lunar_month = lunar.get_month()  // 12
let lunar_day = lunar.get_day()      // 11
```

## 2. 八字排盘

```
SolarTime → LunarHour → EightChar
```

**流程**：
1. 构造出生时刻 `SolarTime`
2. 转换为农历时辰 `LunarHour`
3. 通过 `eight_char_provider.get_eight_char(hour)` 计算八字
4. 提取四柱：年柱、月柱、日柱、时柱

**示例代码**：
```moonbit
let solar_time = SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0)?
let lunar_hour = solar_time.get_lunar_hour()
let eight_char = eight_char_provider.get_eight_char(lunar_hour)
let year_pillar = eight_char.get_year()   // SixtyCycle
let month_pillar = eight_char.get_month() // SixtyCycle
let day_pillar = eight_char.get_day()     // SixtyCycle
let hour_pillar = eight_char.get_hour()   // SixtyCycle
```

**八字信息**：
- `get_fetal_origin()` — 胎元
- `get_life_palace()` — 命宫
- `get_three_pillars().get_year/month/day()` — 三柱

## 3. 童限计算

```
SolarTime + SolarTerm → ChildLimitInfo
```

**流程**：
1. 获取出生时刻的下一个节令 `SolarTerm`
2. 通过 `child_limit_provider.get_info(solar_time, solar_term)` 计算
3. 得到童限信息：起运时间、童限长度

**示例代码**：
```moonbit
let solar_time = SolarTime::from_ymdhms(1990, 5, 15, 14, 30, 0)?
let next_term = solar_time.get_next_solar_term()
let info = child_limit_provider.get_info(solar_time, next_term)
let start_year = info.get_start_sixty_cycle_year()
let end_year = info.get_end_sixty_cycle_year()
```

## 4. 小运推算

```
ChildLimit → Fortune (按年龄)
```

**流程**：
1. 从童限信息构造小运
2. 通过年龄索引获取对应小运
3. 小运的干支 = 时柱推移（正/逆）

**示例代码**：
```moonbit
let fortune = Fortune::from_child_limit(child_limit, age_offset)
let age = fortune.get_age()
let sc_year = fortune.get_sixty_cycle_year()
```

## 5. 节气查询

```
SolarDay → SolarTerm (判断所在节气)
```

**流程**：
1. 构造 `SolarDay`
2. 调用 `get_solar_term()` 获取当前节气
3. 或遍历节气列表寻找目标节气

**示例代码**：
```moonbit
let day = SolarDay::from_ymd(2026, 2, 4)?  // 立春附近
let term = day.get_solar_term()
println(term.to_string())  // "立春"
```

## 6. 宜忌查询

```
LunarDay → Taboo (每日宜忌)
```

**流程**：
1. 获取农历日
2. 调用 `get_day_taboo()` 或 `get_hour_taboo(hour_index)`
3. 解析十六进制编码获取宜/忌列表

**示例代码**：
```moonbit
let lunar_day = lunar_day  // 从公历转换
let day_taboo = lunar_day.get_day_taboo()
let hour_taboo = lunar_day.get_hour_taboo(5)  // 午时
```

## 7. 神煞查询

```
LunarDay → God (每日神煞)
```

**流程**：
1. 获取农历日
2. 调用 `get_day_gods()` 获取当日神煞列表
3. 判断吉凶：`God::get_luck()`

**示例代码**：
```moonbit
let gods = lunar_day.get_day_gods()
for god in gods {
  let luck = god.get_luck()  // 吉 or 凶
}
```

## 8. 干支推移

```
SixtyCycle → next(n) → SixtyCycle
```

所有实现 `Tyme` trait 的类型都支持推移操作：

```moonbit
let stem = HeavenStem::from_name("甲")?
let next_stem = stem.next(3)  // 丁
let branch = EarthBranch::from_name("子")?
let next_branch = branch.next(5)  // 巳
let cycle = SixtyCycle::from_name("甲子")?
let next_cycle = cycle.next(10)  // 甲戌
```

## 9. 农历闰月判断

```
LunarYear → get_leap_month() → Int
```

**说明**：
- 返回值 0 表示无闰月
- 返回值 1-12 表示闰几月

**示例代码**：
```moonbit
let year = LunarYear::from_year(2025)?
let leap_month = year.get_leap_month()  // 闰二月 → 2
```

## 10. 五行生克关系

```
Element → get_reinforce() / get_restrain() / ...
```

**五行关系**（木火土金水）：
- `get_reinforce()`: 我生者（木→火）
- `get_restrain()`: 我克者（木→土）
- `get_reinforced()`: 生我者（火→木）
- `get_restrained()`: 克我者（金→木）

**示例代码**：
```moonbit
let wood = Element::from_name("木")?
let fire = wood.get_reinforce()   // 火
let earth = wood.get_restrain()   // 土
let water = wood.get_restrained() // 水
let metal = wood.get_reinforced() // 金
```

## 11. 生肖查询

```
LunarYear → Zodiac
```

**示例代码**：
```moonbit
let year = LunarYear::from_year(2026)?
let zodiac = year.get_zodiac()
println(zodiac.to_string())  // "马"
```

## 12. 干支五行属性

```
SixtyCycle → get_heaven_stem() + get_earth_branch() → Element
```

**示例代码**：
```moonbit
let cycle = SixtyCycle::from_name("甲子")?
let stem = cycle.get_heaven_stem()
let branch = cycle.get_earth_branch()
let stem_element = stem.get_element()  // 木
let branch_element = branch.get_element()  // 水
```