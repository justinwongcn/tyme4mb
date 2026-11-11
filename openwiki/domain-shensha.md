# 神煞与宜忌

库内存在**两套互相独立的**吉凶体系，输入与用途不同，不要混同：

| | 八字神煞 `ShenSha`（V2） | 日神煞 `God` + 宜忌 `Taboo` |
|---|---|---|
| 输入 | `EightChar` + `Gender` | `SixtyCycleMonth` + `SixtyCycleDay`（或农历日） |
| 规模 | 55 条 | 神 151 条（前 60 吉、后 91 凶），宜忌 140 项 |
| 数据 | `shensha.json`（仅作注释出处） | 硬编码 hex 位图（与 tyme4go 逐字节一致） |
| 上游对应 | 无（本项目扩展，无 Go 对拍） | 有（`xref_gt` 差分护栏） |

## 八字神煞 V2（shensha*.mbt）

聚合入口 `ShenSha::get_from_eight_char(EightChar, Gender)`（[shensha.mbt](../tyme/core/shensha.mbt)），按五类求法分派到五个文件；名称表顺序对应 `shensha.json` 的 id：

| 文件 | 求法 | 代表神煞 |
|------|------|----------|
| [shensha_stem.mbt](../tyme/core/shensha_stem.mbt) | 以日/年干查地支（查表） | 天乙贵人、禄神、文昌等 14 条 |
| [shensha_branch.mbt](../tyme/core/shensha_branch.mbt) | 以年/日支查余三支（基于三合局长生/中神/墓库的 `san_he_pos`） | 驿马、将星、华盖、灾煞等 |
| [shensha_month.mbt](../tyme/core/shensha_month.mbt) | 以月支查 | 天德、月德及其合神 |
| [shensha_pillar.mbt](../tyme/core/shensha_pillar.mbt) | 日柱/时柱固定干支列表 | 阴差阳错、魁罡、十恶大败 |
| [shensha_special.mbt](../tyme/core/shensha_special.mbt) | 特殊规则 | 三奇贵人（四干紧连顺布）、空亡（按旬空）、天罗地网（按纳音） |

数据来源：根目录 [shensha.json](../shensha.json)（问真八字 55 条"古诀/查法"，含出处 URL）**不参与构建**，只作为规则的人工翻译出处被源码注释引用；所有判定逻辑是手工翻译的判定函数。已知一处**有意纠错**：`shensha_stem.mbt:92` 注明 json 原文误与"学堂"相同，实现按标准临官位——遇到 diff 请对照该注释。黑盒测试 [api_test/test_shensha.mbt](../api_test/test_shensha.mbt) 基于 shensha.json 的 55 条求法有实质断言。

## 日神煞与宜忌（god.mbt / taboo.mbt）

- `God`（[god.mbt](../tyme/core/god.mbt)）：`god_names()` 151 项，`get_luck` 按 `index < 60` 分吉凶（god.mbt:127-134）；`Taboo`（[taboo.mbt](../tyme/core/taboo.mbt)）：`taboo_names()` 140 项。
- 查询入口：`LunarDay::get_gods / get_day_recommends / get_day_avoids` 及 `SixtyCycleDay` 同名方法（另有时辰级 `get_hour_recommends/avoids`），全部委托到 `God::get_day_gods` / `Taboo::get_day_recommends` 等。
- **签名已收窄**为 `(SixtyCycleMonth, SixtyCycleDay)`（见 ROADMAP 第六节）：想查询任意干支组合必须用 `SixtyCycleMonth::new / SixtyCycleDay::new` 强行构造——差分测试 `xref_gt_wbtest.mbt` 正是这样做全覆盖的。

### 查询索引优化

原始数据是 12（月支）× 60（日干支）的 hex 位图串（god 另有 12×60 时辰表）。模块加载时一次性预解析为二维数组：`build_god_query_index`（god.mbt:45-97）与 `build_taboo_query_index`（taboo.mbt:123-149，值是 `(宜,忌)` 的 `Result` 对），查询按二维下标 O(1) 取 id 列表再映射成对象。三条不变式：

1. 解析错误保留为 `Err`，延迟到查询时返回（不在加载期 panic）；
2. 每次查询返回新建数组，避免共享可变状态；
3. 有专门测试 `god_query_index_wbtest.mbt`、`taboo_query_index_wbtest.mbt` 与基准 `god_taboo_bench_wbtest.mbt`。

## 修改提示

- God/Taboo 的任何改动都必须跑 [testing.md](testing.md) 所述的 `xref_gt` 差分对拍（与本地 tyme4go 输出逐行比对，覆盖全部 60×60 组合与 `next(±37)` 推移）。
- ShenSha V2 无上游对拍，改动唯一护栏是 `api_test/test_shensha.mbt` 的 55 条断言；新增神煞时按五类求法归入对应文件，并在 shensha.mbt 的名称表**末尾**追加（顺序即 id 契约）。
