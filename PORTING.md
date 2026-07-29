# 移植说明

## 原项目信息

| 项目 | 说明 |
|------|------|
| 原项目名称 | tyme4go |
| 原项目链接 | https://github.com/6tail/tyme4go |
| 原项目作者 | 6tail |
| 原项目许可证 | MIT License (Copyright (c) 2024 6tail) |
| 原项目语言 | Go (go1.19+) |
| 原项目版本 | v1.5.0 (2026-06-11) |

## 移植范围

本次移植涵盖 tyme4go v1.5.0 的全部功能模块，包括：

### 已完成移植的模块

| 模块 | Go 源文件数 | MoonBit 文件数 | 说明 |
|------|-------------|---------------|------|
| 基础抽象层 | 5 | 5 | Tyme/Culture trait、AbstractTyme/Culture/CultureDay/Festival |
| 公历系统 | 15 | 15 | SolarDay/Month/Year/Time/Term/Festival/Week/Season/HalfYear、JulianDay、Ecliptic、Phenology、PlumRain |
| 农历系统 | 14 | 17 | LunarYear/Month/Day/Hour/Festival/Week/Season、Fetus*、LunarSect*Provider |
| 干支系统 | 10 | 10 | SixtyCycle/Day/Month/Year/Hour、HeavenStem、EarthBranch、HideHeavenStem* |
| 八字命理 | 12 | 12 | EightChar、ThreePillars、ChildLimit*、Fortune、DecadeFortune、I*Provider |
| 神煞宜忌 | 4 | 6 | God、Taboo、Event*（含 EventBuilder、EventManager、EventType） |
| 回历系统 | 3 | 3 | HijriDay/Month/Year |
| 藏历系统 | 4 | 4 | RabByungDay/Month/Year/Element |
| 其他命理 | 25+ | 25+ | Zodiac、Animal、Constellation、Phase、MinorRen、SixStar、KitchenGodSteed 等 |
| 工具层 | 3 | 3 | ShouXingUtil（天文算法）、LegalHoliday、LoopTyme |
| **合计** | **~117** | **~117** | 完整移植 |

### 测试移植

- 43 个测试文件（`*_wbtest.mbt`），约 3,200 行测试代码
- 全量交叉引用测试（`xref_all_wbtest.mbt`，~2100 行）
- 神煞/宜忌差分测试（`xref_gt_wbtest.mbt`）
- 八字真太阳时测试
- 事件管理器完整测试
- 测试用例与 Go 版本一比一对应，黄金值取自 Go 实跑输出

## 对原项目所做的修改和适配

### 1. 语言层面适配

| Go 特性 | MoonBit 适配方式 |
|---------|-----------------|
| struct 方法 | 独立函数 + 第一个参数为 `self` |
| interface | trait |
| nil 返回值 | `Option[T]` 或 `Result[T, String]` |
| 全局变量 | `pub let` 全局常量或值类型传递 |
| goroutine | 不涉及（纯计算库） |
| 错误返回 (error) | `Result[T, String]` |
| strings.Builder | String 拼接 |

### 2. EventManager 设计变更

Go 版本使用全局单例 + 方法接收者模式。MoonBit 版本采用**纯值类型设计（方案 C）**：

- `EventManager` 为不可变值类型，所有操作返回新实例
- 调用方显式持有并传递 `EventManager` 实例
- 无任何全局可变状态
- 内部使用 `Map[String, String]` 替代 Go 的字符串拼接方案，天然支持 UTF-8 事件名

### 3. 数据编码保持一致

- 农历闰月编码：64 进制字符表，与 Go 版本完全一致
- 神煞/宜忌编码：十六进制位图，与 Go 版本完全一致
- 天文常数（△T 参数等）：与 Go 版本完全一致

### 4. 依赖差异

| 项目 | Go 版本 | MoonBit 版本 |
|------|---------|-------------|
| 外部依赖 | 无 | `moonbitlang/core/math`（浮点取整） |
| 运行时 | Go runtime | WASM |
| 测试框架 | Go testing | wbtest（MoonBit 内置） |

## 尚未移植或暂不支持的功能

当前已完整移植 tyme4go v1.5.0 的全部功能，无尚未移植的模块。

## 版本对应关系

| tyme4mb 版本 | 对应 tyme4go 版本 | 说明 |
|-------------|------------------|------|
| 0.1.0 | v1.5.0 | 完整移植，首次发布 |

## 许可证合规

- 本项目保留原项目的 MIT 许可证及版权声明
- 原项目版权：Copyright (c) 2024 6tail
- 本项目为移植项目，在 MIT 许可证下享有同等权利
- 节气算法引自 [sxwnl/sxwnl](https://github.com/sxwnl/sxwnl)，藏历数据引自 [stonelf/zangli](https://github.com/stonelf/zangli)，均已在源码注释中标注来源
