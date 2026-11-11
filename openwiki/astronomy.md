# 天文算法

`tyme/astronomy` 是无领域类型依赖的纯算法包（仅 import `moonbitlang/core/math`），来源有二：节气/朔日算法引自许剑伟寿星天文历（sxwnl，经 tyme4go 移植），真太阳时公式引自 starainrt/astro（见 README 致谢）。core 侧通过 [imports.mbt](../tyme/core/imports.mbt) 的 `pub using @astronomy` 全量转引。

## 数据表与关键函数

数据表（[astronomy_constants.mbt](../tyme/astronomy/astronomy_constants.mbt)，均为 `pub let`）：`nut_b`（黄经章动周期项）、`dt_at`（ΔT 分段三次拟合，−4000~2050 年）、`xl0`/`xl1`（地球/月亮黄经精简周期项）、`qi_kb`/`shuo_kb`（古代节气/朔日历表）、`qb`/`sb`（压缩的逐日修正串，由 [astronomy_decode.mbt](../tyme/astronomy/astronomy_decode.mbt) 的字母映射展开——**展开顺序敏感**，改动映射表有二次展开风险）。

| 函数 | 位置 | 作用 |
|------|------|------|
| `sa_lon(t, n)` | astronomy_algorithm.mbt:145 | 太阳视黄经（地球黄经 + 章动 + 光行差；n 控制精度档，−1 全项；**返回累积黄经可大于 2π，调用方自行归一化**） |
| `sa_lon_t(w)` / `msa_lon_t(w)` | 同上:210/224 | 黄经（差）反算时刻（牛顿迭代）——节气/朔日/月相共用 |
| `dt_t(t)` | 同上:185 | ΔT（TT−UT1），远期按抛物线外推 |
| `calc_qi(jd)` / `calc_shuo(jd)` | 同上:423/428 | 节气/朔日儒略日（三档混合，见下） |
| `qi_accurate2(jd)` | 同上:439 | 按给定 JD 定位相邻节气的精确时刻 |
| `mean/nutation/true_obliquity` | true_solar_time.mbt:9/21/36 | 平黄赤交角（IAU 1980）/章动/真交角 |
| `lo_to_ra` / `sun_apparent_ra` | 同上:47/65 | 黄经→赤经变换 / 太阳视赤经 |
| `equation_of_time(t)` | 同上:78 | 均时差（小时） |
| `solar_declination(t)` | solar_position.mbt:8 | 太阳视赤纬 |

## 节气/朔日的三档混合策略

`calc()`（astronomy_algorithm.mbt:376）按输入儒略日分档：

1. **高精度**（现代日期，JD ≥ 2436935 ≈ 1960-01-01）：快速初值 + 牛顿迭代全项精化，边界 1200 秒内防日期翻转；
2. **历表插值**（约 −722 至 1600 年）：`qi_kb`/`shuo_kb` 线性插值；
3. **低精度多项式 + 修正串**：`qb`/`sb` 展开的逐日 ±1 天修正。

core 侧两级使用：`SolarTerm` 粗略日期由 `calc_qi` 推（solar_term.mbt:46-53），精确到秒的时刻由 `qi_accurate2` 修（solar_term.mbt:94）；`LunarMonth` 用 `calc_shuo` 定朔（[domain-calendars.md](domain-calendars.md)）。

## 真太阳时链路

全部在 [solar_time.mbt](../tyme/core/solar_time.mbt)：

1. `td_centuries_at`（:200）：北京时间儒略日 − 8h（`OneThird`）→ UT → + `dt_t` → TD → /36525 → J2000 起 TD 世纪数；
2. `equation_of_time`（true_solar_time.mbt:78）：低精度太阳几何黄经 − 固定光行差 − 高精度太阳视赤经 + 交角章动修正。**精度混用**（低精度黄经配高精度赤经）是 astro 上游公式的固有设计，分钟级精度；
3. `SolarTime::to_true_solar_time`（:219）：钟表时间 + `(经度−120°)×240s` + EoT，取整到秒。

`get_solar_noon`（:237）是逆运算；`get_sunrise/get_sunset`（:288/:304）用统一时角公式 `cos H = (cos 90.833° − sinφ·sinδ)/(cosφ·cosδ)`（含蒙气差+视半径 0.833° 修正），δ 取当日 12:00 赤纬，精度约 ±1 分钟。

## core 引用点

改 astronomy 包任何函数前，先看清下游：`solar_term.mbt`（节气）、`lunar_month.mbt`（朔日）、`phase.mbt`（月相）、`phenology.mbt`（七十二候）、`solar_time.mbt`（ΔT/EoT/赤纬）、`hide_heaven_stem_ecliptic.mbt`（真黄经司令分野）、`child_limit.mbt`（经 `to_true_solar_time`）。这些全部通过 `imports.mbt` 转引，astronomy 包自身不知道任何领域类型。

## 边界与已知坑

- **年份范围**：高精度分支仅覆盖 ≥ 约 1960 年；ΔT 表到 2050，之后抛物线外推精度下降；司令分野自述适用 1000–3000 年。
- **时区硬编码 UTC+8**：`OneThird`（8h）与 `(经度−120°)×240s` 都假设输入为北京时间钟表时；其他时区会算错（api_test 的西经用例仅验证"不崩溃"）。
- **极昼/极夜不区分**：`get_sunrise/get_sunset` 在 `cos H` 超出 [−1,1] 时统一返回 `None`；可用 `get_solar_noon` 时刻太阳高度区分。回归测试覆盖极圈临界纬度（65.5°–67.5°N）与"昼长 <15 分钟"的连续过渡（solar_time_wbtest.mbt）。
- **二分点无特判**：赤纬符号自动决定昼夜长短方向；赤道二分日视昼长略大于 12h 恰证明 0.833° 修正生效，这是被测试锁定的行为，勿当 bug 修。
- **魔法数无注释**：`2436935.0`（分档边界）与 `1683460.0`（朔日特判）在 `calc()` 内。
- `pub let` 全局数据表理论上可被外部改写（只读约定靠自觉）。

## 历史遗留：Location 功能

根目录的《全国县级以上地名代码及经纬度.csv》（3521 条，untracked）与 [docs/reviews/location-feature.md](../docs/reviews/location-feature.md)、[location-code-review.md](../docs/reviews/location-code-review.md) 是一次**未合入源码**的经纬度查询功能评审记录（当时评审提出 Blocker：错误消息中文不一致、259KB 数据串误暴露为 pub 等）。当前 `tyme/` 下没有任何 location 源码；如重启该功能，先读这两份评审。

## 测试锚点

天文包白盒：`true_solar_time_wbtest.mbt`（11 个 test：J2000 交角精确值、章动 ±15″、视赤经值域、EoT ±0.3h 等）、`solar_position_wbtest.mbt`（2025 二分二至赤纬）。core 回归：`solar_time_wbtest.mbt`（真太阳时四城、EoT 极值、solar_noon↔to_true_solar_time 严格互逆 roundtrip、日出日落分钟级、极昼极夜、半球趋势、12 月 × 7 纬度 × 3 经度不变量扫描）、`solar_term_wbtest.mbt`（2023 冬至）。黑盒：`api_test/test_true_solar_time.mbt`。全清单与运行方式见 [testing.md](testing.md)。
