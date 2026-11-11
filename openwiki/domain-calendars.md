# 历法体系

`SolarDay` 只包一个 `DayUnit`（[solar_day.mbt](../tyme/core/solar_day.mbt)），是整个历法家族的交换中心；跨历法换算全部是对象方法直连，统一以 `JulianDay` 为中介。本页覆盖公历、农历、干支、藏历、回历、儒略日六个家族及节日/假日/事件三个"日历标注"子系统。

## 公历（solar_*.mbt）

`SolarYear / SolarHalfYear / SolarSeason / SolarMonth / SolarWeek / SolarDay / SolarTime / SolarFestival`，另有 `SolarTerm / SolarTermDay`（节气，见 [astronomy.md](astronomy.md)）与两个跨域拆分文件 `solar_day_cross.mbt`、`solar_time_cross.mbt`（人元司令分野等，见 [domain-bazi.md](domain-bazi.md)）。

- 构造校验 `SolarDay::validate` 特判 1582 年 10 月儒略历→格里高利历切换的空缺日期（solar_day.mbt:39）。
- `JulianDay::from_ymdhms` 以 `y*372+m*31+d >= 588829`（即 1582-10-15）为界切换儒略/格里修正（[julian_day.mbt](../tyme/core/julian_day.mbt)）。

## 农历（lunar_*.mbt）

`LunarYear / LunarMonth / LunarDay / LunarHour / LunarWeek / LunarSeason / LunarFestival`。

- **闰月约定为负月号**：`LunarMonth::from_ym(y, -m)` 表示闰 m 月，`leap : Bool` 字段与月号正负互为表里（[lunar_month.mbt](../tyme/core/lunar_month.mbt)）。
- **月长不查表，而是天文计算**：`get_new_moon` 用冬至定位 + astronomy 包 `calc_shuo` 迭代出首朔儒略日，`get_day_count` 为相邻两朔之差（lunar_month.mbt:75-97）。改这条路径务必跑 [astronomy.md](astronomy.md) 列出的回归测试。
- 日干支由初一儒略日偏移推导：`get_first_julian_day().next(day - 12).get_day()`（lunar_day.mbt:105）。
- **闰月 O(1) 索引**：源数据是 10 段 64 进制字符串 `lunar_year_leap_data`（每 2 字符累加得闰月出现的年份），模块初始化时一次性解码为 10001 长度数组 `lunar_year_leap_index`（下标 = year+1），`get_leap_month` 由逐段扫描降为 O(1)（[lunar_year.mbt](../tyme/core/lunar_year.mbt):26-131）。基准见 `lunar_year_bench_wbtest.mbt`。

## 干支（sixty_cycle*.mbt）

`SixtyCycle` 为 0–59 环形索引（[sixty_cycle.mbt](../tyme/core/sixty_cycle.mbt)）：`get_heaven_stem = index%10`、`get_earth_branch = index%12`、`get_sound`（纳音）= `index/2`、`get_ten`（旬）与 `get_extra_earth_branches`（旬空）。日/月/年/时分别有 `SixtyCycleDay / Month / Year / Hour` 包装；月柱由节气定界（`SixtyCycleDay::from_solar_day` 走节气象限）。

干支要素类型：`HeavenStem`（喜神/财神/阳贵/阴贵方位、十神、十二长生，[heaven_stem.mbt](../tyme/core/heaven_stem.mbt)）、`EarthBranch`（合冲刑害破、三合三会、藏干、生肖，[earth_branch.mbt](../tyme/core/earth_branch.mbt)）、`HideHeavenStem*`（藏干三档）。命理侧的十神/长生/司令分野见 [domain-bazi.md](domain-bazi.md)。

## 藏历 RabByung（rab_byung_*.mbt）

时轮历/饶迥纪年（`第十七饶迥火虎年…`），数据引自 stonelf/zangli。**仅支持 1950–2050**（[rab_byung_month.mbt](../tyme/core/rab_byung_month.mbt)），闰日/缺日/特殊日编码在硬编码串 `rab_byung_month_data`（段首计数 + 字符码偏移解码）。闰月查询同样做了索引优化（`b32738b`），基准见 `rab_byung_leap_bench_wbtest.mbt`。

## 回历 Hijri（hijri_*.mbt）

纯表格历：30 年闰周，闰年第 2,5,7,10,13,16,18,21,24,26,29 位（[hijri_year.mbt](../tyme/core/hijri_year.mbt)），与儒略日互转完成换算。

## 换算主干

| 方向 | 方法 |
|------|------|
| 公 → 农 | `SolarDay::get_lunar_day` / `LunarDay::get_solar_day`（经农历月初一儒略日） |
| 公 → 藏 / 回 | `SolarDay::get_rab_byung_day`、`SolarDay::get_hijri_day` 及各自 `get_solar_day` |
| 公 → 干支 | `SolarDay::get_sixty_cycle_day`；`SolarTime::get_lunar_hour` → `get_eight_char` |
| 日推移 | 任意类型的 `next(n)`；`SolarDay::next` 实现为 `get_julian_day().next(n).get_solar_day_unchecked()`（solar_day.mbt:184）——儒略日是日期推移的"中介货币" |

## 节日、法定假日与事件

三者都是"在日历上标注日期"的子系统，数据均可整体热替换（经 [architecture.md](architecture.md) 所列全局 Ref 单点）：

- **节日** `SolarFestival / LunarFestival`（[solar_festival.mbt](../tyme/core/solar_festival.mbt) / [lunar_festival.mbt](../tyme/core/lunar_festival.mbt)）：定宽编码串存于 Ref，支持 `append/remove`。
- **法定假日** `LegalHoliday`（[legal_holiday.mbt](../tyme/core/legal_holiday.mbt)）：硬编码 13 字符定宽记录串（YYYYMMDD + 上班/放假标记 + 名称索引 + 调休关联号），覆盖 2001 年至今含调休；`from_ymd` 定宽步进扫描，非假日返回 `Err`，调用方按 `Option` 处理。
- **事件系统** `Event / EventType / EventBuilder / EventManager`（[event.mbt](../tyme/core/event.mbt) / [event_type.mbt](../tyme/core/event_type.mbt) / [event_manager.mbt](../tyme/core/event_manager.mbt)）：`Event.data` 为固定 9 字符编码（`@` + 类型码 + 参数位，63 字符字母表），`EventType` 共 6 种（公历日/公历周/农历日/节气日/节气天干日/节气地支日，支持月末顺延等偏移）。`EventManager::update/update_data/remove/set_data` 原子改表，`Event::from_solar_day(year)` 反查当日全部事件。注意事件名/键经 UTF-8 `Map` 存取，而 data 编码限 ASCII 字母表。

> 已知热点：`Event::from_solar_day` 是全事件表线性扫描（event.mbt:292-303），事件量大时是剩余的性能热点，尚无索引优化。

## 修改提示

- 农历/藏历/回历的月长与闰法各有独立数据路径，改任何一处都要跑对应 `*_wbtest`（藏历限 1950–2050，测试年份也别越界）。
- 干支相关改动的黄金护栏是与 tyme4go 的差分对拍测试 `xref_02_ganzhi` / `xref_03_lunar`，见 [testing.md](testing.md)。
