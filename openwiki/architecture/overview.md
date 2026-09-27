---
type: 参考
title: 架构概览
description: Tyme4MB 系统架构设计，包括层次结构、核心抽象和模块说明
---

# 架构概览

## 系统定位

`tyme4mb` 是**传统中国时间学（Tyme）计算引擎**的 MoonBit 实现。它并非 GUI 应用，而是一个纯计算库，输出结构化的时间信息，供上层应用（网站、App、命理工具等）消费。

## 技术栈

| 层级 | 技术 |
|------|------|
| 语言 | MoonBit（函数式/命令式混合，支持 trait、模式匹配） |
| 运行时目标 | WASM（WebAssembly） |
| 测试框架 | wbtest（MoonBit 内置测试） |
| 外部依赖 | `moonbitlang/core/math`（浮点取整） |
| 数据源 | 内联天文表（节气时刻、农历闰月编码） |
| 移植来源 | 逐函数翻译 |

## 层次架构

```
┌─────────────────────────────────────────────────────┐
│                  应用层（消费者）                      │
│  命理网站 / App / 日历工具 / 数据分析                 │
└──────────────────────┬──────────────────────────────┘
                       │ 调用
┌──────────────────────▼──────────────────────────────┐
│              领域层：tyme/core                        │
│  Solar/Lunar/Hijri/RabByung 日历转换                  │
│  干支/八字/童限/小运推算                              │
│  节气/月相/宜忌/神煞查询                              │
│  人元司令分野（含真黄经版）                           │
└──────────────────────┬──────────────────────────────┘
                       │ 依赖
┌──────────────────────▼──────────────────────────────┐
│              基础层：tyme/base                        │
│  Tyme（推移） / Culture（名称） / Show（打印）        │
│  LoopTyme（循环索引器）                               │
│  五行/阴阳/吉凶/旬/纳音等枚举                         │
└──────────────────────┬──────────────────────────────┘
                       │ 计算
┌──────────────────────▼──────────────────────────────┐
│            天文层：tyme/astronomy                     │
│  节气时刻计算（astronomy_algorithm.mbt）              │
│  天文常数表（astronomy_constants.mbt）                │
│  黄道坐标计算（solar_position.mbt）                   │
│  真太阳时计算（true_solar_time.mbt）                  │
└─────────────────────────────────────────────────────┘
```

## 核心抽象：Trait 设计

### Tyme Trait — 时间推移

```moonbit
pub trait Tyme : Culture {
  next(Self, Int) -> Self  // 推移 n 步
}
```

所有时间单位（日、月、年、干支、神煞…）都实现此 trait，支持向前/向后推移。

### Culture Trait — 名称接口

```moonbit
pub trait Culture {
  get_name(Self) -> String
}
```

统一名称输出，配合 `Show` trait 实现 `to_string()`。

### LoopTyme — 循环索引器

所有枚举/序列类型底层共用 `LoopTyme`，它封装了：
- 环形索引（`index % size`，正确处理负数）
- 名称↔索引双向查找
- 推移操作委托给 `Tyme::next`

### Provider 接口 — 策略注入

```moonbit
pub trait IChildLimitProvider {
  get_info(Self, SolarTime, SolarTerm) -> ChildLimitInfo
}

pub trait IEightCharProvider {
  get_eight_char(Self, LunarHour) -> EightChar
}
```

允许替换算法实现（如不同流派的童限计算方法）。当前支持四种童限实现：DefaultChildLimitProvider、China95ChildLimitProvider、LunarSect1ChildLimitProvider、LunarSect2ChildLimitProvider。

## 关键数据结构

### 时间单位层级

```
SolarTime → SolarDay → SolarMonth → SolarYear
     ↓
LunarDay → LunarMonth → LunarYear
     ↓
HijriDay → HijriMonth → HijriYear
RabByungDay → RabByungMonth → RabByungYear  (巴厘岛历)
     ↓
SixtyCycleDay / SixtyCycleMonth / SixtyCycleYear / SixtyCycleHour
     ↓
EightChar（四柱）→ ThreePillars（三柱）
     ↓
ChildLimit → Fortune（小运）/ DecadeFortune（大运）
     ↓
Phase（月相）/ MinorRen（小六壬）/ SixStar（六曜）/ Sixty（三元）
     ↓
KitchenGodSteed（灶马头）/ LegalHoliday（法定假日）
```

### 核心字段模式

绝大多数类型使用组合模式：
```moonbit
pub struct SolarDay {
  day_unit : DayUnit     // 嵌套：DayUnit → MonthUnit → YearUnit
}

pub struct LunarMonth {
  month_unit : MonthUnit
  leap : Bool            // 标记闰月
}

pub struct SixtyCycle {
  loop_tyme : LoopTyme   // 底层循环索引
}
```

这种设计使类型间转换简洁（通过 `get_year()` / `get_month()` / `get_day()` 等 accessor 逐级上溯）。

## 算法模块说明

