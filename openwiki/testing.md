---
title: 测试指南
type: page
description: 单元测试、交叉引用测试和 CI/CD 配置详解
---

# 测试指南

## 测试框架

本项目使用 MoonBit 内置的 `wbtest` 测试框架。所有测试文件以 `_wbtest.mbt` 后缀命名。

## 测试类型

### 1. 单元测试

每个模块都有对应的单元测试，验证核心功能的正确性。

```bash
# 运行特定模块测试
mbt test tyme/solar_day_wbtest.mbt

# 运行全部测试
mbt test tyme
```

### 2. 交叉引用测试（XRef Tests）

这是本项目最重要的测试类型，用于验证计算结果的一致性。

| 文件 | 说明 | 测试范围 |
|------|------|----------|
| `xref_all_wbtest.mbt` | 全量交叉测试 | 所有时间类型的计算结果 |
| `xref_gt_wbtest.mbt` | 公历子集测试 | 公历相关计算 |
| `xref_sx_wbtest.mbt` | 特殊子集测试 | 特定边界条件 |
| `eight_char_true_solar_wbtest.mbt` | 真太阳时测试 | 八字真太阳时计算 |

**测试方法**：
```bash
# 运行全量交叉测试
mbt test tyme/xref_all_wbtest.mbt

# 运行八字真太阳时测试
mbt test tyme/eight_char_true_solar_wbtest.mbt
```

### 3. 生成测试

`pkg.generated.mbti` 文件由构建系统自动生成，包含所有公开 API 的类型信息。不应手动编辑此文件。

```bash
# 构建时自动生成
mbt build tyme
```

## 测试数据结构

### 测试用例格式

```moonbit
// 测试公历日转换
let test_cases = [
  (2026, 1, 1, "甲子"),  // (年, 月, 日, 期望干支)
  (2026, 8, 3, "丙午"),
]

for (year, month, day, expected) in test_cases {
  let solar = SolarDay::from_ymd(year, month, day)?
  let actual = solar.get_sixty_cycle_day().to_string()
  assert_eq(actual, expected)
}
```

### 边界条件测试

测试文件特别关注以下边界情况：
- 年份边界：-1, 0, 1, 9999
- 闰年测试：1582 年（格里高利历改革）、4 年闰年、100 年不闰、400 年闰
- 农历闰月：19 年周期、闰月判断
- 节气时刻：精确到秒
- 真太阳时：时差修正

## 运行测试

### 基本命令

```bash
# 进入项目目录
cd /Users/john/MoonbitProjects/tyme4mb

# 运行所有测试
mbt test tyme

# 运行特定测试文件
mbt test tyme/xref_all_wbtest.mbt

# 运行测试并输出详细结果
mbt test tyme --verbose
```

### 测试覆盖范围

| 模块 | 测试文件 | 覆盖内容 |
|------|----------|----------|
| 公历 | `xref_gt_wbtest.mbt` | 日/月/年转换、星期、干支日 |
| 农历 | `xref_all_wbtest.mbt` | 闰月、月大小、农历日转换 |
| 八字 | `eight_char_true_solar_wbtest.mbt` | 四柱计算、真太阳时 |
| 干支 | `xref_all_wbtest.mbt` | 六十甲子、天干地支属性 |
| 节气 | `xref_all_wbtest.mbt` | 节气时刻、月相 |
| 宜忌 | `xref_all_wbtest.mbt` | 每日宜忌、时辰宜忌 |
| 神煞 | `xref_all_wbtest.mbt` | 神煞查询、吉凶判断 |
| 童限 | `xref_all_wbtest.mbt` | 童限计算、小运推算 |
| 回历 | `xref_all_wbtest.mbt` | 回历转换 |

## 测试数据源

### 参考实现

所有交叉引用测试的参考结果确保计算结果一致：
- 覆盖所有公开 API 的计算路径
- 覆盖所有公开 API 的计算路径

### 测试数据编码

部分测试数据采用编码格式存储（如十六进制位图），测试时会解码验证：
- 宜忌表：12行×31列的十六进制字符串
- 神煞表：类似编码
- 农历闰月：64进制压缩编码

## 调试技巧

### 查看测试输出

```bash
# 详细输出
mbt test tyme --verbose 2>&1 | head -100

# 仅显示失败用例
mbt test tyme 2>&1 | grep -E "FAIL|Error"
```

### 添加调试输出

在测试文件中添加：
```moonbit
println("调试: year=\{year}, month=\{month}, day=\{day}")
```

### 隔离问题

如果某个测试失败，可以单独运行该测试文件：
```bash
mbt test tyme/eight_char_true_solar_wbtest.mbt
```

## CI/CD

项目配置了 GitHub Actions 自动测试：

```yaml
# .github/workflows/openwiki-update.yml
- name: Run tests
  run: mbt test tyme
```

每次提交都会自动触发测试，确保代码变更不会破坏现有功能。
