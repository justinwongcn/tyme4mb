---
type: "参考"
title: "集成点"
openwiki_generated: true
---

---
title: 集成点
type: page
description: API 参考、浏览器/服务端集成示例和错误处理指南
---

# 集成点

## API 集成

### 基础类型导出

所有公共类型和方法都通过 `moon.pkg` 导出：

```moonbit
// tyme/moon.pkg
import {
  "moonbitlang/core/math" @math
}
```

### 常用 API 汇总

#### 日期构造

```moonbit
// 公历
SolarDay::from_ymd(year: Int, month: Int, day: Int) -> Result[SolarDay, String]
SolarMonth::from_ym(year: Int, month: Int) -> Result[SolarMonth, String]
SolarYear::from_year(year: Int) -> Result[SolarYear, String]
SolarTime::from_ymdhms(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Result[SolarTime, String]

// 农历
LunarDay::from_ymd(year: Int, month: Int, day: Int) -> Result[LunarDay, String]
LunarMonth::from_ym(year: Int, month: Int) -> Result[LunarMonth, String]
LunarYear::from_year(year: Int) -> Result[LunarYear, String]
LunarHour::from_ymd_time(year: Int, month: Int, day: Int, hour: Int) -> Result[LunarHour, String]

// 回历
HijriDay::from_ymd(year: Int, month: Int, day: Int) -> Result[HijriDay, String]
```

#### 日期转换

```moonbit
// 公历 → 农历
solar_day.get_lunar_day() -> LunarDay

// 公历 → 干支日
solar_day.get_sixty_cycle_day() -> SixtyCycleDay

// 公历 → 节气
solar_day.get_solar_term() -> SolarTerm

// 公历 → 星期
solar_day.get_weekday() -> Int  // 0=周日, 6=周六
```

#### 干支查询

```moonbit
// 天干地支构造
HeavenStem::from_name(name: String) -> Result[HeavenStem, String]
EarthBranch::from_name(name: String) -> Result[EarthBranch, String]
SixtyCycle::from_name(name: String) -> Result[SixtyCycle, String]

// 属性查询
stem.get_element() -> Element      // 五行
stem.get_yin_yang() -> YinYang     // 阴阳
branch.get_zodiac() -> Zodiac      // 生肖
branch.get_element() -> Element    // 五行
cycle.get_sound() -> Sound         // 纳音
cycle.get_ten() -> Ten             // 旬
```

#### 八字查询

```moonbit
// 八字构造（通过 Provider）
eight_char_provider.get_eight_char(lunar_hour: LunarHour) -> EightChar

// 八字信息
eight_char.get_year() -> SixtyCycle     // 年柱
eight_char.get_month() -> SixtyCycle    // 月柱
eight_char.get_day() -> SixtyCycle      // 日柱
eight_char.get_hour() -> SixtyCycle     // 时柱
eight_char.get_fetal_origin() -> SixtyCycle  // 胎元
eight_char.get_life_palace() -> SixtyCycle     // 命宫
```

#### 命理查询

```moonbit
// 童限
child_limit_provider.get_info(solar_time: SolarTime, solar_term: SolarTerm) -> ChildLimitInfo

// 小运
fortune.get_age() -> Int
fortune.get_sixty_cycle_year() -> SixtyCycleYear

// 生肖
year.get_zodiac() -> Zodiac

// 五行生克
element.get_reinforce() -> Element   // 我生者
element.get_restrain() -> Element    // 我克者
element.get_reinforced() -> Element  // 生我者
element.get_restrained() -> Element  // 克我者
```

#### 神煞宜忌

```moonbit
// 神煞
god.get_luck() -> Luck              // 吉凶
lunar_day.get_day_gods() -> Array[God]  // 当日神煞

// 宜忌
lunar_day.get_day_taboo() -> Array[Taboo]  // 当日宜忌
lunar_day.get_hour_taboo(hour: Int) -> Array[Taboo]  // 时辰宜忌
```

## 浏览器集成

### WASM 调用

```javascript
// 加载 WASM 模块
import init from './tyme_wasm.js';

async function initModule() {
  const wasm = await init('./tyme_wasm.wasm');
  
  // 调用函数
  const solarDay = wasm.SolarDay.from_ymd(2026, 8, 3);
  const lunarDay = solarDay.get_lunar_day();
  console.log(lunarDay.to_string());
}
```

### CDN 集成

```html
<script src="https://cdn.example.com/tyme4mb/wasm.js"></script>
<script>
  initTymeModule().then(module => {
    const day = module.SolarDay::from_ymd(2026, 8, 3);
  });
</script>
```

## 服务端集成

### Node.js 集成

