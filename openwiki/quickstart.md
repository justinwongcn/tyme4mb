# Quickstart

Tyme4MB（`justinwongcn/tyme4mb`，当前 0.2.5，MIT）是 [tyme4go](https://github.com/6tail/tyme4go) v1.5.0 的 MoonBit 逐函数移植，一个中国传统历法计算库：公历、农历、藏历（饶迥历 RabByung）、回历（Hijri）、干支、生肖、节气、月相、法定假日、八字、童限、大运、神煞、宜忌等。零第三方依赖（仅 `moonbitlang/core`），编译目标为 wasm-gc / wasm / js / native（`moon.mod`，`AGENTS.md`）。

> 阅读提示：README 中部分数字已过时——"43 个测试文件"实际为 `tyme/core` 下 60 个白盒测试文件 + `api_test/` 下 10 个黑盒测试文件（约 2472 行）；"130 种吉凶神煞"实际为 151 条（另有宜忌 140 项），详见 [testing.md](testing.md) 与 [domain-shensha.md](domain-shensha.md)。

## 功能全景

| 领域 | 内容 | 详细文档 |
|------|------|----------|
| 历法 | 公历（含 1582 年儒略/格里切换）、农历（天文朔日推算、闰月）、干支六十甲子、藏历、回历、儒略日 | [domain-calendars.md](domain-calendars.md) |
| 八字命理 | 四柱排盘（多种流派）、童限/大运/流年、十神、十二长生、藏干 | [domain-bazi.md](domain-bazi.md) |
| 神煞宜忌 | 八字神煞 V2（55 条）、日神煞（151 条吉凶神）、每日/时辰宜忌（140 项） | [domain-shensha.md](domain-shensha.md) |
| 文化杂项 | 物候、三伏、梅雨、数九、九星、二十八宿、胎神、彭祖百忌、六曜、小六壬、灶马头等 | [domain-culture.md](domain-culture.md) |
| 天文算法 | 寿星天文历节气/朔日、真太阳时、均时差、日出日落 | [astronomy.md](astronomy.md) |

本项目相对上游 tyme4go 的主要扩展（上游无对应实现，不能以 Go 版为黄金参照）：真太阳时家族（`SolarTime::to_true_solar_time` / `get_solar_noon` / `get_sunrise` / `get_sunset`）、童限真太阳时双轨、八字神煞 V2、真黄经人元司令分野（`hide_heaven_stem_ecliptic.mbt`）、地支六破/三合/三会，以及闰月/神煞查询的索引性能优化。

## 安装与最小用法

```bash
moon add justinwongcn/tyme4mb
```

```moonbit
import tyme.{SolarDay, SolarTime}

// 公历日与星期、星座
let solar_day = SolarDay::from_ymd(1986, 5, 29).unwrap()
println(solar_day.to_string())          // 1986年5月29日

// 公历 → 农历 / 藏历 / 回历
println(solar_day.get_lunar_day().to_string())      // 农历丙寅年四月廿一
println(solar_day.get_rab_byung_day().unwrap().to_string())  // 第十七饶迥火虎年四月廿一
println(solar_day.get_hijri_day().to_string())      // 1406年赖买丹月20日

// 公历时刻 → 干支八字
let solar_time = SolarTime::from_ymdhms(1986, 5, 29, 13, 0, 0).unwrap()
let lunar_hour = solar_time.get_lunar_hour().unwrap()
println(lunar_hour.get_eight_char().to_string())    // 丙寅 癸巳 癸酉 己未
```

公开 API 一律经 facade 包 `tyme`（`@tyme.*`）访问，签名见 [tyme/pkg.generated.mbti](../tyme/pkg.generated.mbti)；接口语义以 `AGENTS.md` 所列的 `go.md` / `java.md` / `ts.md` 三份上游接口文档为主要依据。

## 常用命令

```bash
moon build          # 构建（默认 wasm-gc；--target all 四目标均可通过）
moon test           # 全量测试（CI 用 --deny-warn）
moon run examples   # 12 节交互式示例（examples/main.mbt），覆盖全部主要能力
moon fmt            # 格式化（CI 检查 moon fmt --check）
moon check --deny-warn  # 静态检查，任何 warning 即失败
moon info           # 变更公开 API 后刷新 pkg.generated.mbti
```

## 包结构

```
tyme/base/        基础抽象：Culture/Tyme trait、LoopTyme 环形枚举、单位与二元枚举（零外部依赖）
tyme/astronomy/   纯天文算法：寿星天文历、真太阳时（仅依赖 moonbitlang/core/math）
tyme/core/        领域实现：约 130 个源文件，所有历法与文化类型
tyme/             facade：reexports.mbt 以 pub using 重导出，保持 @tyme 兼容边界
api_test/         黑盒测试（仅 import tyme）
examples/         可执行示例（is-main）
```

依赖方向严格单向：`base ← astronomy ← core ← facade`。分层细节、抽象模型与修改公开 API 的标准流程见 [architecture.md](architecture.md)。

## 文档地图

- [architecture.md](architecture.md) — 包分层、抽象模型、重导出链、全局可变单点、工程约定
- [domain-calendars.md](domain-calendars.md) — 五大历法体系、儒略日中介、换算主干、节日/假日/事件
- [domain-bazi.md](domain-bazi.md) — 八字、童限（含真太阳时双轨）、大运流年、命理要素
- [domain-shensha.md](domain-shensha.md) — 两套神煞宜忌体系、查询索引优化、数据来源
- [domain-culture.md](domain-culture.md) — 文化杂项类型分组与 LoopTyme 模式
- [astronomy.md](astronomy.md) — 天文算法、真太阳时链路、精度与年份边界
- [testing.md](testing.md) — 测试分层、与 Go 参考实现的差分对拍、基准、CI、验证缺口

## 来源与致谢

- [tyme4go](https://github.com/6tail/tyme4go)（MIT, 6tail）— 整体移植来源，`tyme4go/` 为本地参考源码（不入库）
- [寿星天文历 sxwnl](https://github.com/sxwnl/sxwnl)（许剑伟）— 节气/朔日天文算法
- [starainrt/astro](https://github.com/starainrt/astro)（Apache 2.0）— 真太阳时算法
- [stonelf/zangli](https://github.com/stonelf/zangli)（MIT）— 藏历数据

完整许可证归属见 [THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md)。
