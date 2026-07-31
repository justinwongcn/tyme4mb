---
title: 源码地图
type: page
description: 完整的文件索引、模块依赖关系和代码统计
---

# 源码地图

## 文件索引

### 基础类型（20个文件）

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
| `sixty.mbt` | 103 | 三元（上元/中元/下元） |
| `six_star.mbt` | 30 | 六曜（孔明六曜星） |

### 公历系统（15个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `solar_day.mbt` | 488 | 公历日（核心） |
| `solar_month.mbt` | 177 | 公历月 |
| `solar_year.mbt` | 134 | 公历年 |
| `solar_time.mbt` | 252 | 公历时间（含真太阳时） |
| `solar_term.mbt` | 102 | 节气计算（天文算法） |
| `solar_festival.mbt` | 111 | 公历节日 |
| `solar_half_year.mbt` | 100 | 半年划分 |
| `solar_season.mbt` | 86 | 季节划分 |
| `solar_week.mbt` | 149 | 周计算 |
| `julian_day.mbt` | 155 | 儒略日转换 |
| `ecliptic.mbt` | 47 | 黄道 |
| `phenology.mbt` | 124 | 物候 |
| `phenology_day.mbt` | 16 | 物候日 |
| `plum_rain.mbt` | 58 | 梅雨 |
| `plum_rain_day.mbt` | 26 | 梅雨天 |

### 农历系统（17个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `lunar_year.mbt` | 226 | 农历年（闰月核心算法） |
| `lunar_month.mbt` | 314 | 农历月 |
| `lunar_day.mbt` | 289 | 农历日 |
| `lunar_hour.mbt` | 284 | 农历时辰 |
| `lunar_festival.mbt` | 146 | 农历节日 |
| `lunar_week.mbt` | 153 | 农历周 |
| `lunar_season.mbt` | 44 | 农历季节 |
| `fetus_month.mbt` | 64 | 胎月（逐月胎神） |
| `fetus_day.mbt` | 131 | 胎日 |
| `fetus_heaven_stem.mbt` | 47 | 胎天干 |
| `fetus_earth_branch.mbt` | 48 | 胎地支 |
| `lunar_sect1_child_limit_provider.mbt` | 41 | 农历派系1童限计算 |
| `lunar_sect2_child_limit_provider.mbt` | 23 | 农历派系2童限计算 |
| `lunar_sect2_eight_char_provider.mbt` | 18 | 农历派系2八字计算 |

### 干支系统（10个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `sixty_cycle.mbt` | 109 | 六十甲子核心 |
| `sixty_cycle_day.mbt` | 206 | 六十甲子日 |
| `sixty_cycle_month.mbt` | 139 | 六十甲子月 |
| `sixty_cycle_year.mbt` | 112 | 六十甲子年 |
| `sixty_cycle_hour.mbt` | 169 | 六十甲子时 |
| `heaven_stem.mbt` | 160 | 天干 |
| `earth_branch.mbt` | 178 | 地支 |
| `hide_heaven_stem.mbt` | 47 | 藏干（天干） |
| `hide_heaven_stem_day.mbt` | 24 | 藏干日 |
| `hide_heaven_stem_type.mbt` | 30 | 藏干类型 |

### 八字命理（12个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `eight_char.mbt` | 256 | 八字核心（含身宫、真太阳时反推） |
| `three_pillars.mbt` | 134 | 三柱（含公历日期反推） |
| `default_eight_char_provider.mbt` | 20 | 默认八字提供者 |
| `i_eight_char_provider.mbt` | 8 | 八字接口 |
| `child_limit.mbt` | 155 | 童限（含大运/小运） |
| `child_limit_info.mbt` | 49 | 童限信息 |
| `fortune.mbt` | 72 | 小运 |
| `decade_fortune.mbt` | 103 | 大运（10年1大运） |
| `abstract_child_limit_provider.mbt` | 36 | 童限抽象 |
| `i_child_limit_provider.mbt` | 21 | 童限接口 |
| `default_child_limit_provider.mbt` | 33 | 默认童限提供者 |
| `china95_child_limit_provider.mbt` | 35 | 中国95童限方案 |

### 神煞宜忌（6个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `god.mbt` | 131 | 神煞（130种） |
| `taboo.mbt` | 192 | 宜忌（每日/时辰） |
| `event.mbt` | 266 | 事件（自定义节日等） |
| `event_builder.mbt` | 138 | 事件构建器 |
| `event_manager.mbt` | 41 | 事件管理器 |
| `event_type.mbt` | 48 | 事件类型枚举 |