| 模块 | 路径 | 说明 |
|------|------|------|
| 公历 | `core/solar_*.mbt` | 公历日/月/年/时间计算，含闰年、星期、儒略日 |
| 农历 | `core/lunar_*.mbt` | 农历闰月算法（64进制压缩表）、月大小、节气定位 |
| 节气 | `core/solar_term.mbt` | 基于天文公式的节气时刻计算 |
| 干支 | `core/sixty_cycle*.mbt` | 六十甲子循环，支持年/月/日/时四柱 |
| 八字 | `core/eight_char.mbt` | 从农历时辰推导四柱，含胎元、命宫、身宫、纳音 |
| 宜忌 | `core/taboo.mbt` | 基于十六进制编码表的每日/时辰宜忌查询 |
| 神煞 | `core/god.mbt`, `core/shensha_*.mbt` | 130 种神煞名称及每日吉凶查询 |
| 童限 | `core/child_limit*.mbt` | 出生时刻到起运时刻的时长计算 |
| 小运/大运 | `core/fortune.mbt`, `core/decade_fortune.mbt` | 基于童限推演各年龄段运势 |
| 回历 | `core/hijri_*.mbt` | 伊斯兰历法转换 |
| 巴厘岛历 | `core/rab_byung_*.mbt` | 印尼巴厘岛历法 |
| 天文算法 | `astronomy/astronomy_*.mbt` | 节气计算、黄道坐标等天文算法 |
| 真太阳时 | `astronomy/true_solar_time.mbt` | 均时差、太阳视赤经、真太阳时计算 |
| 人元司令 | `core/hide_heaven_stem*.mbt` | 人元司令分野及真黄经版 |
| 事件 | `core/event*.mbt` | 自定义事件（节日、节假日等）构建与管理 |
| 灶马头 | `core/kitchen_god_steed.mbt` | 根据正月初一干支推算农历年运势 |
| 小六壬 | `core/minor_ren.mbt` | 大安/留连/速喜/赤口/小吉/空亡 |
| 六曜 | `core/six_star.mbt` | 孔明六曜星 |
| 三元 | `base/sixty.mbt` | 上元/中元/下元（60年一循环） |
| 月相 | `core/phase.mbt`, `core/phase_day.mbt` | 新月/蛾眉月/上弦月等月相计算 |
| 胎神 | `core/fetus_*.mbt` | 逐月胎神 |
| 法定假日 | `core/legal_holiday.mbt` | 中国法定节假日及调休安排 |
| 五行 | `base/element.mbt` | 五行及生克关系 |
| 宫 | `core/zone.mbt` | 四方神兽方位 |
| 十神 | `core/ten_star.mbt` | 天干生克关系 |
| 星期 | `core/week.mbt` | 周日到周六，可关联七曜 |
| 三候 | `core/three_phenology.mbt` | 每节气三候 |

## 数据编码策略

### 农历闰月编码
使用 64 进制字符表 `0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_@` 压缩存储闰月信息。每个字符代表 6 位二进制，每 2 字符编码一年的闰月情况，存储于 `lunar_year_leap_data` 数组中。

### 宜忌/神煞编码
采用十六进制位图编码：
- 每个字符（如 `0F`, `71`）代表一组宜忌项的开关状态
- 按日/时辰索引查询，避免运行时计算

这种设计牺牲了可读性换取了零外部依赖和极快的查询性能。

## 设计差异

1. **不可变性**：MoonBit 不支持可变全局变量，因此 `EventManager` 采用纯值类型设计（方案 C），所有操作返回新实例而非修改状态。调用方需显式持有并传递 `EventManager` 实例（`mgr.update` / `mgr.from_name` / `mgr.all` / `mgr.from_solar_day`），不再依赖全局单例。
2. **Trait 继承**：MoonBit 使用 trait 继承实现多态。
3. **Pattern matching**：switch/if-else 大量转换为 MoonBit 的 match 表达式。
4. **浮点运算**：部分数学函数映射为 `@math.*` 调用。
5. **多流派支持**：童限和八字支持不同流派算法（Default、LunarSect1、LunarSect2、China95）。
6. **真太阳时支持**：v0.2.2 新增真太阳时计算，支持均时差、太阳视赤经、太阳赤纬等天文函数。童限支持双轨模式：`ChildLimit::from_solar_time()` 使用平太阳时，`ChildLimit::from_true_solar_time()` 使用真太阳时。
7. **地支关系扩展**：v0.2.3 新增地支六破（`get_po()`）、三合局五行（`get_san_he_element()`）、三会方局五行与方位（`get_san_hui_element()` / `get_san_hui_direction()`）。
8. **真黄经人元司令**：新增 `EclipticHideHeavenStemDay` 类型，基于太阳真黄经（含章动与光行差）计算人元司令分野。
9. **跨域方法分离**：`SolarDay`/`SolarTime` 的跨领域方法（如 `get_lunar_day`、`get_term`）已分离到独立的 `solar_day_cross.mbt` / `solar_time_cross.mbt` 文件中。
