---
type: "参考"
title: "架构概览"
openwiki_generated: true
---

---
title: 架构概览
type: page
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
│              领域层：时间计算                          │
│  Solar/Lunar/Hijri 日历转换                           │
│  干支/八字/童限/小运推算                              │
│  节气/月相/宜忌/神煞查询                              │
└──────────────────────┬──────────────────────────────┘
                       │ 依赖
┌──────────────────────▼──────────────────────────────┐
│              基础层：抽象 trait                        │
│  Tyme（推移） / Culture（名称） / Show（打印）        │
│  LoopTyme（循环索引器）                               │
└──────────────────────┬──────────────────────────────┘
                       │ 数据
┌──────────────────────▼──────────────────────────────┐
│              数据层：常量表                           │
│  天干/地支/六十甲子/节气名/神煞名/宜忌名              │
│  农历闰月编码（64进制压缩）                           │
│  日/时辰宜忌、神煞表（十六进制编码）                   │
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

| 模块 | 文件 | 说明 |
|------|------|------|
| 公历 | `solar_*.mbt` | 公历日/月/年/时间计算，含闰年、星期、儒略日 |
| 农历 | `lunar_*.mbt` | 农历闰月算法（64进制压缩表）、月大小、节气定位 |
| 节气 | `solar_term.mbt` | 基于天文公式的节气时刻计算（~102行） |
| 干支 | `sixty_cycle*.mbt` | 六十甲子循环，支持年/月/日/时四柱 |
| 八字 | `eight_char.mbt` | 从农历时辰推导四柱，含胎元、命宫、身宫、纳音 |
| 宜忌 | `taboo.mbt` | 基于十六进制编码表的每日/时辰宜忌查询 |
| 神煞 | `god.mbt` | 130 种神煞名称及每日吉凶查询（吉神0-59，凶神60-129） |
| 童限 | `child_limit*.mbt` | 出生时刻到起运时刻的时长计算 |
| 小运/大运 | `fortune.mbt`, `decade_fortune.mbt` | 基于童限推演各年龄段运势 |
| 回历 | `hijri_*.mbt` | 伊斯兰历法转换 |
| 巴厘岛历 | `rab_byung_*.mbt` | 印尼巴厘岛历法 |
| 藏历五行 | `rab_byung_element.mbt` | 藏历五行（木火土铁水） |
| 斗宿 | `shou_xing_util.mbt` | 北斗九星相关计算（最大单体文件，~718行） |
| 事件 | `event*.mbt` | 自定义事件（节日、节假日等）构建与管理 |
| 灶马头 | `kitchen_god_steed.mbt` | 根据正月初一干支推算农历年运势（几龙治水等） |
| 小六壬 | `minor_ren.mbt` | 大安/留连/速喜/赤口/小吉/空亡 |
| 六曜 | `six_star.mbt` | 孔明六曜星（先胜/友引/先负/佛灭/大安/赤口） |
| 三元 | `sixty.mbt` | 上元/中元/下元（60年一循环） |
| 月相 | `phase.mbt`, `phase_day.mbt` | 新月/蛾眉月/上弦月等月相计算 |
| 胎神 | `fetus_month.mbt` | 逐月胎神（正十二月在床房，二三九十门户中等） |
| 法定假日 | `legal_holiday.mbt` | 中国法定节假日及调休安排（2001年至今） |
| 宫 | `zone.mbt` | 四方（东/南/西/北）及对应神兽 |
| 十神 | `ten_star.mbt` | 天干生克关系（比肩/劫财/食神等） |
| 星期 | `week.mbt` | 周日到周六 |
| 三候 | `three_phenology.mbt` | 每节气三候（初候/二候/三候） |
| 节气日 | `solar_term_day.mbt` | 节气第几天索引 |

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
6. **新增强类型**：新增了 `DecadeFortune`（大运）、`KitchenGodSteed`（灶马头）、`MinorRen`（小六壬）、`SixStar`（六曜）、`Sixty`（三元）等命理学概念。
7. **真太阳时反推**：`EightChar::get_solar_times()` 方法支持根据八字反推可能的公历时刻列表（1-9999年范围）。
8. **三柱反推**：`ThreePillars::get_solar_days()` 方法支持根据三柱反推公历日期。