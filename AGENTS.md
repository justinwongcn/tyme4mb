<!-- OPENWIKI:START -->

## OpenWiki

This repository has a generated `openwiki/` evidence index. It is optional just-in-time context, not required startup reading.

- Treat source code and tests as authoritative. A brief's unknowns and review items are verification gaps, not automatic requirements.
- Prefer the narrowest quiet validation that proves the changed behavior. Preserve complete failure output.

The scheduled OpenWiki GitHub Actions workflow refreshes the repository wiki. Do not hand-edit generated OpenWiki pages unless explicitly asked; prefer updating source code/docs and letting OpenWiki regenerate.

<!-- OPENWIKI:END -->

## Review 与修复原则

首先判断当前需要 review 的内容是否已经收敛到不再需要 review；如果尚未收敛，应继续 review，而不是过早进入修改。不要只做止血修复，应从根本上分析造成问题的原因并完成根因修复。

## MoonBit 接口设计依据

Go、Java 和 TypeScript 的接口文档分别位于 `go.md`、`java.md` 和 `ts.md`。以这三份文档为主要依据；无法确定 MoonBit 接口应如何设计时，直接参考三份文档表达的行为和调用契约，并结合 MoonBit 的语法、类型系统与惯用方式制定调用 API。

## MoonBit 项目环境

以下信息供 Skills 直接引用，无需每次重复运行 `moon version` 或扫描项目文件。若 `moon.mod` 或 `moon.pkg` 有变更，应同步更新本节。

### 工具链

- **moon 版本**: `0.1.20260920`（2026-09-20 构建）
- **Feature flags**: `rr_moon_mod`（使用 `moon.mod` 而非旧版 `moon.mod.json`）、`rr_moon_pkg`（使用 `moon.pkg` 而非旧版 `moon.pkg.json`）
- **已验证支持的编译目标**: `wasm-gc`、`wasm`、`js`、`native`（`--target all` 均可通过）
- **默认编译目标**: `wasm-gc`（moon 默认）
- **项目无 `preferred-target` 设置**，所有目标均可用

### 模块元数据（moon.mod）

| 字段 | 值 |
|------|------|
| 模块名 | `justinwongcn/tyme4mb` |
| 版本 | `0.2.4` |
| 许可证 | MIT |
| 仓库 | https://github.com/justinwongcn/tyme4mb |
| README | `README.md` |
| 关键词 | calendar, lunar, chinese-calendar, astronomy, bazi |
| 外部依赖 | 无（仅依赖 `moonbitlang/core`） |

### 包结构与依赖关系

```
tyme4mb/
├── tyme/                  # facade 包，通过 reexports.mbt 重导出 @tyme/core 的公开 API
│   ├── moon.pkg           # import: tyme/core
│   ├── reexports.mbt      # pub using 重导出
│   └── pkg.generated.mbti # 公开接口签名
├── tyme/core/             # 领域实现包（所有历法类型、算法）
│   ├── moon.pkg           # import: moonbitlang/core/math, tyme/astronomy, tyme/base
│   └── pkg.generated.mbti
├── tyme/base/             # 基础抽象包（AbstractCulture/AbstractTyme/LoopTyme 与 Culture/Tyme trait）
│   ├── moon.pkg           # 无外部 import
│   └── pkg.generated.mbti
├── tyme/astronomy/        # 纯天文算法包（寿星天文历，无领域类型依赖）
│   ├── moon.pkg           # import: moonbitlang/core/math
│   └── pkg.generated.mbti # 含真太阳时天文函数：sa_lon, mean_obliquity, nutation_obliquity, true_obliquity, lo_to_ra, sun_apparent_ra, equation_of_time, solar_declination
├── api_test/              # 黑盒 API 测试（import: tyme）
├── examples/              # 示例可执行包（import: tyme, is-main: true）
└── moon.mod               # 模块声明
```

### 文件格式约定

- 模块声明文件: `moon.mod`（非 `moon.mod.json`）
- 包声明文件: `moon.pkg`（非 `moon.pkg.json`）
- 公开接口签名: `pkg.generated.mbti`（由 `moon info` 生成，已纳入版本控制）
- 源码文件: `*.mbt`，白盒测试: `*_wbtest.mbt`，黑盒测试: `*_test.mbt`

### trait 方法显式提升约定

moon `0.1.20260920` 起，`pub impl Trait for T` 的方法不再允许**隐式提升**为 `T` 的普通方法（诊断 `implicit_impl_as_method`，错误码 0079），而 `moon check --deny-warn` 会将其判为失败。因此每个 `pub impl Trait for T` 都必须配一条同类显式声明：

- `pub extend T with Culture::{get_name}`
- `pub extend T with Show::{to_string, output}`（`output` 必须一并列出，只写 `to_string` 仍会报错）
- `pub extend T with Tyme::{next}`

特例：若 `T` 已经存在同名固有方法（例如 `pub fn T::get_name`），**不能**再写 `pub extend`——会触发重复定义（4056），加 `#deprecated` 也无法绕过。此时应删除固有方法，把它原本的函数体移入 trait impl，由 `pub extend` 继续对外提供同名方法。

新增类型时请照此办理，并运行 `moon info` 更新 `pkg.generated.mbti`。

### 项目特殊约定

- `.agents/` 目录在 `.gitignore` 中，不纳入版本控制
- `_build/` 为构建产物，不纳入版本控制
- `tyme4go/` 为原始 Go 参考源码，不纳入版本控制
- `.repos/` 为 `moon fetch` 下载的第三方源码，不纳入版本控制
