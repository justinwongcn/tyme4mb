---
type: 参考
title: 源码地图
description: 完整的文件索引、模块依赖关系和代码统计
---

# 源码地图

## 文件索引

### 基础类型（`tyme/base/`，20个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `tyme.mbt` | 7 | `Tyme` trait 定义 |
| `culture.mbt` | 3 | `Culture` trait 定义 |
| `abstract_tyme.mbt` | 14 | 抽象 Tyme 基类 |
| `abstract_culture.mbt` | 32 | 抽象文化基类（floor_div, index_of） |
| `abstract_culture_day.mbt` | 11 | 抽象文化日 |
| `yin_yang.mbt` | 27 | 阴阳枚举 |
| `luck.mbt` | 37 | 吉凶枚举 |
| `side.mbt` | 28 | 内外枚举 |
| `element.mbt` | 58 | 五行（含生克关系） |
| `sound.mbt` | 23 | 纳音 |
| `ten.mbt` | 16 | 旬 |
| `twenty.mbt` | 24 | 二十宿 |
| `six.mbt` | 17 | 六 |
| `nine.mbt` | 21 | 九 |
| `week_unit.mbt` | 24 | 周单位 |
| `month_unit.mbt` | 18 | 月单位 |
| `year_unit.mbt` | 21 | 年单位 |
| `day_unit.mbt` | 18 | 日单位 |
| `second_unit.mbt` | 83 | 秒单位（含整数比较索引） |
| `loop_tyme.mbt` | 35 | 循环索引工具 |

### 公历系统（`tyme/core/solar_*.mbt`，19个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/solar_day.mbt` | ~200 | 公历日核心 |
| `core/solar_day_cross.mbt` | ~230 | 跨域转换（藏干、节日、月相、三伏等） |
| `core/solar_month.mbt` | ~150 | 公历月 |
| `core/solar_year.mbt` | ~120 | 公历年 |
| `core/solar_time.mbt` | ~300 | 公历时间（含真太阳时） |
| `core/solar_time_cross.mbt` | ~56 | 跨域转换（节气、候、月相、农历时辰等） |
| `core/solar_term.mbt` | ~100 | 节气计算 |
| `core/solar_term_day.mbt` | ~30 | 节气第几天 |
| `core/solar_festival.mbt` | ~100 | 公历节日 |
| `core/solar_half_year.mbt` | ~90 | 半年划分 |
| `core/solar_season.mbt` | ~80 | 季节划分 |
| `core/solar_week.mbt` | ~130 | 周计算 |
| `core/julian_day.mbt` | ~120 | 儒略日转换 |
| `core/phenology.mbt` | ~100 | 物候 |
| `core/phenology_day.mbt` | ~20 | 物候日 |
| `core/plum_rain.mbt` | ~50 | 梅雨 |
| `core/plum_rain_day.mbt` | ~25 | 梅雨天 |
| `core/ecliptic.mbt` | ~45 | 黄道 |
| `core/week.mbt` | ~50 | 星期 |

### 农历系统（`tyme/core/lunar_*.mbt`，16个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/lunar_year.mbt` | ~350 | 农历年（闰月核心算法） |
| `core/lunar_month.mbt` | ~250 | 农历月 |
| `core/lunar_day.mbt` | ~250 | 农历日 |
| `core/lunar_hour.mbt` | ~250 | 农历时辰 |
| `core/lunar_festival.mbt` | ~140 | 农历节日 |
| `core/lunar_week.mbt` | ~120 | 农历周 |
| `core/lunar_season.mbt` | ~40 | 农历季节 |
| `core/fetus_month.mbt` | ~50 | 胎月（逐月胎神） |
| `core/fetus_day.mbt` | ~100 | 胎日 |
| `core/fetus_heaven_stem.mbt` | ~45 | 胎天干 |
| `core/fetus_earth_branch.mbt` | ~45 | 胎地支 |
| `core/lunar_sect1_child_limit_provider.mbt` | ~40 | 农历派系1童限计算 |
| `core/lunar_sect2_child_limit_provider.mbt` | ~25 | 农历派系2童限计算 |
| `core/lunar_sect2_eight_char_provider.mbt` | ~18 | 农历派系2八字计算 |

### 干支系统（`tyme/core/sixty_cycle*.mbt` + `heaven_stem.mbt` + `earth_branch.mbt`，12个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/sixty_cycle.mbt` | ~130 | 六十甲子核心 |
| `core/sixty_cycle_day.mbt` | ~180 | 六十甲子日 |
| `core/sixty_cycle_month.mbt` | ~130 | 六十甲子月 |
| `core/sixty_cycle_year.mbt` | ~100 | 六十甲子年 |
| `core/sixty_cycle_hour.mbt` | ~160 | 六十甲子时 |
| `core/heaven_stem.mbt` | ~170 | 天干 |
| `core/earth_branch.mbt` | ~290 | 地支（含六冲/六合/六害/六破/三合/三会） |
| `core/hide_heaven_stem.mbt` | ~50 | 藏干类型 |
| `core/hide_heaven_stem_day.mbt` | ~40 | 藏干日 |
| `core/hide_heaven_stem_type.mbt` | ~25 | 藏干类型枚举 |
| `core/hide_heaven_stem_ecliptic.mbt` | ~220 | 真黄经人元司令分野 |

