---
type: "参考"
title: "领域概念 — 时间体系"
openwiki_generated: true
---

```markdown
---
title: 领域概念
type: page
description: 公历、农历、回历、干支、八字、神煞宜忌等核心概念详解
---

# 领域概念 — 时间体系

## 概览

本库实现了三种历法体系及其交叉计算：
- **公历（Solar）**：国际通用的格里高利历
- **农历（Lunar）**：中国传统阴阳合历
- **回历（Hijri）**：伊斯兰历法

以及基于这些历法的衍生体系：干支、八字、节气、宜忌、神煞、童限/小运。

## 历法体系

### 公历（Solar Calendar）

公历是阳历，以地球绕太阳公转为基础。

| 类型 | 文件 | 职责 |
|------|------|------|
| `SolarDay` | `solar_day.mbt` | 公历日，含星期、干支日、节气判断 |
| `SolarMonth` | `solar_month.mbt` | 公历月，月份天数计算 |
| `SolarYear` | `solar_year.mbt` | 公历年，闰年判断 |
| `SolarTime` | `solar_time.mbt` | 公历时间（时/分/秒），真太阳时计算 |
| `SolarTerm` | `solar_term.mbt` | 二十四节气，基于天文公式 |
| `SolarFestival` | `solar_festival.mbt` | 公历节日 |
| `SolarHalfYear` / `SolarSeason` | `solar_half_year.mbt`, `solar_season.mbt` | 半年、季节划分 |
| `SolarWeek` | `solar_week.mbt` | 周计算 |

**关键计算**：
- 儒略日（Julian Day）转换：`julian_day.mbt`
- 节气时刻：通过天文公式（`init_by_year`, `calc_qi`）计算精确时刻
- 真太阳时：`solar_time.mbt` 中处理真太阳时与平太阳时的差异

### 农历（Lunar Calendar）

农历是阴阳合历，以月相周期为基础，同时通过设置闰月使历年平均长度接近回归年。

| 类型 | 文件 | 职责 |
|------|------|------|
| `LunarDay` | `lunar_day.mbt` | 农历日（初一至三十） |
| `LunarMonth` | `lunar_month.mbt` | 农历月，标记闰月 |
| `LunarYear` | `lunar_year.mbt` | 农历年，含闰月判断（核心算法） |
| `LunarHour` | `lunar_hour.mbt` | 农历时辰（12时辰） |
| `LunarFestival` | `lunar_festival.mbt` | 农历节日（春节、元宵等） |
| `LunarWeek` | `lunar_week.mbt` | 农历周计算 |

**闰月算法**（`lunar_year.mbt`）：
- 使用 64 进制压缩编码存储公元 -1 至 9999 年的闰月信息
- 编码表 `lunar_year_leap_data` 共 12 组，每组编码连续年份的闰月情况
- `build_lunar_year_leap()` 函数解码这些编码

### 回历（Hijri Calendar）

| 类型 | 文件 | 职责 |
|------|------|------|
| `HijriDay` | `hijri_day.mbt` | 回历日 |
| `HijriMonth` | `hijri_month.mbt` | 回历月 |
| `HijriYear` | `hijri_year.mbt` | 回历年 |
| `RabByungDay/Month/Year` | `rab_byung_*.mbt` | 印尼巴厘岛历法 |

## 干支体系

干支是中国传统的时间标识系统，由 10 个天干和 12 个地支循环组合，形成 60 个组合（六十甲子）。

| 类型 | 文件 | 说明 |
|------|------|------|
| `HeavenStem` | `heaven_stem.mbt` | 天干（甲乙丙丁戊己庚辛壬癸），含五行、阴阳属性 |
| `EarthBranch` | `earth_branch.mbt` | 地支（子丑寅卯辰巳午未申酉戌亥），含五行、阴阳、生肖 |
| `SixtyCycle` | `sixty_cycle.mbt` | 六十甲子，天干地支的组合 |
| `SixtyCycleDay/Month/Year/Hour` | `sixty_cycle_*.mbt` | 四柱干支 |

**关系**：
- 天干索引 % 2 = 0 → 阳，= 1 → 阴
- 地支索引 % 2 = 0 → 阳，= 1 → 阴
- 五行：天干 `get_element()` 返回五行（木火土金水）
- 纳音：`SixtyCycle::get_sound()` 返回纳音五行

## 八字体系

八字（四柱）是命理学的核心概念，由年柱、月柱、日柱、时柱组成。

| 类型 | 文件 | 说明 |
|------|------|------|
| `EightChar` | `eight_char.mbt` | 八字结构，含四柱 |
| `ThreePillars` | `three_pillars.mbt` | 三柱（年/月/日） |
| `EightCharProvider` | `default_eight_char_provider.mbt` | 八字计算提供者接口实现 |

**八字计算流程**：
1. 输入：公历出生时间（`SolarTime`）
2. 转换为农历时辰（`LunarHour`）
3. 通过 `IEightCharProvider` 接口计算四柱干支
4. 输出：八字结构，含胎元、命宫、纳音

**Provider 实现**：
- `DefaultEightCharProvider`：默认实现
- `LunarSect2EightCharProvider`：流派2实现

## 命理体系

### 童限与小运

| 类型 | 文件 | 说明 |
|------|------|------|
| `ChildLimit` | `child_limit.mbt` | 童限（起运前的大运） |
| `ChildLimitInfo` | `child_limit_info.mbt` | 童限信息 |
| `Fortune` | `fortune.mbt` | 小运（大运推算） |
| `ChildLimitProvider` | `abstract_child_limit_provider.mbt` | 童限计算抽象 |
| `IChildLimitProvider` | `i_child_limit_provider.mbt` | 童限接口 |

**计算逻辑**：
- 童限：从出生时刻到下一个节令的时间差
- 小运：基于童限，按年龄推移干支

### 神煞与宜忌

| 类型 | 文件 | 说明 |
|------|------|------|
| `God` | `god.mbt` | 神煞（200+ 种） |
| `Taboo` | `taboo.mbt` | 宜忌（祭祀、嫁娶等） |
| `Event` | `event.mbt` | 自定义事件（节日、节假日等）|
| `EventManager` | `event_manager.mbt` | 事件管理器（纯值类型，显式状态传递）|
| `EventBuilder` | `event_builder.mbt` | 事件构造器 |
| `EventType` | `event_type.mbt` | 事件类型枚举 |

**数据编码**：
- 神煞表：12行 × 31列的十六进制位图（每日吉凶）
- 宜忌表：类似编码，按日/时辰查询

## 辅助概念

| 类型 | 文件 | 说明 |
|------|------|------|
| `Element` | `element.mbt` | 五行（木火土金水），含相生相克关系 |
| `YinYang` | `yin_yang.mbt` | 阴阳 |
| `Luck` | `luck.mbt` | 吉凶（吉/凶） |
| `Side` | `side.mbt` | 内外（内/外） |
| `Zodiac` | `zodiac.mbt` | 生肖（12生肖） |
| `Animal` | `animal.mbt` | 动物（36动物，与地支对应） |
| `Beast` | `beast.mbt` | 野兽 |
| `Dipper` | `dipper.mbt` | 北斗九星 |
| `NineStar` | `nine_star.mbt` | 九星 |
| `SevenStar` | `seven_star.mbt` | 七星 |
| `TwelveStar` | `twelve_star.mbt` | 十二星 |
| `TwentyEightStar` | `twenty_eight_star.mbt` | 二十八星宿 |
| `Phase` | `phase.mbt` | 月相（新月、上弦月等） |
| `Land` | `land.mbt` | 九野 |
| `Terrain` | `terrain.mbt` | 地势（长生十二神） |
| `Direction` | `direction.mbt` | 方位 |
| `Sound` | `sound.mbt` | 纳音 |
| `SixStar` | `six_star.mbt` | 六煞 |
| `Ten` | `ten.mbt` | 旬 |
| `Twenty` | `twenty.mbt` | 二十宿 |
| `PengZu` | `peng_zu.mbt` | 彭祖百忌 |

## 时间单位抽象

```moonbit
pub struct YearUnit { year: Int }
pub struct MonthUnit { year_unit: YearUnit, month: Int }
pub struct DayUnit { month_unit: MonthUnit, day: Int }
pub struct SecondUnit { day_unit: DayUnit, hour: Int, minute: Int, second: Int }
```

所有日期类型都嵌套这些单位，通过 accessor 方法逐级访问。
```