# Tyme4MB [![License](https://img.shields.io/badge/license-MIT-4EB1BA.svg?style=flat-square)](./LICENSE)

Tyme4MB 是 [tyme4go](https://github.com/6tail/tyme4go) 的 MoonBit 移植版本。Tyme 是一个非常强大的日历工具库，可以看作 [Lunar](https://6tail.cn/calendar/api.html) 的升级版，拥有更优的设计和扩展性，支持公历、农历、藏历（饶迥历）、回历、星座、干支、生肖、节气、月相、法定假日、八字、童限、大运、小运、神煞、宜忌等。

> 基于 MoonBit 语言开发，编译目标为 WASM。

## 功能概览

| 模块 | 说明 |
|------|------|
| 公历 | 格里高利历（年/月/日/时/分/秒/星期/季节/半年/周） |
| 农历 | 中国传统阴阳合历（含闰月、节气定位） |
| 回历 | 伊斯兰历法 |
| 藏历（饶迥历） | 印尼巴厘岛历法 |
| 干支 | 六十甲子循环（年/月/日/时四柱） |
| 八字 | 四柱命理（含胎元、命宫、身宫、纳音、真太阳时反推） |
| 节气 | 二十四节气精确时刻计算（基于寿星天文历算法） |
| 神煞 | 130 种吉凶神煞 |
| 宜忌 | 每日/时辰宜忌查询 |
| 童限/大运/小运 | 命理推算（支持 Default、China95、LunarSect1、LunarSect2 四种流派；童限支持真太阳时） |
| 星座 | 黄道十二星座 |
| 月相 | 新月/上弦月/满月/下弦月等月相计算 |
| 法定假日 | 中国法定节假日及调休安排（2001年至今） |
| 事件 | 自定义节日/事件管理与查询 |
| 其他 | 二十八星宿、九星、六曜、小六壬、灶马头、彭祖百忌、胎神等 |

## 安装

```bash
# 通过 mooncakes.io 安装（发布后可用）
moon add justinwongcn/tyme4mb
```

## 快速开始

```moonbit
import tyme.{SolarDay, LunarDay, EightChar, LunarHour}

// 1. 公历日
let solarDay = SolarDay::from_ymd(1986, 5, 29).unwrap()
println(solarDay.to_string())        // 1986年5月29日

// 2. 公历转农历
let lunarDay = solarDay.get_lunar_day()
println(lunarDay.to_string())        // 农历丙寅年四月廿一

// 3. 公历转藏历
let rabByungDay = solarDay.get_rab_byung_day()
println(rabByungDay.to_string())     // 第十七饶迥火虎年四月廿一

// 4. 公历转回历
let hijriDay = solarDay.get_hijri_day()
println(hijriDay.to_string())        // 1406年赖买丹月20日

// 5. 八字排盘
let solarTime = SolarTime::from_ymdhms(1986, 5, 29, 13, 0, 0).unwrap()
let lunarHour = solarTime.get_lunar_hour().unwrap()
let eightChar = eight_char_provider.get_eight_char(lunarHour)
println(eightChar.to_string())       // 丙寅 癸巳 癸酉 己未
```

## 构建

```bash
# 构建库
moon build

# 运行测试
moon test

# 运行示例
moon run examples
```

## 项目结构

```
tyme4mb/
├── tyme/                  # 稳定的 @tyme 兼容入口
│   ├── moon.pkg           # facade 包声明
│   ├── reexports.mbt      # 保持原公开类型、函数和 trait 名称
│   ├── core/              # 领域实现（sealed trait 与历法类型）
│   │   ├── moon.pkg
│   │   ├── solar_*.mbt    # 公历相关
│   │   ├── lunar_*.mbt    # 农历相关
│   │   ├── hijri_*.mbt    # 回历
│   │   ├── rab_byung_*.mbt # 藏历（饶迥历）
│   │   ├── sixty_cycle*.mbt # 六十甲子
│   │   └── *_wbtest.mbt   # 包内单元测试
│   └── astronomy/         # 无领域类型依赖的纯天文算法
│       ├── moon.pkg
│       └── shou_xing_util.mbt
├── examples/              # 示例工程
├── openwiki/              # 自动生成的文档
├── .github/workflows/     # CI/CD
├── moon.mod               # 模块声明
├── LICENSE                # MIT 许可证
└── THIRD_PARTY_LICENSES.md # 第三方许可证与归属说明
```

## 测试

项目包含 43 个测试文件，约 3,200 行测试代码，涵盖：

- 各模块的单元测试
- 全量交叉引用测试
- 神煞/宜忌差分测试
- 八字真太阳时测试
- 童限真太阳时双轨测试（四柱按真太阳时、差值按钟表时刻）
- 事件管理器完整测试

```bash
# 运行全部测试
moon test
```

## 移植来源

本项目移植自 [tyme4go](https://github.com/6tail/tyme4go)（Go 版本），采用逐函数翻译方式，保留了原始算法和数据表。详细的移植说明请参阅 [PORTING.md](./PORTING.md)。

## 致谢

1. 感谢 [6tail](https://github.com/6tail) 创建并开源了 [tyme4go](https://github.com/6tail/tyme4go)（MIT License, Copyright (c) 2024 6tail），本项目移植自该仓库
2. 感谢许剑伟老师分享的 [寿星天文历](https://github.com/sxwnl/sxwnl)（自定义开源许可），节气算法引自该项目
3. 感谢 [starainrt](https://github.com/starainrt) 开源的 [astro](https://github.com/starainrt/astro)（Apache License 2.0），真太阳时算法引自该项目
4. 感谢 [stonelf](https://github.com/stonelf) 开源的 [zangli](https://github.com/stonelf/zangli)（MIT License, Copyright (c) 2016 emu），藏历数据引自该项目

## 文档

更详细的文档请参阅 [OpenWiki](./openwiki/quickstart.md)。
未来的结构演进规划请参阅 [ROADMAP.md](./ROADMAP.md)。

## 许可证

本项目采用 [MIT](./LICENSE) 许可证。

本项目移植并使用了以下第三方项目的代码或数据，完整的第三方许可证文本与归属说明请参阅 [THIRD_PARTY_LICENSES.md](./THIRD_PARTY_LICENSES.md)：

| 项目 | 许可证 | 用途 |
|------|--------|------|
| [tyme4go](https://github.com/6tail/tyme4go) | MIT License, Copyright (c) 2024 6tail | 整体移植来源 |
| [sxwnl/sxwnl](https://github.com/sxwnl/sxwnl) | 自定义开源许可, 许剑伟 | 节气天文算法 |
| [starainrt/astro](https://github.com/starainrt/astro) | Apache License 2.0, Copyright starainrt | 真太阳时算法 |
| [stonelf/zangli](https://github.com/stonelf/zangli) | MIT License, Copyright (c) 2016 emu | 藏历数据 |
