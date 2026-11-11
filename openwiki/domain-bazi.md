# 八字与命理

八字体系围绕 `LunarHour` 展开：从公历时刻得到时辰，再由（可替换的）provider 排出四柱；童限、大运、流年都从八字继续推。本页另覆盖十神、十二长生、藏干等命理要素。

## EightChar 与三柱

- `EightChar`（[eight_char.mbt](../tyme/core/eight_char.mbt)）= `ThreePillars`（年/月/日柱，[three_pillars.mbt](../tyme/core/three_pillars.mbt)）+ 时柱 `SixtyCycle`。
- 派生信息：胎元 `get_fetal_origin`、胎息 `get_fetal_breath`、命宫 `get_own_sign`、身宫 `get_body_sign`。
- `EightChar::get_solar_times(start_year, end_year)` 反查：给定八字反推对应公历时刻，年柱循环以"公元 1 年立春为辛酉（index 57）"校准，含晚子时双时刻与 `d == 30` 减 1 小时特例（eight_char.mbt:138-281）。`ThreePillars` 也有各自的 `get_solar_days` 反查。

## 流派 provider（八字）

trait `IEightCharProvider { get_eight_char(LunarHour) -> EightChar }`（[i_eight_char_provider.mbt](../tyme/core/i_eight_char_provider.mbt)），全局单点 `eight_char_provider : Ref[&IEightCharProvider]`，经 `LunarHour::set_provider` 切换：

| 实现 | 文件 | 语义 |
|------|------|------|
| `DefaultEightCharProvider`（默认） | [default_eight_char_provider.mbt](../tyme/core/default_eight_char_provider.mbt) | 晚子时日柱算**次日** |
| `LunarSect2EightCharProvider` | [lunar_sect2_eight_char_provider.mbt](../tyme/core/lunar_sect2_eight_char_provider.mbt) | 晚子时日柱算**当天** |

## 童限 ChildLimit（含真太阳时双轨）

`ChildLimit`（[child_limit.mbt](../tyme/core/child_limit.mbt)）按"阳男阴女顺、阴男阳女逆"定位出生后的节令，折算起运时间。实现抽象为 trait `IChildLimitProvider`，全局 `child_limit_provider` 可切换，共四个流派：

| 实现 | 折算口径 |
|------|----------|
| `DefaultChildLimitProvider` | 秒数换算：3 天 = 1 年、1 天 = 4 月、1 时辰 = 5 天、1 分 = 2 时辰 |
| `LunarSect1ChildLimitProvider` | 按时辰数 |
| `LunarSect2ChildLimitProvider` | 按分钟数 |
| `China95ChildLimitProvider` | 元亨利贞网站口径 |

公共折算逻辑在 `AbstractChildLimitProvider`（[abstract_child_limit_provider.mbt](../tyme/core/abstract_child_limit_provider.mbt)），把年月日时分增量折算成起运 `SolarTime`。

**真太阳时双轨**（child_limit.mbt:44-56）：`ChildLimit::from_true_solar_time(钟表时, 性别, 经度)` 只把**四柱**换成真太阳时读数（先 `to_true_solar_time` 再取八字），而**起运时间差仍按钟表绝对时刻**传原始 `birth_time`——避免真太阳时读数与钟表系节气混用造成扭曲（西部经度差可达 2 小时以上）。黑盒护栏见 `api_test/test_true_solar_time.mbt`（两种轨的干支/起运计数一致）。

## 大运与流年

- `DecadeFortune`（大运，[decade_fortune.mbt](../tyme/core/decade_fortune.mbt)）：`{ child_limit, index }`，干支 = 月柱 `next(±(index+1))`，正负号由童限顺逆方向决定；起止年龄以 `SixtyCycleYear` 计。
- `Fortune`（流年/小运，[fortune.mbt](../tyme/core/fortune.mbt)）：干支 = 时柱 `next(±age)`。
- 两者都经 `ChildLimit` 提供；LunarYear 系的旧方法已注释级 Deprecated，新代码应使用 `SixtyCycleYear`。

## 命理要素

- **十神** `TenStar`（[ten_star.mbt](../tyme/core/ten_star.mbt)）：日干对余干的生克关系。
- **十二长生** `Terrain`（[terrain.mbt](../tyme/core/terrain.mbt)）：长生、沐浴……墓、胎、养。
- **藏干** `HideHeavenStem / HideHeavenStemDay / HideHeavenStemType`（[hide_heaven_stem.mbt](../tyme/core/hide_heaven_stem.mbt) 系）：地支藏干三档（本气/中气/余气）。
- **真黄经人元司令分野** `EclipticHideHeavenStemDay`（[hide_heaven_stem_ecliptic.mbt](../tyme/core/hide_heaven_stem_ecliptic.mbt)）：本项目超出上游的扩展，用天文包 `sa_lon + dt_t` 按太阳真黄经划分司令分野，自述适用约 1000–3000 年（极端年份黄经误差 0.03°–0.05°）。黑盒测试 `api_test/test_hide_heaven_stem_ecliptic.mbt` 用节气边界 ±2h 锚点断言——平黄经节气与真黄经存在约 1 分钟系统错位，属设计公差而非缺陷，勿"修复"。

## 修改提示

- 排盘与童限的数值黄金值来自 Go 版实跑输出（`eight_char_wbtest`、`child_limit_wbtest`、`xref_07_child_limit`）；改 provider 前先确认改的是"口径差异"还是"实现错误"。
- `get_solar_times` 反查逻辑复杂且含特例，改动须全量跑 `eight_char_wbtest`。
- 神煞不在本页——`ShenSha::get_from_eight_char` 虽以八字为输入，但归入独立体系，见 [domain-shensha.md](domain-shensha.md)。