### 八字命理（`tyme/core/eight_char*.mbt` + `child_limit*.mbt`，14个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/eight_char.mbt` | ~240 | 八字核心（含身宫、真太阳时反推） |
| `core/three_pillars.mbt` | ~120 | 三柱（含公历日期反推） |
| `core/default_eight_char_provider.mbt` | ~12 | 默认八字提供者 |
| `core/i_eight_char_provider.mbt` | ~8 | 八字接口 |
| `core/child_limit.mbt` | ~200 | 童限（含大运/小运，支持真太阳时） |
| `core/child_limit_info.mbt` | ~60 | 童限信息 |
| `core/fortune.mbt` | ~50 | 小运 |
| `core/decade_fortune.mbt` | ~90 | 大运（10年1大运） |
| `core/abstract_child_limit_provider.mbt` | ~40 | 童限抽象 |
| `core/i_child_limit_provider.mbt` | ~10 | 童限接口 |
| `core/default_child_limit_provider.mbt` | ~35 | 默认童限提供者 |
| `core/china95_child_limit_provider.mbt` | ~30 | 中国95童限方案 |

### 神煞宜忌（`tyme/core/god.mbt` + `taboo.mbt` + `shensha_*.mbt`，11个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/god.mbt` | ~600 | 神煞名称（130种） |
| `core/taboo.mbt` | ~1200 | 宜忌（每日/时辰，十六进制编码表） |
| `core/shensha.mbt` | ~300 | 神煞核心 |
| `core/shensha_stem.mbt` | ~280 | 天干相关神煞 |
| `core/shensha_branch.mbt` | ~220 | 地支相关神煞 |
| `core/shensha_pillar.mbt` | ~160 | 四柱相关神煞 |
| `core/shensha_month.mbt` | ~180 | 月建神煞 |
| `core/shensha_special.mbt` | ~120 | 特殊神煞 |
| `core/event.mbt` | ~230 | 事件（自定义节日等） |
| `core/event_builder.mbt` | ~100 | 事件构建器 |
| `core/event_manager.mbt` | ~80 | 事件管理器 |

### 其他命理学概念（`tyme/core/*.mbt`，35+个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/zodiac.mbt` | ~35 | 生肖 |
| `core/animal.mbt` | ~50 | 动物（36种） |
| `core/beast.mbt` | ~35 | 野兽 |
| `core/dipper.mbt` | ~35 | 北斗九星 |
| `core/nine_star.mbt` | ~55 | 九星 |
| `core/seven_star.mbt` | ~40 | 七星 |
| `core/twelve_star.mbt` | ~45 | 十二星 |
| `core/twenty_eight_star.mbt` | ~90 | 二十八星宿 |
| `core/phase.mbt` | ~100 | 月相（新月、上弦月等） |
| `core/phase_day.mbt` | ~25 | 月相日 |
| `core/land.mbt` | ~35 | 九野 |
| `core/terrain.mbt` | ~35 | 地势（长生十二神） |
| `core/direction.mbt` | ~45 | 方位 |
| `core/duty.mbt` | ~35 | 值日 |
| `core/dog.mbt` | ~30 | 狗日 |
| `core/dog_day.mbt` | ~30 | 狗日计算 |
| `core/nine_day.mbt` | ~25 | 九日 |
| `core/peng_zu.mbt` | ~40 | 彭祖百忌 |
| `core/peng_zu_heaven_stem.mbt` | ~40 | 彭祖天干 |
| `core/peng_zu_earth_branch.mbt` | ~35 | 彭祖地支 |
| `core/kitchen_god_steed.mbt` | ~120 | 灶马头（正月初一干支推农历年运势） |
| `core/minor_ren.mbt` | ~45 | 小六壬（大安/留连等） |
| `core/constellation.mbt` | ~55 | 星座 |
| `core/gender.mbt` | ~20 | 性别 |
| `core/abstract_festival.mbt` | ~35 | 节日抽象基类 |
| `core/ten_star.mbt` | ~35 | 十神（天干生克关系） |
| `core/zone.mbt` | ~35 | 宫（四方神兽方位） |
| `core/three_phenology.mbt` | ~35 | 三候 |
| `core/rab_byung_element.mbt` | ~55 | 藏历五行 |

