# 文化杂项类型

除历法与命理外，`tyme/core` 还包含大量"从某个历法对象查出文化含义"的小类型。它们几乎全是 [architecture.md](architecture.md) 所述 LoopTyme 组合模式的实例：内嵌环形名称索引 + `next` 推进，部分带"第 N 天"状态（内嵌 `AbstractCultureDay`）。本页是导航地图，各类型语义细节直接看源文件头注释与对应 wbtest。

## 分组总览

| 分组 | 类型 | 源文件 | 入口（挂接点） |
|------|------|--------|----------------|
| 方位与五行 | `Element`、`Direction`、`Land`（二十四方） | element.mbt、direction.mbt、land.mbt | 天干/地支 `get_element` 等 |
| 天干方位 | 喜神/财神/阳贵/阴贵方位 | heaven_stem.mbt | `HeavenStem::get_joy_direction` 等 |
| 建除十二值神 | `Duty` | duty.mbt | `SixtyCycleDay::get_duty` |
| 黄道黑道 | `TwelveStar`、`Ecliptic` | twelve_star.mbt、ecliptic.mbt | `SixtyCycleDay::get_twelve_star` |
| 九星 | `NineStar`（含色/北斗/方位） | nine_star.mbt | 农历年/月/日 `get_nine_star` |
| 北斗与七曜 | `Dipper`、`SevenStar` | dipper.mbt、seven_star.mbt | 农历日/月 |
| 二十八宿 | `TwentyEightStar`、四象 `Zone`、七兽 `Beast`、禽 `Animal` | twenty_eight_star.mbt、zone.mbt、beast.mbt、animal.mbt | `SixtyCycleDay::get_twenty_eight_star` |
| 星座 | `Constellation`（黄道十二宫） | constellation.mbt | `SolarDay::get_constellation` |
| 七十二候 | `Phenology`、`ThreePhenology`、`PhenologyDay` | phenology.mbt、three_phenology.mbt | `SolarTerm`（时刻用天文 `sa_lon_t`） |
| 数九 | `Nine`（base）、`NineDay` | base/nine.mbt、nine_day.mbt | `SolarDay::get_nine_day`（solar_day.mbt:239 挂接） |
| 三伏 | `Dog`、`DogDay` | dog.mbt、dog_day.mbt | `SolarDay::get_dog_day` |
| 梅雨 | `PlumRain`、`PlumRainDay` | plum_rain.mbt、plum_rain_day.mbt | `SolarDay` |
| 月相 | `Phase`、`PhaseDay` | phase.mbt | `LunarDay::get_phase`（朔弦望时刻用天文 `msa_lon_t`） |
| 胎神 | `FetusDay/Month/HeavenStem/EarthBranch` | fetus_*.mbt | 农历日/月、干支 |
| 彭祖百忌 | `PengZu`、`PengZuHeavenStem`、`PengZuEarthBranch` | peng_zu*.mbt | 天干/地支 |
| 六曜 | `SixStar`（大安/赤口…） | base/six_star.mbt | `LunarDay::get_six_star`（lunar_day.mbt:134） |
| 小六壬 | `MinorRen`（月/日/时三链条） | minor_ren.mbt | `LunarHour` |
| 灶马头 | `KitchenGodSteed`（几牛耕田/几龙治水/花甲占等） | kitchen_god_steed.mbt | 农历年首日干支 |

## 模式说明

- **"第 N 天"类型**（`DogDay`、`NineDay`、`PhenologyDay`、`PhaseDay`、`PlumRainDay`、`SolarTermDay`、`HideHeavenStemDay`）：`{ culture, day_index }` 二元结构，`to_string` 输出"XX第N天"；`next(n)` 跨越边界时会自动翻到下一个周期对象。
- **名称表顺序即契约**：每个 LoopTyme 的 `names` 数组顺序决定 index 语义与 `index_of_name` 查找结果，且直接暴露在 `to_string` 输出中。改名称、改顺序都属于破坏性变更，须同步核对所有 wbtest 的黄金值。
- 多数类型是纯查表 + 环形推进，实现与验证成本低；例外是 `Phenology` / `Phase` 依赖天文时刻（见 [astronomy.md](astronomy.md)），`KitchenGodSteed` 依赖农历年首日干支推导。

## 修改提示

- 新增此类文化类型时的固定套路：LoopTyme 内嵌 + `pub impl Culture/Tyme` + 显式 `pub extend`（见 `AGENTS.md`）、加入 `reexports.mbt` 清单、`moon info`、补 wbtest 与黑盒可达性测试。
- 差分护栏：`xref_10_foundations` 复刻了 Go 版 `xref_all_test.go` 全部 19 组枚举循环（含本组多数类型），`xref_06_solar_culture` / `xref_01_downstream` 覆盖公历周与农历周下游——见 [testing.md](testing.md)。
