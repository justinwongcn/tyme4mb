# MoonBit 隐式 Trait 方法提升弃用治理

> 状态：已完成（2026-08-22）
>
> 验证：`moon check --target all` 无错误、无警告；`api_test` 在 wasm、wasm-gc、js、native
> 四个目标下均为 134/134 通过。

## 目标

逐步消除 MoonBit `Warning [0020]`：通过 trait 实现隐式提升的实例方法调用已被弃用。

本项工作不得改变 [api.md](../api.md) 规定的伪代码调用形态。调用方仍应能够使用
`value.get_name()`、`value.next(n)` 与 `value.to_string()`；仅调整 MoonBit 中使这些调用
成为显式、稳定方法的声明方式。

## 修复前现状

2026-08-22 使用 `moon check --target all` 验证：项目有 292 个警告，其中 291 个是
`Warning [0020]`。它们来自以下模式：

```mbt
pub impl Culture for LunarYear with fn get_name(self : LunarYear) -> String {
  // ...
}

// 此调用目前可用，但编译器将其标为 implicit promotion deprecated。
let name = lunar_year.get_name()
```

`Culture`、`Tyme` 是公开 trait，定义在 `tyme/base`；`Show` 是 MoonBit 标准 trait。
实现 trait 本身并不会稳定地把方法提升为类型的固有方法。

## 完成记录

已为相关公开类型补充显式 `Culture`、`Tyme` 与 `Show` extension，保留了
`api.md` 规定的 `value.get_name()`、`value.next(n)` 和 `value.to_string()` 调用方式。
复验结果为 `Warning [0020]` 数量为 0。

## 统一修复方式

为每个需要保留点号调用方式的类型显式转发相应的 trait 方法：

```mbt
extend LunarYear with Culture::{get_name, ..}
extend LunarYear with Tyme::{next, ..}
extend LunarYear with Show::{to_string, ..}
```

约束：

- 不把调用改写为 `Culture::get_name(value)`、`Tyme::next(value, n)` 或
  `Show::to_string(value)`，因为这会偏离 `api.md` 的统一调用模型。
- 不重复实现同一业务逻辑；extension 只显式暴露已有 trait 实现。
- 仅为 API 文档或公开 API 测试实际要求的点号方法添加 extension。
- `next` 只适用于实现 `Tyme` 的类型；`to_string` 只适用于已有 `Show` 实现的类型。

## 处理批次（已完成）

### 第一批：公开 API 的 `Culture` 与 `Tyme`

处理 `tyme/base` 与 `tyme/core` 中实现 `Culture` 或 `Tyme`，且在 `api.md` 或
`api_test` 中以点号调用 `get_name`、`next` 的公开领域类型。

优先覆盖 `LunarYear`、`LunarMonth`、`LunarDay`、`SolarYear`、`SolarMonth`、`SolarDay`、
`SolarTime`、干支、生肖、节气及节日类型。

完成标准：`api_test` 不再产生上述两类 `Warning [0020]`。

### 第二批：公开 API 的 `Show`

为 `api.md` 或 `api_test` 使用 `value.to_string()` 的公开类型添加
`extend Type with Show::{to_string, ..}`。

完成标准：所有文档化的 `to_string()` 调用无隐式提升警告。

### 第三批：包内实现与白盒测试

处理剩余 `tyme/base`、`tyme/core` 内部调用及 `*_wbtest.mbt`。若调用不是公开调用契约，
可选择显式 extension（保持一致）或 trait 限定调用（仅内部代码）。

完成标准：`moon check --target all` 不再报告 `Warning [0020]`。

## 验证

每完成一个类型组，执行：

```sh
moon fmt
moon check --target all
moon test api_test --target wasm-gc
```

全部完成后，执行：

```sh
moon check --target all
moon test --target all
moon info --target all
git diff -- pkg.generated.mbti tyme/pkg.generated.mbti tyme/base/pkg.generated.mbti tyme/core/pkg.generated.mbti
```

预期结果：

- `Warning [0020]` 数量为 0；
- `api_test` 与全量测试通过；
- `api.md` 所列调用方式不变；
- 除非明确新增 API，生成的公开接口文件不产生意外变更。

## 非目标

- 不恢复已删除的内部 MoonBit 子包；
- 不改变 `Result`、`Option` 或其他 MoonBit 错误处理方式；
- 不重命名任何 `api.md` 中的类型、工厂函数或实例方法；
- 不将本治理任务与领域算法或包结构重构混合。
