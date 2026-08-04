---
type: "参考"
title: "测试指南"
openwiki_generated: true
---

---
type: "参考"
title: "测试指南"
openwiki_generated: true
---

# 测试指南

## 测试框架

本项目使用 MoonBit 内置测试框架，测试文件以 `_wbtest.mbt` 后缀命名。

## 测试文件概览

| 文件 | 类型 | 覆盖范围 |
|------|------|----------|
| `eight_char_true_solar_wbtest.mbt` | 单元测试 | 八字真太阳时计算 |
| `xref_all_wbtest.mbt` | 集成测试 | 全量功能交叉测试 |
| `xref_gt_wbtest.mbt` | 对比测试 | 交叉验证 |
| `xref_sx_wbtest.mbt` | 单元测试 | 生肖相关功能 |

## 运行测试

### 基本命令
```bash
# 运行所有测试
moon test

# 运行特定测试文件
moon test tyme/xref_gt_wbtest.mbt

# 运行特定测试函数
moon test tyme/xref_gt_wbtest.mbt --filter test_eight_char

# 详细输出
moon test -v
```

### 测试过滤器
```bash
# 按名称过滤
moon test --filter "test_solar"

# 按文件过滤
moon test tyme/*wbtest.mbt
```

## 测试模式

### 基本断言
```moonbit
#[test]
fn test_basic() {
  let result = some_function()
  assert_eq(result, expected_value)
  assert_ne(result, unexpected_value)
  assert_true(condition)
  assert_false(condition)
}
```

### 结果断言
```moonbit
#[test]
fn test_result() {
  let result = some_function()
  match result {
    Ok(value) => assert_eq(value, expected),
    Err(e) => abort("unexpected error: " + e),
  }
}
```

### 批量测试
```moonbit
#[test]
fn test_batch() {
  let test_cases = [
    (1, 2, 3),
    (10, 20, 30),
    (100, 200, 300),
  ]
  
  for (a, b, expected) in test_cases {
    assert_eq(add(a, b), expected)
  }
}
```

## 关键测试场景

### 八字计算测试
```moonbit
// eight_char_true_solar_wbtest.mbt
#[test]
fn test_eight_char_true_solar() {
  // 测试真太阳时下的八字计算
  let solar_time = SolarTime::new(10, 30, 0)
  let true_time = solar_time.to_true_solar_time(120.0)
  let lunar_hour = LunarHour::from_solar_time(true_time).unwrap()
  let eight_char = default_provider.get_eight_char(lunar_hour)
  
  // 验证四柱
  assert_eq(eight_char.get_year().to_string(), "甲子")
  assert_eq(eight_char.get_month().to_string(), "乙丑")
  assert_eq(eight_char.get_day().to_string(), "丙寅")
  assert_eq(eight_char.get_hour().to_string(), "丁卯")
}
```

### 对比测试
```moonbit
// xref_gt_wbtest.mbt
#[test]
fn test_xref() {
  // 测试用例数据
  let test_cases = [
    (2024, 1, 1, 10, 0, 0, "甲子", "乙丑", "丙寅", "丁卯"),
    // ... 更多用例
  ]
  
  for (year, month, day, hour, minute, second, exp_year, exp_month, exp_day, exp_hour) in test_cases {
    let solar_day = SolarDay::from_ymd(year, month, day).unwrap()
    let solar_time = SolarTime::new(hour, minute, second)
    let lunar_hour = LunarHour::from_solar_time(solar_time).unwrap()
    let eight_char = default_provider.get_eight_char(lunar_hour)
    
    assert_eq(eight_char.get_year().to_string(), exp_year)
    assert_eq(eight_char.get_month().to_string(), exp_month)
    assert_eq(eight_char.get_day().to_string(), exp_day)
    assert_eq(eight_char.get_hour().to_string(), exp_hour)
  }
}
```

### 全量交叉测试
```moonbit
// xref_all_wbtest.mbt
#[test]
fn test_all_combinations() {
  // 测试所有可能的干支组合
  for year_idx in 0..60 {
    for month_idx in 0..60 {
      for day_idx in 0..60 {
        for hour_idx in 0..60 {
          let year = SixtyCycle::from_index(year_idx)
          let month = SixtyCycle::from_index(month_idx)
          let day = SixtyCycle::from_index(day_idx)
          let hour = SixtyCycle::from_index(hour_idx)
          
          // 验证组合合法性
          assert_valid(year, month, day, hour)
        }
      }
    }
  }
}
```

## 边界条件测试

### 年份边界
```moonbit
#[test]
fn test_year_boundaries() {
  // 测试公元1年
  let solar_day = SolarDay::from_ymd(1, 1, 1).unwrap()
  assert_ne(solar_day.to_string(), "")
  
  // 测试公元9999年
  let solar_day = SolarDay::from_ymd(9999, 12, 31).unwrap()
  assert_ne(solar_day.to_string(), "")
  
  // 测试公元前1年（用0表示）
  let lunar_year = LunarYear::from_year(0).unwrap()
  assert_ne(lunar_year.to_string(), "")
}
```

### 月份边界
```moonbit
#[test]
fn test_month_boundaries() {
  // 测试闰月
  let leap_month = LunarMonth::from_leap_ym(2024, 2).unwrap()
  assert_true(leap_month.is_leap())
  
  // 测试非法月份
  let result = LunarMonth::from_ym(2024, 13)
  assert_true(result.is_err())
}
```

### 日期边界
```moonbit
#[test]
fn test_date_boundaries() {
  // 测试非法日期
  let result = SolarDay::from_ymd(2024, 2, 30)
  assert_true(result.is_err())
  
  // 测试闰年2月29日
  let result = SolarDay::from_ymd(2024, 2, 29)
  assert_true(result.is_ok())
  
  // 测试非闰年2月29日
  let result = SolarDay::from_ymd(2023, 2, 29)
  assert_true(result.is_err())
}
```

## 性能测试

### 批量查询性能
```moonbit
#[test]
fn test_performance() {
  let start = @time.now()
  
  // 批量查询1000天的宜忌
  for year in 2020..2030 {
    for month in 1..13 {
      for day in 1..32 {
        match SolarDay::from_ymd(year, month, day) {
          Ok(solar_day) => {
            let _ = Taboo::get_day_taboo(solar_day)
          }
          Err(_) => continue,
        }
      }
    }
  }
  
  let elapsed = @time.now() - start
  println("Elapsed: " + elapsed.to_string() + "ns")
}
```

## 测试数据维护

### 导出测试数据
```bash
moon run export-tests
```

### 更新测试用例
1. 修改 `xref_gt_wbtest.mbt` 中的测试数据
2. 运行测试验证
3. 确保输出一致

## 持续集成

### GitHub Actions
测试在每次推送时自动运行：
```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: moon test
```

### 本地检查
```bash
# 运行所有测试前检查
moon test --report

# 生成测试覆盖率报告
moon test --coverage
```

## 常见问题

### Q: 测试失败如何调试？
A: 使用 `--filter` 参数运行单个测试，添加 `println` 输出调试信息。

### Q: 如何添加新的测试用例？
A: 在对应的 `_wbtest.mbt` 文件中添加 `#[test]` 标记的函数。

### Q: 对比测试数据从哪里来？
A: 从测试用例导出，确保计算结果一致。