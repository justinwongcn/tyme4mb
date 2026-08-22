# tyme4mb 未来拆包路线图

> 状态：2026-08-16 制定（基于 Step 1-3 完成后的实测依赖图谱）
> 目标：在**接口零破坏**（`@tyme` 209 符号不变、api.md/go.md/java.md/ts.md 零改动）的前提下，把 `tyme/core` 单包按领域拆分为多个包。

## 一、现状与已完成的铺垫

```
tyme/
├── astronomy/   # ✅ 已独立（纯天文算法，零领域依赖）
├── base/        # ✅ 已独立（trait + LoopTyme + 单位 + 纯枚举，19 文件）
├── core/        # ⬅️ 剩余 143 文件，~1298 pub API 单包
├── reexports.mbt # facade（@tyme 209 符号）
```

已完成的铺垫（均为接口零破坏）：
- `shou_xing_util.mbt`（1131 行）拆为 3 文件
- `tyme/base` 抽取（19 个零依赖原子类型）
- `god/taboo` 的 `get_day_*` 签名收窄为 `SixtyCycleMonth`/`SixtyCycleDay`
- `.gitattributes` LF 规范化

## 二、核心障碍：hub 类型（依赖中枢）

实测引用数（去 wbtest，按文件数）：

| 类型 | 被引用文件数 | 角色 |
|---|---|---|
| `SixtyCycle` | 18 | 干支中枢 |
| `SolarTime` | 17 | 时间中枢 |
| `SolarTerm` | 17 | 节气中枢 |
| `SolarDay` | 17 | 公历中枢 |
| `Direction` | 14 | 方位（与 Element 互依） |
| `LunarDay` | 13 | 农历中枢 |
| `NineStar` | 10 | 九星 |

**结论**：`SolarDay`/`LunarDay`/`SixtyCycle`/`SolarTime` 是 cross-domain 中枢——它们的 30-40 个方法几乎每个都依赖其他领域（`SolarDay::get_lunar_day`、`get_phase`、`get_nine_star`、`get_rab_byung_day`...）。**强行拆包必然成环**。

## 三、依赖方向图（实测）

```
base（零依赖） ← element ↔ direction（互依环）
                   ↑
solar 域：solar_* + julian_day + ecliptic + phenology + plum_rain
  ↑ 依赖：base + astronomy + Week + Phase + LunarDay(反)
lunar 域：lunar_* + fetus_* + hijri_* + rab_byung_*
  ↑ 依赖：solar + SixtyCycle + base
ganzhi 域：sixty_cycle_* + heaven_stem + earth_branch + hide_heaven_stem_*
  ↑ 依赖：base
bazi 域：eight_char + three_pillars + child_limit + fortune + decade_fortune
  ↑ 依赖：lunar + solar + ganzhi
culture 域：god + taboo + event + legal_holiday + kitchen_god_steed + zodiac + constellation
  ↑ 依赖：lunar + ganzhi + solar
```

关键环：
1. **`Week ↔ SevenStar`** 双向（week.mbt 引 SevenStar，seven_star.mbt 引 Week）
2. **`Element ↔ Direction`** 双向（element.mbt 引 Direction，direction.mbt 引 Element）
3. **`SolarDay → Phase → SolarTime → SolarDay`** 三角（solar_day 引 Phase，phase 引 SolarTime，solar_time 引 SolarDay）

## 四、推荐路线：叶子优先，hub 留 core

### 阶段 0（已完成）：astronomy + base

### 阶段 1：抽"真叶子"——零反向依赖的领域
**可行性：高**（这些类型几乎不被 core 其他文件引用，或只被同类引用）

| 候选包 | 文件 | 反向依赖 |
|---|---|---|
| `tyme/ganzhi` | `sixty_cycle*.mbt`/`heaven_stem`/`earth_branch`/`hide_heaven_stem*`/`ten_star` | 需先解 god/taboo（已做 ✅）|
| `tyme/zodiac` | `zodiac.mbt`/`animal`/`beast`/`land`/`terrain`/`direction`/`element` | 需先解 element↔direction 环 |

**前置动作**：
- `element ↔ direction` 环：把 `Element::get_direction` 和 `Direction::get_element` 改成"内部用数组索引"（不互相调用），或把两者同时移入同一包
- god/taboo 的 `get_hour_*` 若需收窄（当前方案 X 保持宽），ganzhi 拆包后需再评估

### 阶段 2：抽 solar 域的"非中枢叶子"
**可行性：中**（solar_term/solar_year 等依赖 solar 中枢，但可随中枢一起）

| 候选包 | 文件 | 依赖 |
|---|---|---|
| `tyme/solar`（部分） | `solar_term*`/`solar_year`/`solar_half_year`/`solar_season`/`ecliptic`/`phenology*`/`plum_rain*` | base + astronomy（已满足）|

