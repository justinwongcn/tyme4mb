# Changelog

## [0.2.3] - 2026-09-02

### 新增

- `EarthBranch` 地支六破 `get_po()`（子酉破、丑辰破、寅亥破、卯午破、巳申破、戌未破）
- `EarthBranch` 三合局五行 `get_san_he_element()`（申子辰水局、寅午戌火局、巳酉丑金局、亥卯未木局）
- `EarthBranch` 三会方局五行与方位 `get_san_hui_element()` / `get_san_hui_direction()`（亥子丑北水、寅卯辰东木、巳午未南火、申酉戌西金）

## [0.2.2] - 2026-08-24

### 新增

- 真太阳时支持：均时差、太阳视赤经、太阳赤纬、真太阳时反推（`equation_of_time` 等天文函数）
- 真太阳时功能扩展：童限双轨（真太阳时/平太阳时）、太阳正午、日出日落
- 真黄经人元司令分野 `EclipticHideHeavenStemDay`

### 变更

- 拆分 `SolarDay` / `SolarTime` 跨域方法，重组历法领域模块并稳定公开调用
- 拆分交叉引用测试并按领域组织，保持跨域测试顺序稳定
- 补充 CI：`moon fmt --check`、`moon check --deny-warn`、`moon test --deny-warn`

## [0.2.1] - 2026-08-07

### 变更

- 重组 `tyme` 包结构，增强事件管理
- 发布 v0.2.1

## [0.2.0] - 2026-08-04

### 修复

- 修复外部包 `Show` trait 不可用问题（含 self 参数清理）

### 变更

- 纳入 mbti 文件到版本控制，补充 `.gitignore`
- 发布 v0.2.0

## [0.1.0] - 2026-08-04

### 首次发布

本项目为 [tyme4go](https://github.com/6tail/tyme4go) v1.5.0 的 MoonBit 移植版本。

### 新增

1. 完整移植 tyme4go v1.5.0 全部功能模块，包括：
   - 公历系统（SolarDay/Month/Year/Time/Term/Festival/Week/Season/HalfYear）
   - 农历系统（LunarYear/Month/Day/Hour/Festival/Week/Season）
   - 回历系统（HijriDay/Month/Year）
   - 藏历系统（RabByungDay/Month/Year/Element）
   - 干支系统（SixtyCycle/Day/Month/Year/Hour、HeavenStem、EarthBranch）
   - 八字命理（EightChar、ThreePillars、ChildLimit、Fortune、DecadeFortune）
   - 神煞宜忌（God 130种、Taboo）
   - 事件管理（Event、EventBuilder、EventManager、EventType）
   - 其他命理概念（星座、月相、二十八星宿、九星、六曜、小六壬、灶马头、彭祖百忌、胎神等）
   - 法定假日（含调休，2001年至今）
   - 天文算法（ShouXingUtil，基于寿星天文历）

2. 43 个测试文件，约 3,200 行测试代码，与 Go 版本一比一对应

3. EventManager 采用纯值类型设计（方案 C），无全局可变状态

4. 支持 WASM 编译目标

5. OpenWiki 自动文档生成

6. GitHub Actions CI 持续集成

7. 示例工程

### 对应原项目版本

- tyme4go v1.0.0 (2024-09-26)：初始版本
- tyme4go v1.0.1 - v1.0.9：吉神宜趋修复、起运流派、小六壬、法定假日、人元司令分野、地势修复
- tyme4go v1.1.0：时辰忌修复
- tyme4go v1.3.0 - v1.3.9：干支年月日时辰、童限大运小运、藏历、月相、三柱反推
- tyme4go v1.4.0 - v1.4.3：调休修复、事件系统、节日重构
- tyme4go v1.5.0：移除 FestivalType、新增回历、代码优化
