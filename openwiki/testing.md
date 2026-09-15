---
type: 参考
title: 测试指南
description: 测试组织方式、运行方法和测试覆盖说明
---

# 测试指南

## 测试组织

项目测试按包结构组织，分为三类：

### 1. 包内单元测试
位于 `tyme/core/*_wbtest.mbt` 和 `tyme/astronomy/*_wbtest.mbt`，每个包有自己的测试文件。

### 2. API 集成测试
位于 `api_test/` 目录，覆盖跨包功能验证：

| 测试文件 | 覆盖范围 |
|----------|----------|
| `test_calendar.mbt` | 公历/农历/回历转换 |
| `test_culture.mbt` | 文化名称查询 |
| `test_festival.mbt` | 节日查询 |
| `test_fortune.mbt` | 童限、大运、小运计算 |
| `test_hide_heaven_stem_ecliptic.mbt` | 真黄经人元司令分野 |
| `test_lunar.mbt` | 农历系统 |
| `test_shensha.mbt` | 神煞宜忌 |
| `test_sixty_cycle.mbt` | 干支系统 |
| `test_solar.mbt` | 公历系统 |
| `test_true_solar_time.mbt` | 真太阳时计算 |

## 运行测试

```bash
# 运行全部测试
moon test

# 运行特定包测试
moon test tyme/core
moon test tyme/astronomy
moon test api_test

# 带警告检查（CI 使用）
moon test --deny-warn
```

## 测试策略

### 与 Go 版本对照
原始 tyme4go 有大量测试，本项目通过 `api_test/` 中的集成测试验证核心功能正确性。

### 真太阳时测试
`test_true_solar_time.mbt` 验证均时差计算和真太阳时转换的正确性。

### 人元司令分野测试
`test_hide_heaven_stem_ecliptic.mbt` 是较大的测试文件，验证真黄经人元司令分野的计算。

## CI 检查

GitHub Actions 运行以下检查：
- `moon fmt --check` - 代码格式检查
- `moon check --deny-warn` - 类型检查，禁止警告
- `moon test --deny-warn` - 测试运行，禁止警告