```javascript
const tyme = require('tyme4mb');

// 同步调用
const solarDay = tyme.SolarDay.from_ymd(2026, 8, 3);
const lunarDay = solarDay.get_lunar_day();

// 异步批量处理
async function getLunarDate(year, month, day) {
  const result = await tyme.calculateLunarDate(year, month, day);
  return result;
}
```

### Python 集成（通过 WASM）

```python
import asyncio
from wasmtime import Store, Module, Instance

async def get_lunar_date():
    store = Store()
    module = Module(store.engine, open('tyme_wasm.wasm', 'rb').read())
    instance = Instance(store, module, [])
    
    # 调用 WASM 函数
    # ...
```

## 移动端集成

### React Native

```javascript
import { initTymeModule } from 'tyme4mb/rn';

const Tyme = await initTymeModule();

// 使用
const solar = Tyme.SolarDay.from_ymd(2026, 8, 3);
const lunar = solar.get_lunar_day();
```

### Flutter

```dart
import 'package:tyme4mb/tyme4mb.dart';

void main() async {
  await Tyme.init();
  
  final solar = SolarDay.fromYmd(2026, 8, 3);
  final lunar = solar.getLunarDay();
}
```

## 数据库集成

### 批量查询优化

```moonbit
// 预计算某年的所有节气
fn get_all_terms(year: Int) -> Array[SolarTerm] {
  let mut terms = []
  for i = 0; i < 24; i = i + 1 {
    terms.push(SolarTerm::from_index(year, i))
  }
  terms
}
```

### 缓存策略

建议对以下数据进行缓存：
- 节气时刻（变化频率低）
- 农历闰月表（变化频率极低）
- 宜忌神煞表（变化频率极低）

## 第三方系统集成

### 日历应用

```moonbit
// 导出农历节日
fn get_lunar_festivals(year: Int) -> Array[LunarFestival] {
  LunarYear::from_year(year)
    .get_lunar_festivals()
}

// 导出公历节日
fn get_solar_festivals(year: Int) -> Array[SolarFestival] {
  SolarYear::from_year(year)
    .get_solar_festivals()
}
```

### 命理应用

```moonbit
// 八字排盘 API
fn get_bazi(solar_time: SolarTime) -> Result[EightChar, String] {
  let lunar_hour = solar_time.get_lunar_hour()?;
  Ok(eight_char_provider.get_eight_char(lunar_hour))
}

// 童限计算 API
fn get_tongxian(solar_time: SolarTime) -> Result[ChildLimitInfo, String] {
  let next_term = solar_time.get_next_solar_term()?;
  Ok(child_limit_provider.get_info(solar_time, next_term))
}
```

### 黄历应用

```moonbit
// 每日宜忌
fn get_daily_taboo(lunar_day: LunarDay) -> (Array[Taboo], Array[Taboo]) {
  let (good, bad) = lunar_day.get_day_taboo_split();
  (good, bad)
}

// 每日神煞
fn get_daily_gods(lunar_day: LunarDay) -> (Array[God], Array[God]) {
  let (good, bad) = lunar_day.get_day_gods_split();
  (good, bad)
}
```

## 集成示例：完整八字排盘

```moonbit
import tyme.{SolarTime, SolarTerm}

// 完整八字排盘流程
fn calculate_bazi(
  year: Int, month: Int, day: Int,
  hour: Int, minute: Int, second: Int
) -> Result[EightChar, String] {
  // 1. 构造公历时间（含真太阳时）
  let solar_time = SolarTime::from_ymdhms(year, month, day, hour, minute, second)?
  
  // 2. 转换为农历时辰
  let lunar_hour = solar_time.get_lunar_hour()?
  
  // 3. 计算八字
  let eight_char = eight_char_provider.get_eight_char(lunar_hour)
  
  // 4. 返回结果
  Ok(eight_char)
}

// 使用示例
let bazi = calculate_bazi(1990, 5, 15, 14, 30, 0)?
println(bazi.to_string())  // "庚午 辛巳 甲子 辛未"
```

## 错误处理

所有构造函数返回 `Result[T, String]`，建议统一处理：

```moonbit
match SolarDay::from_ymd(year, month, day) {
  Ok(day) => { /* 处理 */ }
  Err(e) => {
    println("日期无效: " + e)
    // 返回错误给用户
  }
}
```

常见错误：
- `"illegal solar day: 1582-10-5"` — 1582年10月5-14日不存在（格里高利历改革）
- `"illegal lunar month: 13"` — 农历月份超出范围
- `"illegal day 32 in 乙巳年腊月"` — 日期超出当月天数
- `"illegal event data: empty"` — 事件数据为空