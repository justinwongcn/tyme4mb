---
type: 参考
title: Tyme4MB — 快速开始
description: Tyme4MB 项目入门指南，包含核心概念、快速上手和项目结构
---

# Tyme4MB — 快速开始

## 项目简介

`tyme4mb` 是一个 MoonBit 库，实现对**中国传统历法与时间体系**的完整计算能力。涵盖公历、农历、回历、干支、八字、节气、神煞、宜忌、童限/小运等模块。

- **包名**：`tyme`
- **版本**：`0.2.3`
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
| 六破 | 地支相破关系 | `EarthBranch.get_po()` |
| 三合局 | 地支三合五行 | `EarthBranch.get_san_he_element()` |
| 三会方 | 地支三会方位 | `EarthBranch.get_san_hui_element/direction()` |

## 快速上手

### 1. 克隆与构建

```bash
# 使用 MoonBit 工具链
moon build
moon test
```

构建产物位于 `_build/`，包括 `packages.json` 和 WASM 二进制。

### 2. 基本用法：计算某日的干支

```moonbit
import tyme.{SolarDay, SolarTerm}

// 获取某公历日的干支
let day = SolarDay::from_ymd(2026, 8, 3).unwrap()
let sc_day = day.get_sixty_cycle_day()
println(sc_day.to_string())  // 输出干支日名称
```

### 3. 农历转换

```moonbit
import tyme.{LunarDay, SolarDay}

// 公历转农历
let solar = SolarDay::from_ymd(2026, 1, 29).unwrap()
let lunar = solar.get_lunar_day()
println(lunar.to_string())  // 农历日期
```

### 4. 八字排盘

```moonbit
import tyme.{EightChar, SolarTime}

// 通过公历时间构造八字
let solar_time = SolarTime::from_ymdhms(1986, 5, 29, 13, 0, 0).unwrap()
let eight_char = solar_time.get_lunar_hour()?.get_eight_char()
println(eight_char.to_string())
```

## 项目结构

```
tyme4mb/
├── tyme/                  # 主库源码
│   ├── moon.pkg           # 包声明
│   ├── reexports.mbt      # 向后兼容导出
│   ├── base/              # 基础类型层
│   │   ├── moon.pkg
│   │   └── *.mbt          # 抽象基类型、trait、枚举
│   ├── core/              # 领域实现层
│   │   ├── moon.pkg
│   │   ├── solar_*.mbt    # 公历相关
│   │   ├── lunar_*.mbt    # 农历相关
│   │   ├── hijri_*.mbt    # 回历
│   │   ├── rab_byung_*.mbt # 藏历（饶迥历）
│   │   ├── sixty_cycle*.mbt # 六十甲子
│   │   ├── eight_char.mbt # 八字
│   │   ├── three_pillars.mbt # 三柱
│   │   ├── child_limit*.mbt # 童限计算
│   │   ├── fortune.mbt    # 小运
│   │   ├── decade_fortune.mbt # 大运
│   │   ├── god.mbt        # 神煞
│   │   ├── taboo.mbt      # 宜忌
│   │   ├── event*.mbt     # 事件系统
│   │   ├── kitchen_god_steed.mbt # 灶马头
│   │   ├── minor_ren.mbt  # 小六壬
│   │   ├── six_star.mbt   # 六曜
│   │   ├── sixty.mbt      # 三元
│   │   ├── phase.mbt      # 月相
│   │   ├── legal_holiday.mbt # 法定假日
│   │   ├── hide_heaven_stem_ecliptic.mbt # 真黄经人元司令
│   │   └── *_wbtest.mbt   # 包内单元测试
│   ├── astronomy/         # 纯天文算法层
│   │   ├── moon.pkg
│   │   ├── astronomy_*.mbt # 天文算法与常量
│   │   └── true_solar_time.mbt # 真太阳时计算
│   └── pkg.generated.mbti # 生成导出接口
├── examples/              # 示例工程
├── api_test/              # API 集成测试
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
7. **真太阳时支持**：v0.2.2 起支持真太阳时计算，童限支持双轨模式（平太阳时/真太阳时）。
8. **地支关系扩展**：v0.2.3 新增六破、三合局、三会方局等地支关系计算方法。

## 测试

```bash
# 运行全部测试
moon test

# 运行特定包测试
moon test tyme/core
moon test tyme/astronomy
moon test api_test
```

测试文件组织：
- `tyme/core/*_wbtest.mbt` — 包内单元测试
- `tyme/astronomy/*_wbtest.mbt` — 天文算法测试
- `api_test/*.mbt` — API 集成测试（日历、干支、神煞、童限、真太阳时等）

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
- [运维手册](./operations/runbook.md)