### 其他命理学概念（25+个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `zodiac.mbt` | 34 | 生肖 |
| `animal.mbt` | 51 | 动物（36种） |
| `beast.mbt` | 37 | 野兽 |
| `dipper.mbt` | 35 | 北斗九星 |
| `nine_star.mbt` | 55 | 九星 |
| `seven_star.mbt` | 40 | 七星 |
| `twelve_star.mbt` | 43 | 十二星 |
| `twenty_eight_star.mbt` | 97 | 二十八星宿 |
| `phase.mbt` | 149 | 月相（新月、上弦月等） |
| `phase_day.mbt` | 33 | 月相日 |
| `land.mbt` | 39 | 九野 |
| `terrain.mbt` | 38 | 地势（长生十二神） |
| `direction.mbt` | 47 | 方位 |
| `duty.mbt` | 37 | 值日 |
| `dog.mbt` | 33 | 狗日 |
| `dog_day.mbt` | 30 | 狗日 |
| `nine_day.mbt` | 29 | 九日 |
| `peng_zu.mbt` | 41 | 彭祖百忌 |
| `peng_zu_heaven_stem.mbt` | 41 | 彭祖天干 |
| `peng_zu_earth_branch.mbt` | 37 | 彭祖地支 |
| `kitchen_god_steed.mbt` | 133 | 灶马头（正月初一干支推农历年运势） |
| `minor_ren.mbt` | 66 | 小六壬（大安/留连等） |
| `constellation.mbt` | 62 | 星座 |
| `ecliptic.mbt` | 47 | 黄道 |
| `gender.mbt` | 23 | 性别 |
| `abstract_festival.mbt` | 38 | 节日抽象基类 |

### 回历系统（6个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `hijri_day.mbt` | 174 | 回历日 |
| `hijri_month.mbt` | 144 | 回历月 |
| `hijri_year.mbt` | 110 | 回历年 |
| `rab_byung_day.mbt` | 241 | 巴厘岛历日 |
| `rab_byung_month.mbt` | 344 | 巴厘岛历月 |
| `rab_byung_year.mbt` | 232 | 巴厘岛历年 |

### 辅助工具（3个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `shou_xing_util.mbt` | 718 | 斗宿工具（核心天文算法） |
| `legal_holiday.mbt` | 174 | 法定节假日（含调休） |
| `loop_tyme.mbt` | 35 | 循环时间工具 |

### 测试文件（4个文件）

| 文件 | 行数 | 说明 |
|------|------|------|
| `xref_all_wbtest.mbt` | 2104 | 全量交叉引用测试 |
| `xref_gt_wbtest.mbt` | 56 | 子集测试（公历） |
| `xref_sx_wbtest.mbt` | 78 | 子集测试（特殊） |
| `eight_char_true_solar_wbtest.mbt` | 100 | 真太阳时测试 |

## 文件大小排行（Top 15）

| 排名 | 文件 | 行数 |
|------|------|------|
| 1 | `xref_all_wbtest.mbt` | 2104 |
| 2 | `shou_xing_util.mbt` | 718 |
| 3 | `solar_day.mbt` | 488 |
| 4 | `rab_byung_month.mbt` | 344 |
| 5 | `lunar_month.mbt` | 314 |
| 6 | `lunar_day.mbt` | 289 |
| 7 | `lunar_hour.mbt` | 284 |
| 8 | `event.mbt` | 266 |
| 9 | `eight_char.mbt` | 256 |
| 10 | `solar_time.mbt` | 252 |
| 11 | `rab_byung_day.mbt` | 241 |
| 12 | `rab_byung_year.mbt` | 232 |
| 13 | `lunar_year.mbt` | 226 |
| 14 | `taboo.mbt` | 192 |
| 15 | `sixty_cycle_day.mbt` | 206 |

## 模块依赖关系

```
基础层
├── tyme.mbt (Tyme trait)
├── culture.mbt (Culture trait)
├── element.mbt (五行)
├── yin_yang.mbt (阴阳)
├── luck.mbt (吉凶)
├── loop_tyme.mbt (循环索引)
├── sixty.mbt (三元)
└── six_star.mbt (六曜)

时间系统层
├── solar_*.mbt → 基础层
├── lunar_*.mbt → 基础层 + solar_term
├── hijri_*.mbt → 基础层
└── sixty_cycle*.mbt → 基础层

命理层
├── eight_char.mbt → lunar_hour, sixty_cycle
├── child_limit*.mbt → solar_time, solar_term
├── fortune.mbt → child_limit
├── decade_fortune.mbt → child_limit
└── three_pillars.mbt → sixty_cycle

神煞层
├── god.mbt → lunar_day, sixty_cycle
├── taboo.mbt → lunar_day, sixty_cycle
├── event*.mbt → 独立
└── kitchen_god_steed.mbt → 农历年初一

工具层
├── shou_xing_util.mbt → 所有时间类型
└── legal_holiday.mbt → solar_day
```
