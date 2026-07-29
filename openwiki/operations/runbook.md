---
title: 运维手册
type: page
description: 构建流程、CI/CD 配置、版本管理和故障排查指南
---

# 运维手册

## 构建流程

### 基础构建

```bash
# 进入项目目录
cd /Users/john/MoonbitProjects/tyme4mb

# 构建库
moon build tyme

# 构建产物
# - _build/packages.json  # 包元数据
# - _build/wasm/          # WASM 二进制
# - _build/tyme.mbt     # 编译后的 MoonBit 文件
```

### 开发构建

```bash
# 监听模式（文件变更自动重新构建）
moon build tyme --watch

# 生成调试信息
moon build tyme --debug
```

## CI/CD 配置

### GitHub Actions 工作流

项目使用 OpenWiki GitHub Action 自动维护文档：

```yaml
# .github/workflows/openwiki-update.yml
name: OpenWiki Update

on:
  workflow_dispatch:      # 手动触发
  schedule:
    - cron: "0 8 * * *"  # 每天 UTC 8:00

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
      - run: npm install --global openwiki@0.2.5
      - run: openwiki code --update --print
        env:
          OPENWIKI_PROVIDER: openrouter
          OPENROUTER_API_KEY: ${{ secrets.OPENROUTER_API_KEY }}
          OPENWIKI_MODEL_ID: z-ai/glm-5.2
      - uses: peter-evans/create-pull-request@v7
        with:
          add-paths: |
            openwiki
            AGENTS.md
            CLAUDE.md
            .github/workflows/openwiki-update.yml
          branch: openwiki/update
          commit-message: "docs: update OpenWiki"
```

### 环境变量

| 变量 | 说明 | 必需 |
|------|------|------|
| `OPENWIKI_PROVIDER` | AI 文档生成提供商 | 是 |
| `OPENROUTER_API_KEY` | OpenRouter API 密钥 | 是 |
| `OPENWIKI_MODEL_ID` | 使用的 AI 模型 | 否（默认 glm-5.2） |
| `OPENWIKI_LANGSMITH_API_KEY` | LangSmith 追踪密钥 | 否 |
| `LANGCHAIN_PROJECT` | LangSmith 项目名称 | 否 |
| `LANGCHAIN_TRACING_V2` | 启用追踪 | 否 |

## 版本管理

### 版本号规范

项目使用 `moon.mod` 文件管理版本：

```
name = "6tail/tyme4mb"
version = "0.1.0"
```

### 发布流程

1. 更新 `moon.mod` 版本号
2. 运行完整测试：`moon test tyme`
3. 提交变更并推送
4. GitHub Actions 自动创建 PR 更新文档

## 依赖管理

### 内部依赖

```moonbit
// tyme/moon.pkg
import {
  "moonbitlang/core/math" @math
}
```

唯一的外部依赖是标准库的 `math` 模块，用于天文计算中的浮点运算。

### 构建产物

```
_build/
├── .moon-lock      # 构建锁文件
├── packages.json   # 包元数据（自动生成）
└── wasm/           # WASM 二进制（自动生成）
```

## 代码规范

### 注释规范

代码注释采用中英双语：
- 中文：功能说明
- 英文：原始代码引用

```moonbit
///|
// SolarDay 公历日
pub struct SolarDay {
  day_unit : DayUnit
}
```

### 命名规范

- 类型名：PascalCase（如 `SolarDay`, `SixtyCycle`）
- 函数名：PascalCase（如 `from_ymd`, `get_lunar_day`）
- 变量名：camelCase（如 `leap_month`, `solar_term`）
- 常量名：UPPER_SNAKE_CASE（如 `HEAVEN_STEM_NAMES`）

### 导入规范

```moonbit
import tyme.{SolarDay, LunarDay}
import tyme.solar_term.{SolarTerm}
```

## 故障排查

### 构建失败

**问题**：`mbt build` 报错

**排查步骤**：
1. 检查 MoonBit 工具链版本：`mbt --version`
2. 清理构建缓存：`rm -rf _build/`
3. 重新构建：`moon build tyme`

### 测试失败

**问题**：交叉引用测试失败

**排查步骤**：
1. 确认参考实现版本
2. 检查测试数据是否被修改
3. 运行单个测试文件定位问题：
   ```bash
   moon test tyme/xref_all_wbtest.mbt --verbose
   ```

### 文档未更新

**问题**：OpenWiki 文档未自动更新

**排查步骤**：
1. 检查 GitHub Actions 运行日志
2. 确认 API 密钥配置正确
3. 手动触发 workflow：`workflow_dispatch`

## 性能优化

### 预计算策略

本项目采用预计算策略优化性能：
- 节气时刻：运行时计算公式（~250行）
- 农历闰月：内联压缩表（避免运行时计算）
- 宜忌神煞：预编码十六进制表（O(1) 查询）

### WASM 优化

构建时启用 WASM 优化：
```bash
moon build tyme --release
```

## 安全注意事项

1. **API 密钥**：OpenRouter 和 LangSmith 密钥存储在 GitHub Secrets 中，不应硬编码
2. **数据完整性**：农历闰月编码和宜忌表经过严格测试，不应手动修改
3. **版本锁定**：使用 `moon-lock` 文件锁定依赖版本
