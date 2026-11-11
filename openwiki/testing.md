# Testing

测试分三层：**白盒单元测试**（黄金值）、**与 Go 参考实现的差分对拍**（行为等价）、**黑盒 API 测试**（公开面可达性与数值）。CI 链为 `moon fmt --check` → `moon check --deny-warn` → `moon build` → 多目标构建（wasm-gc / wasm / js / native）→ `moon test --deny-warn`（[.github/workflows/ci.yml](../.github/workflows/ci.yml)），任何 warning 即失败。

## 白盒测试（*_wbtest.mbt）

60 个文件在 `tyme/core/`（base、astronomy 各 1–2 个），大多与 Go 版测试一比一移植，黄金值取自 Go 实跑输出。断言统一走 [test_helper_wbtest.mbt](../tyme/core/test_helper_wbtest.mbt) 的 `expect_eq / expect_ne / expect_true / expect_false / expect_near`——MoonBit 无 assert 关键字，实现为 `abort(...)`；文件末尾有 `test_helper_sanity` 自检。白盒测试对非测试代码不可见，性能敏感的 `import` 也只对 wbtest 开放（如 `moonbitlang/core/bench`）。

## 差分对拍（xref_*.mbt）

与本地未入库的 Go 参考源码 `tyme4go/` 对拍，机制是**打印型差分**：测试只 `println` 带 tag 的行、不做断言，把输出与 Go 版对应 `TestXrefXxx` 的 stdout 逐行比对：

```bash
moon test --target native tyme/core/xref_gt_wbtest.mbt -f xref_gt 2>/dev/null
# 输出重定向保存，再与 Go 版实跑输出 diff（对比脚本不在仓库，流程记录在
# docs/superpowers/plans/2026-09-16-god-taboo-query-index.md）
```

| 文件 | 对拍内容 |
|------|----------|
| [xref_gt_wbtest.mbt](../tyme/core/xref_gt_wbtest.mbt) | God 151/Taboo 140 枚举与全部 60×60 月柱×日柱组合的宜忌查询（god/taboo 索引优化的差分护栏；用 `SixtyCycleMonth::new/Day::new` 强构任意组合） |
| `xref_01_downstream` … `xref_10_foundations` | 下游类型、干支、农历（含 2033 闰月边界）、法定假日/调休、三柱、公历文化、童限双轨、公历核心（含 1582-10 切换）、天文（儒略日毫秒级）、Go 版全部 19 组枚举循环 |

注意：这是**打印型**测试，多 target 并发跑会破坏 UTF-8 输出顺序，须逐个执行。

## 黑盒测试（api_test/）

10 个文件、约 2472 行，只 import facade 包 `tyme`，验证公开 API 可从包外调用（签名即 [tyme/pkg.generated.mbti](../tyme/pkg.generated.mbti)）：

| 文件 | 主题 |
|------|------|
| test_solar / test_lunar / test_sixty_cycle / test_culture / test_calendar / test_festival / test_fortune | 公历、农历、干支八字、文化枚举、藏历回历节气月相、节日假日事件、童限大运（多数为可达性风格） |
| [test_shensha.mbt](../api_test/test_shensha.mbt) | 八字神煞 V2 全 55 条实质断言 |
| [test_true_solar_time.mbt](../api_test/test_true_solar_time.mbt) | 真太阳时四城数值、极昼极夜、童限双轨一致性 |
| [test_hide_heaven_stem_ecliptic.mbt](../api_test/test_hide_heaven_stem_ecliptic.mbt) | 真黄经司令分野节气边界锚点（±2h，含 NaN 防护） |

黑盒包不能复用 core 的 test_helper，`expect_eq`/`assert_true` 在个别文件内重复定义（历史约定，沿用即可）。

## 基准测试（*_bench_wbtest.mbt）

用 `moonbitlang/core/bench` 的 `@bench.T`，三个基准与各自的索引优化护栏：

```bash
moon bench --target native tyme/core/god_taboo_bench_wbtest.mbt
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release   # 闰月 O(1) 索引
moon bench tyme/core/rab_byung_leap_bench_wbtest.mbt --target native --release
```

性能优化流程（`docs/superpowers/plans/` 各 plan 的既有做法）：改动前先连跑 3 次保存基线、改动后配对比较，**仓库内不存基线数据**（历史基线只落 /tmp）。

## 改动验证矩阵

| 改什么 | 必跑 |
|--------|------|
| core 任意公开 API | wbtest + `moon info` 刷新 mbti + `moon fmt --check` |
| 历法/干支/文化枚举 | 对应 `*_wbtest` + `xref_*` 差分对拍 |
| 天文包或节气/朔日路径 | astronomy wbtest + `solar_time_wbtest` + `solar_term_wbtest` + `api_test/test_true_solar_time` |
| God/Taboo 或其索引 | `xref_gt` 差分对拍 + `god/taboo_query_index_wbtest` + bench 前后对比 |
| 农历/藏历闰法 | 对应 index/bench wbtest |
| 八字/童限 provider | `eight_char_wbtest`、`child_limit_wbtest`、`xref_07`、`api_test/test_true_solar_time` |
| facade/reexports | `api_test` 全量（黑盒即护栏） |

## 已知验证缺口

1. **差分 harness 不在仓库**：xref 对拍依赖本地 `tyme4go/` 源码 + 手工流程，外部贡献者无法复现（流程记录在 docs/superpowers/plans/）。
2. **bench 基线无持久化**：仓库无历史基线，CI 不跑 bench，性能回归无自动护栏。
3. **CI 单 target**：wasm/js/native 四目标靠本地 `--target all` 手工验证。
4. **api_test 多数是可达性测试**：数值正确性主要靠白盒 + 差分。
5. **ShenSha V2 无对拍**：上游无此能力，唯一护栏是 55 条黑盒断言。
