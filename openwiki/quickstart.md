---
type: "参考"
title: "Tyme4MB — 快速开始"
openwiki_generated: true
---

---
title: 快速开始
type: page
description: Tyme4MB 项目入门指南，包含核心概念、快速上手和项目结构
---

# Tyme4MB — 快速开始

## 项目简介

`tyme4mb` 是一个 MoonBit 库，实现对**中国传统历法与时间体系**的完整计算能力。涵盖公历、农历、回历、干支、八字、节气、神煞、宜忌、童限/小运等模块。

- **包名**：`tyme`
- **版本**：`0.2.1`
- **依赖**：`moonbitlang/core/math`（用于天文计算中的取整运算）
- **输出**：WASM 运行时库（见 `_build/wasm/`）

## 核心概念速览

| 概念 | 说明 | 主要类型 |
|------|------|----------|
| 公历 | 格里高利历 | `SolarDay`, `SolarMonth`, `SolarYear`, `SolarTime` |
| 农历 | 中国传统阴阳合历 | `LunarDay`, `LunarMonth`, `LunarYear` |
| 干支 | 六十甲子循环 | `SixtyCycle`, `HeavenStem`, `EarthBranch` |
| 八字 | 四柱（年/月/日/时） | `EightChar`, `ThreePillars` |
| 节气 | 黄道十二节与中气 | `SolarTerm` |
| 宜忌 | 每日吉凶事项 | `Taboo` |
| 神煞 | 吉凶神煞符号（130种） | `God` |
| 童限/小运/大运 | 命理推算 | `ChildLimit`, `Fortune`, `DecadeFortune` |
| 回历 | 伊斯兰历 | `HijriDay`, `HijriMonth`, `HijriYear` |
| 巴厘岛历 | 印尼历法 | `RabByungDay`, `RabByungMonth`, `RabByungYear` |
| 月相 | 月相变化 | `Phase`, `PhaseDay` |
| 小六壬 | 占卜方法 | `MinorRen` |
| 六曜 | 孔明六曜星 | `SixStar` |
| 三元 | 上元/中元/下元 | `Sixty` |
| 灶马头 | 农历年运势 | `KitchenGodSteed` |
| 十神 | 天干生克关系 | `TenStar` |
| 宫 | 四方神兽方位 | `Zone` |
| 星期 | 周日到周六 | `Week` |
| 三候 | 节气三候 | `ThreePhenology` |
| 节气日 | 节气第几天 | `SolarTermDay` |

## 快速上手

### 1. 克隆与构建

```bash
# 使用 MoonBit 工具链
mbt build tyme
```

构建产物位于 `_build/`，包括 `packages.json` 和 WASM 二进制。

### 2. 基本用法：计算某日的干支

```moonbit
import tyme.{SolarDay, SolarTerm}

// 获取某公历日的干支
let day = SolarDay::from_ymd(2026, 8, 3)?
let sc_day = day.get_sixty_cycle_day()
println(sc_day.to_string())  // 输出干支日名称
```

### 3. 农历转换

```moonbit
import tyme.{LunarDay, SolarDay}

// 公历转农历
let solar = SolarDay::from_ymd(2026, 1, 29)?
let lunar = solar.get_lunar_day()
println(lunar.to_string())  // 农历日期
```

### 4. 八字排盘

```moonbit
import tyme.{EightChar, LunarHour}

// 通过农历时辰构造八字
let hour = LunarHour::from_ymd_time(year, month, day, hour_idx)?
let eight_char = eight_char_provider.get_eight_char(hour)
println(eight_char.to_string())
```

## 项目结构

```
tyme4mb/
├── tyme/                  # 主库源码
│   ├── moon.pkg           # facade 包声明
│   ├── reexports.mbt      # 保持原公开类型、函数和 trait 名称
│   ├── core/              # 领域实现（sealed trait 与历法类型）
│   │   ├── moon.pkg
│   │   ├── solar_*.mbt    # 公历相关
│   │   ├── lunar_*.mbt    # 农历相关
│   │   ├── hijri_*.mbt    # 回历
│   │   ├── rab_byung_*.mbt # 藏历（饶迥历）
│   │   ├── sixty_cycle*.mbt # 六十甲子
│   │   ├── ten_star.mbt   # 十神
│   │   ├── week.mbt       # 星期
│   │   ├── rab_byung_element.mbt # 藏历五行
│   │   └── *_wbtest.mbt   # 包内单元测试
│   └── astronomy/         # 无领域类型依赖的纯天文算法
│       ├── moon.pkg
│       └── shou_xing_util.mbt
├── examples/              # 示例工程
├── api_test/              # API 测试
├── openwiki/              # 本 Wiki 文档
├── _build/                # 构建产物（WASM + packages.json）
└── .github/workflows/     # CI/CD（OpenWiki 自动更新）
```

## 主要设计模式

1. **Trait-based 抽象**：`Tyme`（推移）、`Culture`（名称）、`Show`（字符串化）构成核心抽象层。
2. **LoopTyme 循环类型**：几乎所有枚举/序列类型底层都包装 `LoopTyme`，支持环形索引与推移操作。
3. **Provider 接口**：`IChildLimitProvider`、`IEightCharProvider` 支持策略注入（如不同流派算法）。
4. **静态数据表**：农历闰月编码、神煞宜忌等大数据以内联数组存储，避免外部依赖。
5. **逐行移植**：注释中保留原始代码引用，便于对照维护。
6. **多流派支持**：童限支持 Default、China95、LunarSect1、LunarSect2 四种实现。

## 测试

```bash
# 运行全部单元测试
mbt test tyme

# 运行交叉引用测试
mbt test tyme/xref_all_wbtest.mbt
```

测试文件：
- `eight_char_true_solar_wbtest.mbt` — 八字真太阳时测试
- `xref_all_wbtest.mbt` — 全量交叉引用测试（~2100行）
- `xref_gt_wbtest.mbt` / `xref_sx_wbtest.mbt` — 子集交叉测试

## 相关链接

- [架构概览](./architecture/overview.md)
- [领域概念 - 历法体系](./concepts/calendar-systems.md)
- [领域概念 - 干支系统](./domain-concepts/干支系统.md)
- [领域概念 - 神煞与宜忌](./domain-concepts/神煞与宜忌.md)
- [领域概念 - 童限](./domain-concepts/童限.md)
- [源码地图](./source-map.md)
- [工作流 - 八字计算](./workflows/八字计算.md)
- [工作流 - 历法转换](./workflows/历法转换.md)
- [测试指南](./testing.md)
- [运维手册](./operations/runbook.md)ing.md)
- [运维手册](./operations/runbook.md)