### 回历系统（`tyme/core/hijri_*.mbt` + `rab_byung_*.mbt`，7个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/hijri_day.mbt` | ~130 | 回历日 |
| `core/hijri_month.mbt` | ~110 | 回历月 |
| `core/hijri_year.mbt` | ~80 | 回历年 |
| `core/rab_byung_day.mbt` | ~200 | 巴厘岛历日 |
| `core/rab_byung_month.mbt` | ~350 | 巴厘岛历月 |
| `core/rab_byung_year.mbt` | ~180 | 巴厘岛历年 |

### 天文算法（`tyme/astronomy/`，6个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `astronomy/astronomy_algorithm.mbt` | ~320 | 节气/朔望计算算法 |
| `astronomy/astronomy_constants.mbt` | ~1600 | 天文常数表 |
| `astronomy/astronomy_decode.mbt` | ~50 | 数据解码 |
| `astronomy/solar_position.mbt` | ~120 | 太阳位置计算 |
| `astronomy/true_solar_time.mbt` | ~110 | 真太阳时计算（均时差等） |

### 辅助工具（`tyme/core/`，2个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `core/legal_holiday.mbt` | ~500 | 法定节假日（含调休，2001年至今） |
| `core/imports.mbt` | ~30 | 导入声明 |

### 测试文件（按包组织）

| 目录 | 说明 |
|------|------|
| `tyme/core/*_wbtest.mbt` | 包内单元测试 |
| `tyme/astronomy/*_wbtest.mbt` | 天文算法测试 |
| `api_test/test_*.mbt` | API 集成测试 |

主要测试文件：
- `api_test/test_calendar.mbt` — 日历转换测试
- `api_test/test_culture.mbt` — 文化名称测试
- `api_test/test_festival.mbt` — 节日测试
- `api_test/test_fortune.mbt` — 童限/大运小运测试
- `api_test/test_hide_heaven_stem_ecliptic.mbt` — 真黄经人元司令测试
- `api_test/test_lunar.mbt` — 农历测试
- `api_test/test_shensha.mbt` — 神煞测试
- `api_test/test_sixty_cycle.mbt` — 干支测试
- `api_test/test_solar.mbt` — 公历测试
- `api_test/test_true_solar_time.mbt` — 真太阳时测试

## 文件大小排行（Top 15）

| 排名 | 文件 | 行数 |
|------|------|------|
| 1 | `astronomy/astronomy_constants.mbt` | ~1600 |
| 2 | `core/taboo.mbt` | ~1200 |
| 3 | `core/legal_holiday.mbt` | ~500 |
| 4 | `core/god.mbt` | ~600 |
| 5 | `core/rab_byung_month.mbt` | ~350 |
| 6 | `core/lunar_year.mbt` | ~350 |
| 7 | `astronomy/astronomy_algorithm.mbt` | ~320 |
| 8 | `core/solar_time.mbt` | ~300 |
| 9 | `core/earth_branch.mbt` | ~290 |
| 10 | `core/lunar_month.mbt` | ~250 |
| 11 | `core/lunar_day.mbt` | ~250 |
| 12 | `core/lunar_hour.mbt` | ~250 |
| 13 | `core/eight_char.mbt` | ~240 |
| 14 | `core/hide_heaven_stem_ecliptic.mbt` | ~220 |
| 15 | `core/solar_day.mbt` | ~200 |

## 模块依赖关系

```
tyme/base（基础层）
├── tyme.mbt (Tyme trait)
├── culture.mbt (Culture trait)
├── element.mbt (五行)
├── yin_yang.mbt (阴阳)
├── luck.mbt (吉凶)
├── loop_tyme.mbt (循环索引)
└── ... (其他枚举类型)

tyme/astronomy（天文层）
├── astronomy_algorithm.mbt (节气/朔望计算)
├── astronomy_constants.mbt (天文常数)
├── true_solar_time.mbt (真太阳时)
└── solar_position.mbt (太阳位置)

tyme/core（领域层）
├── solar_*.mbt → base + astronomy
├── lunar_*.mbt → base + solar_term
├── hijri_*.mbt → base
├── rab_byung_*.mbt → base + solar_day
├── sixty_cycle*.mbt → base
├── eight_char.mbt → lunar_hour, sixty_cycle
├── child_limit*.mbt → solar_time, solar_term, astronomy
├── fortune.mbt → child_limit
├── decade_fortune.mbt → child_limit
├── three_pillars.mbt → sixty_cycle
├── shensha*.mbt → lunar_day, sixty_cycle
├── taboo.mbt → lunar_day, sixty_cycle
├── event*.mbt → 独立
├── hide_heaven_stem_ecliptic.mbt → astronomy
└── legal_holiday.mbt → solar_day
```