**前置动作**：`SolarDay`/`SolarTime` 的 cross-domain 方法（`get_phase`/`get_lunar_day`/`get_week`/`get_nine_star`/`get_rab_byung_day`/`get_hijri_day`/`get_legal_holiday`/`get_festival`/`get_constellation`/`get_hide_heaven_stem_day`/`get_sixty_cycle_day`...）**拆到独立文件**（如 `solar_day_cross.mbt` 留 core），纯公历方法随 `SolarDay` 抽走。

### 阶段 3：抽 lunar 域
**可行性：中**（依赖 solar + ganzhi + base，方向单向）

| 候选包 | 文件 | 依赖 |
|---|---|---|
| `tyme/lunar` | `lunar_*.mbt`/`fetus_*.mbt`/`hijri_*.mbt`/`rab_byung_*.mbt` | solar + ganzhi + base |

**前置动作**：`LunarDay` 的 cross-domain 方法（`get_sixty_cycle_*`/`get_eight_char`/`get_gods`/`get_recommends`/`get_avoids`...）同样拆出。

### 阶段 4：抽 bazi + culture 域
**可行性：低-中**（依赖 lunar/solar/ganzhi，且 culture 的 god/taboo 又依赖 lunar）

| 候选包 | 文件 | 依赖 |
|---|---|---|
| `tyme/bazi` | `eight_char`/`three_pillars`/`child_limit*`/`fortune`/`decade_fortune`/`*_provider` | lunar + solar + ganzhi |
| `tyme/culture` | `god`/`taboo`/`event*`/`legal_holiday`/`kitchen_god_steed`/`zodiac`/`constellation` | ganzhi + lunar + solar |

## 五、每个阶段的标准动作（与已完成的一致）

1. **移文件**（`git mv` 保留历史）
2. **依赖方加 `@子包.` 前缀**（核心成本：core 内部 ~1000+ 处引用）
3. **core `imports.mbt` 加 `pub using @子包`**（保持 core 对外接口）
4. **护栏**：`moon check --target all` 0 error + `moon test` 275 全过 + facade 209 符号集合不变
5. **提交**（每阶段独立 commit）

## 六、关键风险与教训（来自本次实践）

1. **`pub using` 不透传**：类型必须 `{ type X }` 形式；impl 方法不透传，需 `pub(open)` trait 或 `@pkg.` 前缀
2. **枚举变体跨包不可裸用**：`@base.Yang` 显式前缀（本次踩过）
3. **测试的可构造性**：签名收窄会破坏"全组合遍历"测试（xref_gt 60×60 丢失），需用 `X::new` 构造任意组合恢复
4. **hub 类型是拆包的天花板**：`SolarDay`/`LunarDay` 的 cross-domain 方法必须先拆文件，否则成环
5. **mbti 归属标注必然变化**：`DayUnit` → `@base.DayUnit` 是物理移动的必然结果，接口符号集合不变即可

## 七、建议的执行顺序（务实版）

```
Phase 1a: 解 element↔direction 环（内部数组索引化，1 个 commit）
Phase 1b: 抽 tyme/ganzhi（最干净，god/taboo 已解耦）
Phase 2: 抽 tyme/zodiac（element/direction/animal/beast/land/terrain）
Phase 3: SolarDay/SolarTime cross-domain 方法拆文件（solar_day_cross.mbt 留 core）
Phase 4: 抽 tyme/solar（纯公历部分）
Phase 5: 抽 tyme/lunar（同样先拆 cross-domain 方法）
Phase 6: 抽 tyme/bazi + tyme/culture
Phase 7: facade 聚合（reexports.mbt 改 pub using 子包）
```

每阶段独立 commit + 五道护栏。预计总成本：**1-2 天**（主要是 core 内部加前缀的机械工作 + 每阶段编译调试）。

## 八、是否值得？

**收益**：
- core 从 143 文件降到 ~60（只留 hub + cross-domain 桥）
- 领域边界显式化，新人可快速定位
- 未来新增领域（如印度历、佛历）可独立成包

**成本**：
- ~1000+ 处 `@pkg.` 前缀改写（机械但易错）
- 每阶段护栏调试
- cross-domain 方法拆文件本身是重构

**建议**：如果 core 的 143 文件已经"够用"（当前结构清晰、测试全绿），**拆包收益有限**。只有当：
- 需要引入新领域（如印度历）且希望独立测试
- 或 core 文件数持续膨胀到难以维护
- 或需要按领域发布独立包（如"只要农历"的消费者）

时才值得投入。当前状态（astronomy + base 独立）已是性价比最高的平衡点。
