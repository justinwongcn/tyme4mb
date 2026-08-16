# Tyme API 文档

几乎所有的类型，都可以调用以下几个方法：

1. 名称
调用get_name()返回名称字符串。

        // 农历年名称
        let lunar_year = LunarYear::from_year(2023)
        // 农历癸卯年（依据国家标准《农历的编算和颁行》GB/T 33661-2017，农历年有2种命名方法：干支纪年法和生肖纪年法，这里默认采用干支纪年法。）
        let name = lunar_year.get_name()
      
2. 完整描述
调用to_string()返回完整描述字符串。

        // 农历月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 正月
        let month_name = lunar_month.get_name()
        // 农历癸卯年正月
        let month_string = lunar_month.to_string()
      
3. 推移
调用next(n)推移指定的步数，参数正数顺推，负数逆推。例如农历年推移，则代表推移多少年；农历时辰推移，则代表推移多少个时辰。

        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 得到5个月后的农历月
        let lunar_month2 = lunar_month.next(5)
      
也有很多支持轮回的类型(以轮回标注)，例如天干(10个为一轮)、地支(12个为一轮)、干支(60个为一轮)、星期(7个为一轮)等，可以通过索引值或名称进行初始化：

1. 通过索引值进行初始化
调用from_index(index)得到其对象。index为数字，从0开始，当索引值越界时，会自动轮回偏移。

        // 日
        let week = Week::from_index(0)

        // 六
        let week2 = Week::from_index(-1)

        // 乙丑
        let sixty_cycle = SixtyCycle::from_index(1)
      
2. 通过名称进行初始化
调用from_name(name)得到其对象。name为字符串，当名称不存在时，会抛出参数异常。

        // 日
        let week = Week::from_name("日")

        // 六
        let week2 = Week::from_name("六")

        // 乙丑
        let sixty_cycle = SixtyCycle::from_name("乙丑")
      
## 农历年 LunarYear

依据国家标准《农历的编算和颁行》GB/T 33661-2017，农历年以正月初一开始，至除夕结束。

### 如何得到农历年？

1. 从年初始化
参数为农历年，支持从-1到9999年。

        let lunar_year = LunarYear::from_year(2023)
      
2. 从农历月 LunarMonth得到农历年
        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let lunar_year = lunar_month.get_lunar_year()
      
### 从农历年可以得到些什么？

1. 年
返回为农历年数字，范围为-1到9999。

        let lunar_year = LunarYear::from_year(2023)
        // 得到2023
        let year = lunar_year.get_year()
      
2. 当年的总天数
返回为数字，从正月初一到除夕的总天数。

        let lunar_year = LunarYear::from_year(2023)
        let day_count = lunar_year.get_day_count()
      
3. 当年的闰月月份
返回为数字，代表当年的闰月月份，例如：5代表闰五月，0代表当年没有闰月。

        let lunar_year = LunarYear::from_year(2023)
        let leap_month = lunar_year.get_leap_month()
      
4. 当年的干支
返回为干支 SixtyCycle。

        let lunar_year = LunarYear::from_year(2023)
        let sixty_cycle = lunar_year.get_sixty_cycle()
      
5. 运
返回为运 Twenty。

        let lunar_year = LunarYear::from_year(2023)
        let twenty = lunar_year.get_twenty()
      
6. 九星
返回为九星 NineStar。

        let lunar_year = LunarYear::from_year(2023)
        let nine_star = lunar_year.get_nine_star()
      
7. 太岁方位
返回为方位 Direction。

        let lunar_year = LunarYear::from_year(2023)
        let direction = lunar_year.get_jupiter_direction()
      
8. 农历月列表
返回为农历月 LunarMonth的列表，从正月到十二月，包含闰月。

        let lunar_year = LunarYear::from_year(2023)
        let months = lunar_year.get_months()
      
9. 灶码头 KitchenGodSteed
        let lunar_year = LunarYear::from_year(2023)
        let kitchen_god_steed = lunar_year.get_kitchen_god_steed()
      
## 农历季节 LunarSeason

从正月开始，依次为：孟春、仲春、季春、孟夏、仲夏、季夏、孟秋、仲秋、季秋、孟冬、仲冬、季冬。

### 如何得到农历季节？

1. 从农历月 LunarMonth得到
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let season = lunar_month.get_season()
      
## 农历月 LunarMonth

农历月以初一开始，大月30天，小月29天。

### 如何得到农历月？

1. 从农历年、月初始化
参数农历年，支持从-1到9999年；参数农历月，支持1到12，如果为闰月的，使用负数，即-3代表闰三月。

        let lunar_month = LunarMonth::from_ym(2023, 5)
      
2. 从农历日 LunarDay得到农历月
        // 农历2023年正月初一
        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let lunar_month = lunar_day.get_lunar_month()
      
### 从农历月可以得到些什么？

1. 农历年
返回为农历年 LunarYear。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let lunar_year = lunar_month.get_lunar_year()
      
2. 月
返回为月份数字，范围为1到12，如闰七月也返回7。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 1
        let month = lunar_month.get_month()
      
3. 月(支持闰月)
返回为月份数字，范围为1到12，闰月为负数，如闰7月返回-7。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 1
        let month = lunar_month.get_month_with_leap()
      
4. 是否闰月
返回为布尔值，闰月返回true，非闰月返回false。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // false
        let leap = lunar_month.is_leap()
      
5. 位于当年的月索引
返回为数字，范围0到12，正月为0，依次类推，例如五月索引值为4，闰五月索引值为5。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 0
        let index = lunar_month.get_index_in_year()
      
6. 当月的总天数
返回为数字，从初一开始的总天数，大月有30天，小月有29天。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let day_count = lunar_month.get_day_count()
      
7. 农历季节
返回为农历季节 LunarSeason。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let season = lunar_month.get_season()
      
8. 初一的儒略日
返回为儒略日 JulianDay。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let julian_day = lunar_month.get_first_julian_day()
      
9. 当月有几周
参数为起始星期，1234560分别代表星期一至星期天，返回为数字。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let week_count = lunar_month.get_week_count(1)
      
10. 当月的周列表
参数为起始星期，1234560分别代表星期一至星期天，返回为农历周 LunarWeek的列表。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let weeks = lunar_month.get_weeks(1)
      
11. 当月的干支
国家标准中并没有提及农历月干支的概念，其实干支纪月在史书和日历中并不常用，最常用于占卜和风水。而农历月干支与传统的节气划分的月干支并不在一个体系，这里的农历月干支代表从初一开始的一个整月的干支，根据正月建寅和五虎遁月的规律进行分配。有两个需要注意的点：

1、市面上常见的日历中，某一天的农历月干支并不是取的这个干支，而是取以节气划分的干支月 SixtyCycleMonth干支。

2、农历闰月没有月建，据明清的历书所载，闰月的月干支以月内之节气划分，节气之前用前月的干支，节气之后用下月的干支，但此规则过于复杂，且不能唯一确定整月干支，因此农历闰月的干支沿用上月的干支。

返回为干支 SixtyCycle。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let sixty_cycle = lunar_month.get_sixty_cycle()
      
12. 九星
返回为九星 NineStar。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let nine_star = lunar_month.get_nine_star()
      
13. 太岁方位
返回为方位 Direction。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let direction = lunar_month.get_jupiter_direction()
      
14. 农历日列表
返回为农历日 LunarDay的列表，从初一开始。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        let days = lunar_month.get_days()
      
15. 逐月胎神
返回为逐月胎神 FetusMonth。闰月无胎神。

        // 农历2023年正月
        let lunar_month = LunarMonth::from_ym(2023, 1)
        // 注意闰月会返回None
        let fetus = lunar_month.get_fetus()
      
## 农历周 LunarWeek

农历一个月最多有6个周，分别为：第一周、第二周、第三周、第四周、第五周、第六周。

### 如何得到农历周？

1. 通过农历年月的周索引初始化，参数分别为农历年、农历月、周索引、起始星期（1234560分别代表星期一至星期日）
        // 农历癸卯年正月第一周，以星期2为一周的开始
        let lunar_week = LunarWeek::from_ym(2023, 1, 0, 2)
      
### 从农历周可以得到些什么？

1. 本周第一天的农历日
返回为农历日 LunarDay。

        let lunar_week = LunarWeek::from_ym(2023, 1, 0, 2)
         
        // 农历壬寅年十二月廿六
        let lunar_day = lunar_week.get_first_day()
      
2. 本周农历日列表
返回为农历日 LunarDay的列表。

        let lunar_week = LunarWeek::from_ym(2023, 1, 0, 2)
        let days = lunar_week.get_days()
      
## 农历日 LunarDay

### 如何得到农历日？
1. 从农历年、月、日初始化
参数农历年，支持从-1到9999年；参数农历月，支持1到12，如果为闰月的，使用负数，即-3代表闰三月；参数农历日，支持1到30，大月30天，小月29天。

        // 农历2023年正月初一
        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
      
2. 从农历时辰 LunarHour得到农历日
        // 农历2023年正月初一 13:00:00
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let lunar_day = lunar_hour.get_lunar_day()
      
3. 从公历日 SolarDay转农历日
        // 公历2024年2月9日
        let solar_day = SolarDay::from_ymd(2024, 2, 9)
        // 农历癸卯年十二月三十
        let lunar_day = solar_day.get_lunar_day()
      
### 从农历日可以得到些什么？

1. 农历月 LunarMonth
        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        // 正月
        let lunar_month = lunar_day.get_lunar_month()
      
2. 日
返回为数字，范围1到30。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        // 1
        let day = lunar_day.get_day()
      
3. 星期 Week
        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let week = lunar_day.get_week()
      
4. 当天的年干支(已废弃，请使用干支日 SixtyCycleDay的年柱)
非当天所属的农历年干支，而是以立春换年。返回为干支 SixtyCycle。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let sixty_cycle = lunar_day.get_year_sixty_cycle()
      
5. 当天的月干支(已废弃，请使用干支日 SixtyCycleDay的月柱)
非当天所属的农历月干支，而是以节令换月。返回为干支 SixtyCycle。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let sixty_cycle = lunar_day.get_month_sixty_cycle()
      
6. 当天的干支
返回为干支 SixtyCycle。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let sixty_cycle = lunar_day.get_sixty_cycle()
      
7. 九星
返回为九星 NineStar。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let nine_star = lunar_day.get_nine_star()
      
8. 太岁方位
返回为方位 Direction。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let direction = lunar_day.get_jupiter_direction()
      
9. 建除十二值神
返回为建除十二值神 Duty。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let duty = lunar_day.get_duty()
      
10. 黄道黑道十二神
返回为黄道黑道十二神 TwelveStar。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let twelve_star = lunar_day.get_twelve_star()
      
11. 逐日胎神
返回为逐日胎神 FetusDay。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let fetus = lunar_day.get_fetus_day()
      
12. 月相
返回为月相 Phase。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let phase = lunar_day.get_phase()
      
13. 二十八宿
返回为二十八宿 TwentyEightStar。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let twenty_eight_star = lunar_day.get_twenty_eight_star()
      
14. 农历传统节日
返回为农历传统节日 LunarFestival，当天无节日返回None。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let festival = lunar_day.get_festival()
      
15. 农历日转公历日
返回为公历日 SolarDay。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let solar_day = lunar_day.get_solar_day()
      
16. 农历日前后比较
        // 农历2023年正月初一
        let a = LunarDay::from_ymd(2023, 1, 1)
        // 农历2023年正月初二
        let b = LunarDay::from_ymd(2023, 1, 2)

        // a在b之前吗？这里返回true
        let a_is_before_b = a.is_before(b)
         
        // a在b之后吗？这里返回false
        let a_is_after_b = a.is_after(b)
      
17. 当天的时辰列表
由于23:00-23:59、00:00-00:59均为子时，而农历日是从00:00-23:59为一天，所以获取当天的时辰列表，实际会返回13个。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let lunar_hours = lunar_day.get_hours()
      
18. 三柱
返回为三柱 ThreePillars。

在黄历中，如果需要得到当天的年月日干支，建议使用该方法。

        let lunar_day = LunarDay::from_ymd(2023, 1, 1)
        let t = lunar_day.get_three_pillars()
      
## 农历时辰 LunarHour

### 如何得到农历时辰？
1. 从农历年、月、日、时、分、秒初始化
参数农历年，支持从-1到9999年；参数农历月，支持1到12，如果为闰月的，使用负数，即-3代表闰三月；参数农历日，支持1到30，大月30天，小月29天；时为0-23；分为0-59；秒为0-59。

        // 农历2023年正月初一 13:00:00
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
      
2. 从公历时刻 SolarTime转农历时辰
        // 公历2024年2月9日 13:00:00
        let solar_time = SolarTime::from_ymd_hms(2024, 2, 9, 13, 0, 0)
        // 农历癸卯年十二月三十 未时
        let lunar_hour = solar_time.get_lunar_hour()
      
### 从农历时辰可以得到些什么？

1. 农历日 LunarDay
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 初一
        let lunar_day = lunar_hour.get_lunar_day()
      
2. 时
返回为数字，范围0到23。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 13
        let hour = lunar_hour.get_hour()
      
3. 分
返回为数字，范围0到59。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 0
        let minute = lunar_hour.get_minute()
      
4. 秒
返回为数字，范围0到59。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 0
        let second = lunar_hour.get_second()
      
5. 位于当天的序号
返回为数字，范围0到11。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 7
        let index = lunar_hour.get_index_in_day()
      
6. 当时的年干支(已废弃，请使用干支时辰 SixtyCycleHour的年柱)
非当时所属的农历年干支，而是以立春具体时刻换年。返回为干支 SixtyCycle。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let sixty_cycle = lunar_hour.get_year_sixty_cycle()
      
7. 当时的月干支(已废弃，请使用干支时辰 SixtyCycleHour的月柱)
非当时所属的农历月干支，而是以节令具体时刻换月。返回为干支 SixtyCycle。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let sixty_cycle = lunar_hour.get_month_sixty_cycle()
      
8. 当时的日干支(已废弃，请使用干支时辰 SixtyCycleHour的日柱)
返回为干支 SixtyCycle。注意：23:00开始算做第二天。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let sixty_cycle = lunar_hour.get_day_sixty_cycle()
      
9. 时辰干支
返回为干支 SixtyCycle。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let sixty_cycle = lunar_hour.get_sixty_cycle()
      
10. 九星
返回为九星 NineStar。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let nine_star = lunar_hour.get_nine_star()
      
11. 黄道黑道十二神
返回为黄道黑道十二神 TwelveStar。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let twelve_star = lunar_hour.get_twelve_star()
      
12. 农历时辰转公历时刻
返回为公历时刻 SolarTime。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let solar_time = lunar_hour.get_solar_time()
      
13. 农历时辰转八字
默认23:00-23:59日干支为明天，返回为八字 EightChar。

        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let eight_char = lunar_hour.get_eight_char()
      
由于有的流派认为23:00-23:59日干支为当天，有的流派则认为应该算明天，可通过EightCharProvider来切换，默认支持以下几种方式，你也可以自定义。

a. 默认（23:00-23:59日干支为明天，对应Lunar流派1）
        LunarHour::set_provider(DefaultEightCharProvider)
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 23, 0, 0)
        let eight_char = lunar_hour.get_eight_char()
      
b. Lunar流派2（23:00-23:59日干支为当天）
        LunarHour::set_provider(LunarSect2EightCharProvider)
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 23, 0, 0)
        let eight_char = lunar_hour.get_eight_char()
      
c. 自定义
实现EightCharProvider trait。

        // 实现EightCharProvider trait
        struct MyEightCharProvider {
          // 实现get_eight_char方法
        }
        impl EightCharProvider for MyEightCharProvider {
          // ...
        }
         
        LunarHour::set_provider(MyEightCharProvider{})
      
14. 农历时辰前后比较
        // 农历2023年正月初一 13:00:00
        let a = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 农历2023年正月初二 09:00:00
        let b = LunarHour::from_ymd_hms(2023, 1, 2, 9, 0, 0)

        // a在b之前吗？这里返回true
        let a_is_before_b = a.is_before(b)
         
        // a在b之后吗？这里返回false
        let a_is_after_b = a.is_after(b)
      
## 藏历年 RabByungYear

公历1027年为藏历元年，即第一饶迥火兔年。藏历中绕迥代表60年。本项目的藏历数据引自https://github.com/stonelf/zangli

### 如何得到藏历年？

1. 从年初始化
参数为藏历年数字，由于1027年是藏历元年，干支为丁火，属于第一饶迥，往前推到第一绕迥的第1年甲子年为1024年，因此参数最小值仅支持1024，再小绕迥就为零或负数了。参数最大值为9999。

        // 第十六饶迥铁虎年
        let y = RabByungYear::from_year(1950)
      
2. 从藏历月 RabByungMonth得到藏历年
        // 第十六饶迥铁虎年十二月
        let m = RabByungMonth::from_ym(1950, 12)
         
        // 第十六饶迥铁虎年
        let y = m.get_rab_byung_year()
      
3. 从年干支 SixtyCycle得到藏历年
第1个参数为绕迥序号，从0开始，0代表第一饶迥(饶迥序号不能小于0，不能大于150，下同)。第2个参数为干支。

        let sc = SixtyCycle::from_name("丁卯")
         
        // 第一饶迥火兔年
        let y = RabByungYear::from_sixty_cycle(0, sc)
      
4. 从藏历五行 RabByungElement和生肖 Zodiac得到藏历年
第1个参数为绕迥序号，从0开始，0代表第一饶迥。第2个参数为藏历五行。第3个参数为生肖。

        let e = RabByungElement::from_name("火")
        let z = Zodiac::from_name("兔")
         
        // 第一饶迥火兔年
        let y = RabByungYear::from_element_zodiac(0, e, z)
      
5. 公历年 SolarYear转藏历年
        // 1950年
        let sy = SolarYear::from_year(1950)
         
        // 第十六饶迥铁虎年
        let y = sy.get_rab_byung_year()
      
### 从藏历年可以得到些什么？

1. 年
返回为藏历年数字，范围为1024到9999。

        let y = RabByungYear::from_year(2023)
        // 得到2023
        let year = y.get_year()
      
2. 当年的闰月月份
返回为数字，代表当年的闰月月份，例如：5代表闰五月，0代表当年没有闰月。

        let y = RabByungYear::from_year(2043)
         
        // 5
        let m = y.get_leap_month()
      
3. 当年的总月数
返回为数字，如果当年有闰月，则返回13，无闰月则返回12。

        let y = RabByungYear::from_year(2043)
         
        // 13
        let m = y.get_month_count()
      
4. 饶迥序号
从0开始计。

        let y = RabByungYear::from_year(1027)
         
        // 0
        let n = y.get_rab_byung_index()
      
5. 当年的干支
返回为干支 SixtyCycle。

        let y = RabByungYear::from_year(1027)
         
        // 丁卯
        let sc = y.get_sixty_cycle()
      
6. 藏历五行 RabByungElement
藏历五行与五行一致，只是五行的金叫法不同，叫做铁。

        let y = RabByungYear::from_year(1027)
         
        // 火
        let e = y.get_element()
      
7. 生肖 Zodiac
        let y = RabByungYear::from_year(1027)
         
        // 兔
        let z = y.get_zodiac()
      
8. 藏历年转公历年 SolarYear
        let y = RabByungYear::from_year(1027)
         
        // 1027年
        let year = y.get_solar_year()
      
9. 首月
返回为正月(藏历月 RabByungMonth)。

        let y = RabByungYear::from_year(1027)
         
        // 第一饶迥火兔年正月
        let m = y.get_first_month()
      
10. 藏历月列表
返回为藏历月 RabByungMonth的列表，从正月到十二月，包含闰月。

        let y = RabByungYear::from_year(1027)
        let months = y.get_months()
      
## 藏历月 RabByungMonth

藏历月比较特殊，虽然和农历类似，从初一到三十，但是可能出现缺日（例如：初五之后直接初七）和闰日（例如：2个初五）的情况，所以藏历月天数不固定，和农历基本对不上。

### 如何得到藏历月？

1. 从藏历年、月初始化
参数藏历年，支持从1950到2050年；参数藏历月，支持1到12，如果为闰月的，使用负数，即-3代表闰三月。藏历月仅支持藏历1950年十二月至藏历2050年十二月。

        let m = RabByungMonth::from_ym(1950, 12)
      
2. 从藏历日 RabByungDay得到藏历月
        // 第十六饶迥铁虎年十二月初一
        let d = RabByungDay::from_ymd(1950, 12, 1)
        let m = d.get_rab_byung_month()
      
### 从藏历月可以得到些什么？

1. 藏历年 RabByungYear
        let m = RabByungMonth::from_ym(1950, 12)
        let y = m.get_rab_byung_year()
      
2. 月
返回为月份数字，范围为1到12，如闰七月也返回7。

        let m = RabByungMonth::from_ym(1950, 12)
        // 12
        let month = m.get_month()
      
3. 月(支持闰月)
返回为月份数字，范围为1到12，闰月为负数，如闰7月返回-7。

        let m = RabByungMonth::from_ym(2043, -5)
        // -5
        let month = m.get_month_with_leap()
      
4. 是否闰月
返回为布尔值，闰月返回true，非闰月返回false。

        let m = RabByungMonth::from_ym(2043, -5)
        // true
        let leap = m.is_leap()
      
5. 别名
藏历每月有别名，如正月也称神变月，二月也称苦行月，后续类推为：具香月、萨嘎月、作净月、明净月、具醉月、具贤月、天降月、持众月、庄严月、满意月。

        let m = RabByungMonth::from_ym(2043, -5)
        // 闰作净月
        let alias = m.get_alias()
      
6. 位于当年的月索引
返回为数字，范围0到12，正月为0，依次类推，例如五月索引值为4，闰五月索引值为5。

        let m = RabByungMonth::from_ym(2043, 1)
        // 0
        let index = m.get_index_in_year()
      
7. 当月的总天数
返回为数字，因存在闰日和缺日的情况，天数不固定。

        let m = RabByungMonth::from_ym(2043, 1)
        let n = m.get_day_count()
      
8. 闰日列表
将当月闰日的日期返回为数字列表，如闰初五和闰十一，则返回5和11。

        let m = RabByungMonth::from_ym(2043, 1)
        let days = m.get_leap_days()
      
9. 缺日列表
将当月缺日的日期返回为数字列表，如缺初五和十一，则返回5和11。

        let m = RabByungMonth::from_ym(2043, 1)
        let days = m.get_miss_days()
      
10. 首日
返回为初一的藏历日 RabByungDay。

        let m = RabByungMonth::from_ym(2043, 1)
        let d = m.get_first_day()
      
11. 藏历日列表
返回为藏历日 RabByungDay的列表，从初一开始。

        let m = RabByungMonth::from_ym(2043, 1)
        let days = m.get_days()
      
## 藏历日 RabByungDay

藏历日仅支持藏历1950年十二月初一（公历1951年1月8日）至藏历2050年十二月三十（公历2051年2月11日）。

### 如何得到藏历日？

1. 从藏历年、月、日初始化
参数藏历年，支持从1950-2051年；参数藏历月，支持1到12，如果为闰月的，使用负数，即-3代表闰三月；参数藏历日，支持1到30，闰日为负数，即-3代表闰初三。

        // 第十六饶迥铁虎年十二月初一
        let d = RabByungDay::from_ymd(1950, 12, 1)
      
2. 从公历日 SolarDay转藏历日
        // 公历1951年1月8日
        let sd = SolarDay::from_ymd(1951, 1, 8)
        // 第十六饶迥铁虎年十二月初一
        let d = sd.get_rab_byung_day()
      
### 从藏历日可以得到些什么？

1. 藏历月 RabByungMonth
        let d = RabByungDay::from_ymd(1950, 12, 1)
        // 第十六饶迥铁虎年十二月
        let m = d.get_rab_byung_month()
      
2. 日
返回为数字，范围1到30，闰日也为正数。

        let d = RabByungDay::from_ymd(1950, 12, -16)
        // 16
        let day = d.get_day()
      
3. 日
返回为数字，范围1到30，当日为闰日时，返回负数。

        let d = RabByungDay::from_ymd(1950, 12, -16)
        // -16
        let day = d.get_day_with_leap()
      
4. 是否闰日
        let d = RabByungDay::from_ymd(1950, 12, -16)
        // true
        let leap = d.is_leap()
      
5. 相差天数
        let d1 = RabByungDay::from_ymd(1950, 12, -16)
        let d2 = RabByungDay::from_ymd(1950, 12, 16)
        // 1
        let days = d1.subtract(d2)
      
6. 藏历日转公历日 SolarDay
        // 第十六饶迥铁虎年十二月闰十六
        let d = RabByungDay::from_ymd(1950, 12, -16)
         
        // 1951年1月24日
        let sd = d.get_solar_day()
      
## 回历年 HijriYear

伊斯兰教历，或伊斯兰历，正式名称为希吉来历，在我国也叫回回历或回历，是伊斯兰教国家和全世界穆斯林所通用的历法。为纪念穆罕默德于公元622年率穆斯林由麦加迁徙到麦地那这一重要历史事件，伊斯兰教第二任哈里发欧麦尔决定把该年定为伊斯兰教历元年，并将伊斯兰教历命名为"希吉来"（阿拉伯语"迁徙"之意）。

### 如何得到回历年？

1. 从年初始化
参数为回历年数字，支持-640到9666。

        // 回历1年，即公历622年
        let y = HijriYear::from_year(1)
      
2. 从回历月 HijriMonth得到回历年
        // 回历1年1月，即公历622年7月
        let m = HijriMonth::from_ym(1, 1)
         
        // 1年
        let y = m.get_hijri_year()
      
### 从回历年可以得到些什么？

1. 年
返回为回历年数字，范围为-640到9666。

        let y = HijriYear::from_year(1)
        // 得到1
        let year = y.get_year()
      
2. 当年的总天数
返回为数字，平年354天，闰年355天。

        let y = HijriYear::from_year(2)
         
        // 355
        let m = y.get_day_count()
      
3. 是否闰年
1个闰周为30年，1个闰周中第2、5、7、10、13、16、18、21、24、26、29年为闰年。

        let y = HijriYear::from_year(2)
         
        // true
        let leap = y.is_leap()
      
4. 首月
返回为穆哈兰姆月(回历月 HijriMonth)。

        let y = HijriYear::from_year(1)
         
        // 1年穆哈兰姆月
        let m = y.get_first_month()
      
5. 回历月列表
返回为回历月 HijriMonth的列表，1年有12个月。

        let y = HijriYear::from_year(1)
        let months = y.get_months()
      
## 回历月 HijriMonth

回历一年有12个月，分别为：穆哈兰姆月(1月)、色法尔月(2月)、赖比尔·敖外鲁月(3月)、赖比尔·阿色尼月(4月)、主马达·敖外鲁月(5月)、主马达·阿色尼月(6月)、赖哲卜月(7月)、舍尔邦月(8月)、赖买丹月(9月)、闪瓦鲁月(10月)、都尔喀尔德月(11月)、都尔黑哲月(12月)。

### 如何得到回历月？

1. 从回历年、月初始化
参数回历年，支持从-640到9666年；参数回历月，支持1到12。

        let m = HijriMonth::from_ym(1, 1)
      
2. 从回历日 HijriDay得到回历月
        // 1年穆哈兰姆月1日
        let d = HijriDay::from_ymd(1, 1, 1)
        let m = d.get_hijri_month()
      
### 从回历月可以得到些什么？

1. 回历年 HijriYear
        let m = HijriMonth::from_ym(1, 1)
        let y = m.get_hijri_year()
      
2. 月
返回为月份数字，范围为1到12。

        let m = HijriMonth::from_ym(1, 1)
        // 1
        let month = m.get_month()
      
3. 位于当年的月索引
返回为数字，范围0到11。

        let m = HijriMonth::from_ym(1, 1)
        // 0
        let index = m.get_index_in_year()
      
4. 当月的总天数
返回为数字，单数月30天，双数月29天，闰年第12月30天。

        let m = HijriMonth::from_ym(1, 1)
         
        // 30
        let n = m.get_day_count()
      
5. 首日
返回为1日的回历日 HijriDay。

        let m = HijriMonth::from_ym(1, 1)
        let d = m.get_first_day()
      
6. 回历日列表
返回为回历日 HijriDay的列表，从1日开始。

        let m = HijriMonth::from_ym(1, 1)
        let days = m.get_days()
      
## 回历日 HijriDay

公历622年7月16日为回历元年元旦。

### 如何得到回历日？

1. 从回历年、月、日初始化
参数回历年，支持从-640到9666年；参数回历月，支持1到12；参数回历日，支持1到30。

        // 1年穆哈兰姆月1日
        let d = HijriDay::from_ymd(1, 1, 1)
      
2. 从公历日 SolarDay转回历日
        // 公历622年7月16日
        let sd = SolarDay::from_ymd(622, 7, 16)
        // 1年穆哈兰姆月1日
        let d = sd.get_hijri_day()
      
### 从回历日可以得到些什么？

1. 回历月 HijriMonth
        let d = HijriDay::from_ymd(1, 1, 1)
        // 1年穆哈兰姆月
        let m = d.get_hijri_month()
      
2. 日
返回为数字，范围1到30。

        let d = HijriDay::from_ymd(1, 1, 1)
        // 1
        let day = d.get_day()
      
3. 回历日转儒略日 JulianDay
        let d = HijriDay::from_ymd(1, 1, 1)
         
        // 1948440.0
        let julian_day = d.get_julian_day()
      
4. 回历日转公历日 SolarDay
        // 1年穆哈兰姆月1日
        let d = HijriDay::from_ymd(1, 1, 1)
         
        // 622年7月16日
        let sd = d.get_solar_day()
      
5. 回历日前后比较
        let a = HijriDay::from_ymd(1, 1, 1)
        let b = HijriDay::from_ymd(1, 1, 2)

        // a在b之前吗？这里返回true
        let a_is_before_b = a.is_before(b)
         
        // a在b之后吗？这里返回false
        let a_is_after_b = a.is_after(b)
      
6. 回历日相减
返回为两个回历日之间相差的天数。

        // -1
        let days = HijriDay::from_ymd(1, 1, 1).subtract(HijriDay::from_ymd(1, 1, 2))
      
7. 位于当年的月索引
返回为数字，范围0到354。

        // 1年穆哈兰姆月1日
        let d = HijriDay::from_ymd(1, 1, 1)
        // 0
        let i = d.get_index_in_year()
      
## 干支年 SixtyCycleYear

干支年从立春开始，至下个立春前结束。通常在民间，用于八字、流年等。

### 如何得到干支年？

1. 从年初始化
参数为干支年，支持从-1到9999年。

        let y = SixtyCycleYear::from_year(2023)
      
2. 从干支月 SixtyCycle得到干支年
        // 2023年寅月
        let m = SixtyCycleMonth::from_index(2023, 0)
        let y = m.get_sixty_cycle_year()
      
### 从干支年可以得到些什么？

1. 年
返回为干支年数字，范围为-1到9999。

        let y = SixtyCycleYear::from_year(2023)
        // 得到2023
        let year = y.get_year()
      
2. 当年的干支
返回为干支 SixtyCycle。

        let y = SixtyCycleYear::from_year(2023)
        let sc = y.get_sixty_cycle()
      
3. 运
返回为运 Twenty。

        let y = SixtyCycleYear::from_year(2023)
        let t = y.get_twenty()
      
4. 九星
返回为九星 NineStar。

        let y = SixtyCycleYear::from_year(2023)
        let ns = y.get_nine_star()
      
5. 太岁方位
返回为方位 Direction。

        let y = SixtyCycleYear::from_year(2023)
        let d = y.get_jupiter_direction()
      
6. 干支月列表
返回为干支月 SixtyCycleMonth的列表，从寅月到丑月，共12个月。

        let y = SixtyCycleYear::from_year(2023)
        let ms = y.get_months()
      
## 干支月 SixtyCycleMonth

干支月以节令开始，到下个节令前结束。

### 如何得到干支月？

1. 从干支年、月索引初始化
参数干支年，支持从-1到9999年；参数月索引，支持0到11，0代表寅月。

        let m = SixtyCycleMonth::from_index(2023, 0)
      
2. 从干支日 SixtyCycleDay得到干支月
        let d = SolarDay::from_ymd(2023, 1, 1).get_sixty_cycle_day()
        let m = d.get_sixty_cycle_month()
      
### 从干支月可以得到些什么？

1. 干支年
返回为干支年 SixtyCycleYear。

        // 2023年寅月
        let m = SixtyCycleMonth::from_index(2023, 0)
        let y = m.get_sixty_cycle_year()
      
2. 年柱
返回为年的干支 SixtyCycle。

        // 2025年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        // 乙巳
        let y = m.get_year()
      
3. 月柱
返回为月的干支 SixtyCycle。

        // 2025年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        // 戊寅
        let sc = m.get_sixty_cycle()
      
4. 位于当年的月索引
返回为数字，范围0到11，寅月为0，依次类推。

        // 2025年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        // 0
        let i = m.get_index_in_year()
      
5. 九星
返回为九星 NineStar。

        // 2025年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        let ns = m.get_nine_star()
      
6. 太岁方位
返回为方位 Direction。

        // 2025年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        let d = m.get_jupiter_direction()
      
7. 首日
返回为干支日 SixtyCycleDay，即节令当天。

        // 2023年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        let d = m.get_first_day()
      
8. 干支日列表
返回为干支日 SixtyCycleDay的列表，从节令当天开始。

        // 2023年寅月
        let m = SixtyCycleMonth::from_index(2025, 0)
        let days = m.get_days()
      
## 干支日 SixtyCycleDay

### 如何得到干支日？
1. 从干支时辰 SixtyCycleHour得到干支日
        // 农历2023年正月初一 13:00:00对应的干支时辰
        let h = LunarHour::from_ymd_hms(2023, 1, 1, 13, 0, 0).get_sixty_cycle_hour()
        let d = h.get_sixty_cycle_day()
      
2. 从公历日 SolarDay转干支日
        // 公历2024年2月9日
        let d = SolarDay::from_ymd(2024, 2, 9)
        // 甲辰年丙寅月癸卯日
        let scd = d.get_sixty_cycle_day()
      
3. 从农历日 LunarDay转干支日
        // 农历癸卯年十二月三十
        let d = LunarDay::from_ymd(2023, 12, 30)
        // 甲辰年丙寅月癸卯日
        let scd = d.get_sixty_cycle_day()
      
### 从干支日可以得到些什么？

1. 干支月 SixtyCycleMonth
        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        // 丙寅月
        let m = d.get_sixty_cycle_month()
      
2. 年柱
当天所属的干支年干支，以立春换年。返回为干支 SixtyCycle。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        // 甲辰
        let y = d.get_year()
      
3. 月柱
当天所属的干支月干支，以节令换月。返回为干支 SixtyCycle。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        // 丙寅
        let m = d.get_month()
      
4. 日柱
当天的干支，返回为干支 SixtyCycle。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        // 癸卯
        let sc = d.get_sixty_cycle()
      
5. 九星
返回为九星 NineStar。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let ns = d.get_nine_star()
      
6. 太岁方位
返回为方位 Direction。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let jd = d.get_jupiter_direction()
      
7. 建除十二值神
返回为建除十二值神 Duty。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let duty = d.get_duty()
      
8. 黄道黑道十二神
返回为黄道黑道十二神 TwelveStar。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let t = d.get_twelve_star()
      
9. 逐日胎神
返回为逐日胎神 FetusDay。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let f = d.get_fetus_day()
      
10. 二十八宿
返回为二十八宿 TwentyEightStar。

        // 农历癸卯年十二月三十 转干支日 甲辰年丙寅月癸卯日
        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let star = d.get_twenty_eight_star()
      
11. 当天的时辰列表
从23:00开始到23:00之前的12个干支时辰 SixtyCycleHour。

        let d = LunarDay::from_ymd(2023, 12, 30).get_sixty_cycle_day()
        let hours = d.get_hours()
      
12. 三柱
返回为三柱 ThreePillars。

        let d = LunarDay::from_ymd(2023, 1, 1).get_sixty_cycle_day()
        let t = d.get_three_pillars()
      
## 干支时辰 SixtyCycleHour

### 如何得到干支时辰？
1. 从公历时刻 SolarTime转干支时辰
        // 公历2024年2月9日 13:00:00
        let t = SolarTime::from_ymd_hms(2024, 2, 9, 13, 0, 0)
        // 甲辰年丙寅月癸卯日己未时
        let hour = t.get_sixty_cycle_hour()
      
2. 从农历时辰 LunarHour转干支时辰
        // 农历癸卯年十二月三十 13:00:00
        let t = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0)
        // 甲辰年丙寅月癸卯日己未时
        let hour = t.get_sixty_cycle_hour()
      
### 从干支时辰可以得到些什么？

1. 干支日 SixtyCycleDay
        // 农历癸卯年十二月三十 13:00:00 转干支时辰 甲辰年丙寅月癸卯日己未时
        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        // 甲辰年丙寅月癸卯日
        let d = h.get_sixty_cycle_day()
      
2. 位于当天的序号
返回为数字，范围0到11，23:00到00:59为0，以此类推。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 23, 0, 0).get_sixty_cycle_hour()
        // 0
        let index = h.get_index_in_day()
      
3. 年柱
当时所属的干支年干支，以立春具体时刻换年。返回为干支 SixtyCycle。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let y = h.get_year()
      
4. 月柱
当时所属的农历月干支，以节令具体时刻换月。返回为干支 SixtyCycle。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let m = h.get_month()
      
5. 日柱
返回为干支 SixtyCycle。注意：23:00开始为第二天日干支。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let d = h.get_day()
      
6. 时辰干支
返回为干支 SixtyCycle。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let sixty_cycle = h.get_sixty_cycle()
      
7. 九星
返回为九星 NineStar。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let ns = h.get_nine_star()
      
8. 黄道黑道十二神
返回为黄道黑道十二神 TwelveStar。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let ts = h.get_twelve_star()
      
9. 八字
23:00-23:59日干支为明天，返回为八字 EightChar。

        let h = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0).get_sixty_cycle_hour()
        let eight_char = h.get_eight_char()
      
## 公历年 SolarYear

### 如何得到公历年？
1. 从年初始化
参数为公历年，支持从1到9999年。

        let solar_year = SolarYear::from_year(2024)
      
2. 从公历月 SolarMonth得到公历年
        // 公历2024年2月
        let solar_month = SolarMonth::from_ym(2024, 2)
        let solar_year = solar_month.get_solar_year()
      
### 从公历年可以得到些什么？

1. 年
返回为公历年数字，范围为1到9999。

        let solar_year = SolarYear::from_year(2023)
        // 得到2023
        let year = solar_year.get_year()
      
2. 当年的总天数
返回为数字，从1月1日到12月31日的总天数。平年365天，闰年366天，1582年355天。

        let solar_year = SolarYear::from_year(2023)
        // 365
        let day_count = solar_year.get_day_count()
      
3. 当年是否闰年
返回为true/false。

        let solar_year = SolarYear::from_year(2023)
        // false
        let leap = solar_year.is_leap()
      
4. 公历月列表
返回为公历月 SolarMonth的列表，从1月到12月。

        let solar_year = SolarYear::from_year(2023)
        let months = solar_year.get_months()
      
5. 公历半年列表
返回为公历半年 SolarHalfYear的列表，上半年和下半年。

        let solar_year = SolarYear::from_year(2023)
        let half_years = solar_year.get_half_years()
      
6. 公历季度列表
返回为公历季度 SolarSeason的列表，一季度、二季度、三季度和四季度。

        let solar_year = SolarYear::from_year(2023)
        let seasons = solar_year.get_seasons()
      
## 公历半年 SolarHalfYear

公历半年分为：上半年和下半年。

### 如何得到公历半年？

1. 从年初始化
参数为公历年和索引，支持从1到9999年，索引值为0或1，0代表上半年，1代表下半年。

        // 2024年上半年
        let half_year = SolarHalfYear::from_year(2024, 0)
      
### 从公历半年可以得到些什么？

1. 年
返回为公历年数字，范围为1到9999。

        let half_year = SolarHalfYear::from_year(2024, 0)
        // 得到2024
        let year = half_year.get_year()
      
2. 索引
返回为数字，0代表上半年，1代表下半年。

        let half_year = SolarHalfYear::from_year(2024, 0)
        // 0
        let index = half_year.get_index()
      
3. 公历月列表
返回为公历月 SolarMonth的列表，半年为6个月。

        let half_year = SolarHalfYear::from_year(2024, 0)
        let months = half_year.get_months()
      
4. 公历季度列表
返回为公历季度 SolarSeason的列表，半年为2个季度。

        let half_year = SolarHalfYear::from_year(2024, 0)
        let seasons = half_year.get_seasons()
      
## 公历季度 SolarSeason

公历季度分为：一季度、二季度、三季度和四季度。

### 如何得到公历季度？

1. 从年初始化
参数为公历年和索引，支持从1到9999年，索引值为0-3，0代表一季度，3代表四季度。

        // 2024年上半年
        let season = SolarSeason::from_year(2024, 0)
      
2. 从公历月 SolarMonth得到
        let solar_month = SolarMonth::from_ym(2023, 5)
        // 二季度
        let season = solar_month.get_season()
      
### 从公历季度可以得到些什么？

1. 年
返回为公历年数字，范围为1到9999。

        let season = SolarSeason::from_year(2024, 0)
        // 得到2024
        let year = season.get_year()
      
2. 索引
返回为数字0-3，0代表一季度，3代表四季度。

        let season = SolarSeason::from_year(2024, 0)
        // 0
        let index = season.get_index()
      
3. 公历月列表
返回为公历月 SolarMonth的列表，一季度为3个月。

        let season = SolarSeason::from_year(2024, 0)
        let months = season.get_months()
      
## 公历月 SolarMonth

公历1年有12个月，为1月到12月。

### 如何得到公历月？

1. 从公历年、月初始化
参数公历年，支持从1到9999年；参数公历月，支持1到12。

        let solar_month = SolarMonth::from_ym(2023, 5)
      
2. 从公历日 SolarDay得到公历月
        // 公历2023年1月1日
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let solar_month = solar_day.get_solar_month()
      
### 从公历月可以得到些什么？

1. 公历年
返回为公历年 SolarYear。

        let solar_month = SolarMonth::from_ym(2023, 5)
        let solar_year = solar_month.get_solar_year()
      
2. 月
返回为月份数字，范围为1到12。

        let solar_month = SolarMonth::from_ym(2023, 5)
        // 5
        let month = solar_month.get_month()
      
3. 位于当年的月索引
返回为数字，范围0到11，0代表1月，11代表12月。

        let solar_month = SolarMonth::from_ym(2023, 5)
        // 4
        let index = solar_month.get_index_in_year()
      
4. 当月的总天数
返回为数字，1582年10月只有21天，其余根据小学知识可知。

        let solar_month = SolarMonth::from_ym(2023, 5)
        let day_count = solar_month.get_day_count()
      
5. 公历季度
返回为公历季度 SolarSeason。

        let solar_month = SolarMonth::from_ym(2023, 5)
        // 二季度
        let season = solar_month.get_season()
      
6. 当月有几周
参数为起始星期，1234560分别代表星期一至星期天，返回为数字。

        let solar_month = SolarMonth::from_ym(2023, 5)
        let week_count = solar_month.get_week_count(1)
      
7. 当月的周列表
参数为起始星期，1234560分别代表星期一至星期天，返回为公历周 SolarWeek的列表。

        let solar_month = SolarMonth::from_ym(2023, 5)
        let weeks = solar_month.get_weeks(1)
      
8. 公历日列表
返回为公历日 SolarDay的列表，从1日开始。

        let solar_month = SolarMonth::from_ym(2023, 5)
        let days = solar_month.get_days()
      
## 公历周 SolarWeek

公历一个月最多有6个周，分别为：第一周、第二周、第三周、第四周、第五周、第六周。

### 如何得到公历周？

1. 通过公历年月的周索引初始化，参数分别为公历年、公历月、周索引、起始星期（1234560分别代表星期一至星期日）
        // 2023年1月第一周，以星期2为一周的开始
        let solar_week = SolarWeek::from_ym(2023, 1, 0, 2)
      
### 从公历周可以得到些什么？

1. 本周第一天的公历日
返回为公历日 SolarDay。

        let solar_week = SolarWeek::from_ym(2023, 1, 0, 2)
         
        // 2022年12月27日
        let solar_day = solar_week.get_first_day()
      
2. 本周公历日列表
返回为公历日 SolarDay的列表。

        let solar_week = SolarWeek::from_ym(2023, 1, 0, 2)
        let days = solar_week.get_days()
      
3. 位于当年的索引
注意：索引值是从0开始，即0代表第一周

        let solar_week = SolarWeek::from_ym(2023, 1, 0, 2)
        // 0
        let index = solar_week.get_index_in_year()
      
## 公历日 SolarDay

### 如何得到公历日？
1. 从公历年、月、日初始化
参数公历年，支持从1到9999年；参数公历月，支持1到12；参数公历日，支持1到31。

        // 公历2023年1月1日
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
      
2. 从公历时刻 SolarTime得到公历日
        // 公历2023年1月1日 13:00:00
        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        let solar_day = solar_time.get_solar_day()
      
3. 从农历日 LunarDay转公历日
        // 农历癸卯年十二月三十
        let lunar_day = LunarDay::from_ymd(2023, 12, 30)
        // 公历2024年2月9日
        let solar_day = lunar_day.get_solar_day()
      
4. 从儒略日 JulianDay转公历日
`JulianDay` 可以表示超出公历日支持范围的值，因此转换结果为 `Result[SolarDay, String]`，调用方需要显式处理失败。

        let julian_day = JulianDay::from_julian_day(2451545.0)
        // 公历2000年1月1日
        let solar_day = julian_day.get_solar_day().unwrap()
      
### 从公历日可以得到些什么？

1. 公历月 SolarMonth
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        // 1月
        let solar_month = solar_day.get_solar_month()
      
2. 日
返回为数字，范围1到31。

        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        // 1
        let day = solar_day.get_day()
      
3. 星期 Week
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let week = solar_day.get_week()
      
4. 公历周 SolarWeek
获取当天所在的公历周，参数为起始星期，1234560分别代表星期一至星期天。返回 `Result[SolarWeek, String]`；起始星期不在0到6时返回 `Err`。

        let solar_day = SolarDay::from_ymd(2023, 1, 1).unwrap()
        // 2023年1月第一周
        let solar_week = solar_day.get_solar_week(0).unwrap()
      
5. 星座 Constellation
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let constellation = solar_day.get_constellation()
      
6. 当天所在的节气 SolarTerm
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let term = solar_day.get_term()
      
7. 当天所在的七十二候 PhenologyDay
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let phenology_day = solar_day.get_phenology_day()
      
8. 当天所在的三伏天 DogDay
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let dog_day = solar_day.get_dog_day()
      
9. 当天所在的数九天 NineDay
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let nine_day = solar_day.get_nine_day()
      
10. 位于当年的索引
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let index = solar_day.get_index_in_year()
      
11. 公历现代节日
返回为公历现代节日 SolarFestival，当天无节日返回None。

        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        // 元旦
        let festival = solar_day.get_festival()
      
12. 法定假日
返回为法定假日 LegalHoliday，当天不是法定假日返回None。

        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let festival = solar_day.get_legal_holiday()
      
13. 公历日转农历日
返回为农历日 LunarDay。

        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let lunar_day = solar_day.get_lunar_day()
      
14. 公历日转儒略日
返回为儒略日 JulianDay。

        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let julian_day = solar_day.get_julian_day()
      
15. 公历日转回历日
返回为回历日 HijriDay。

        let solar_day = SolarDay::from_ymd(622, 7, 16)
        let hijri_day = solar_day.get_hijri_day()
      
16. 公历日前后比较
        let a = SolarDay::from_ymd(2023, 1, 1)
        let b = SolarDay::from_ymd(2023, 1, 2)

        // a在b之前吗？这里返回true
        let a_is_before_b = a.is_before(b)
         
        // a在b之后吗？这里返回false
        let a_is_after_b = a.is_after(b)
      
17. 公历日相减
返回为两个公历日之间相差的天数。

        // -1
        let days = SolarDay::from_ymd(2023, 1, 1).subtract(SolarDay::from_ymd(2023, 1, 2))
      
18. 当天所在的梅雨天 PlumRainDay
        let solar_day = SolarDay::from_ymd(2024, 6, 11)
        // 入梅第1天
        let plum_rain_day = solar_day.get_plum_rain_day()

        let solar_day2 = SolarDay::from_ymd(2024, 7, 6)
        // 出梅
        let plum_rain_day2 = solar_day2.get_plum_rain_day()

        let solar_day3 = SolarDay::from_ymd(2024, 6, 10)
        // None
        let plum_rain_day3 = solar_day3.get_plum_rain_day()
      
18. 月相
返回为月相 Phase。

        // 蛾眉月
        let phase = SolarDay::from_ymd(2023, 9, 17).get_phase()
      
## 公历时刻 SolarTime

### 如何得到公历时刻？
1. 从公历年、月、日、时、分、秒初始化
参数公历年，支持从1到9999年；参数公历月，支持1到12；参数公历日，支持1到31；时为0-23；分为0-59；秒为0-59。

        // 2023年1月1日 13:00:00
        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 0, 0)
      
2. 从农历时辰 LunarHour转公历时刻
        // 农历癸卯年十二月三十 未时
        let lunar_hour = LunarHour::from_ymd_hms(2023, 12, 30, 13, 0, 0)
        // 2024年2月9日 13:00:00
        let solar_time = lunar_hour.get_solar_time()
      
3. 从儒略日 JulianDay转公历时刻
        let julian_day = JulianDay::from_julian_day(2451545.0)
        // 公历2000年1月1日 12:00:00
        let solar_time = julian_day.get_solar_time()
      
### 从公历时刻可以得到些什么？

1. 公历日 SolarDay
        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 2023年1月1日
        let solar_day = solar_time.get_solar_day()
      
2. 时
返回为数字，范围0到23。

        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 0, 0)
        // 13
        let hour = solar_time.get_hour()
      
3. 分
返回为数字，范围0到59。

        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 0)
        // 5
        let minute = solar_time.get_minute()
      
4. 秒
返回为数字，范围0到59。

        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 20)
        // 20
        let second = solar_time.get_second()
      
5. 当时所在的节气 SolarTerm
        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 20)
        let term = solar_time.get_term()
      
6. 公历时刻转农历时辰
返回为农历时辰 LunarHour。

        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 20)
        let lunar_hour = solar_time.get_lunar_hour()
      
7. 公历时刻转儒略日
返回为儒略日 JulianDay。

        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 20)
        let julian_day = solar_time.get_julian_day()
      
8. 公历时刻前后比较
        let a = SolarTime::from_ymd_hms(2023, 1, 1, 0, 0, 0)
        let b = SolarTime::from_ymd_hms(2023, 1, 1, 1, 0, 0)

        // a在b之前吗？这里返回true
        let a_is_before_b = a.is_before(b)
         
        // a在b之后吗？这里返回false
        let a_is_after_b = a.is_after(b)
      
9. 公历时刻相减
返回为两个公历时刻之间相差的秒数。

        // -3600
        let seconds = SolarTime::from_ymd_hms(2023, 1, 1, 0, 0, 0).subtract(SolarTime::from_ymd_hms(2023, 1, 1, 1, 0, 0))
      
10. 月相
返回为月相 Phase。

        // 蛾眉月
        let phase = SolarTime::from_ymd_hms(2025, 9, 22, 3, 54, 8).get_phase()
      
11. 真太阳时
根据出生地经度将钟表时间（北京时间 UTC+8）转换为真太阳时。参数为经度（东经为正，西经为负，如北京 116.39）。返回为公历时刻 SolarTime。

真太阳时 = 钟表时间 + (经度 - 120°) × 4分钟/度 + 均时差

        let solar_time = SolarTime::from_ymd_hms(2025, 6, 21, 12, 0, 0)
        // 北京（116.39°E）真太阳时
        let true_solar_time = solar_time.to_true_solar_time(116.39)
      
## 生肖 Zodiac轮回

十二生效依次为：鼠、牛、虎、兔、龙、蛇、马、羊、猴、鸡、狗、猪。

### 如何得到生肖？

1. 通过地支 EarthBranch得到
        // 鼠
        let zodiac = EarthBranch::from_name("子").get_zodiac()
      
### 从生肖可以得到些什么？

1. 生肖转地支
返回为地支 EarthBranch。

        let zodiac = Zodiac::from_name("牛")
         
        // 丑
        let earth_branch = zodiac.get_earth_branch()
      
## 月相 Phase轮回

天文学上为了定位天体在天空中的位置，假想了一个以地球为中心的巨大球面，称为"天球"。黄道是太阳在天球上一年中运行的轨迹。黄经就是沿着黄道测量的角度。

月亮和太阳在黄道上的经度之差叫做月日黄经差，它决定了月相。

月相的变化周期（朔望月）就是月日黄经差从0°到360°的变化过程。月相分别为：新月(也有称朔月，月日黄经差0°)、蛾眉月(月日黄经差0°到90°之间)、上弦月(月日黄经差90°)、盈凸月(月日黄经差90°到180°之间)、满月(也有称望月，月日黄经差180°)、亏凸月(月日黄经差180°到270°之间)、下弦月(月日黄经差270°)、残月(月日黄经差270°到360°之间)。

由于农历月以朔望为周期，每月初一固定为朔，即新月。

### 如何得到月相？

1. 通过农历日 LunarDay得到
由于农历日是按一整天，而新月、上弦月、满月、下弦月只是某一时刻短暂的月相，因此出现新月的那一天月相均为新月，第二天开始为蛾眉月，以此类推。

        // 新月
        let phase = LunarDay::from_ymd(2000, 1, 1).get_phase()

        // 蛾眉月
        let phase2 = LunarDay::from_ymd(2000, 1, 2).get_phase()
      
2. 通过公历日 SolarDay得到
由于公历日是按一整天，而新月、上弦月、满月、下弦月只是某一时刻短暂的月相，因此出现新月的那一天月相均为新月，第二天开始为蛾眉月，以此类推。

        // 新月
        let phase = SolarDay::from_ymd(2023, 9, 15).get_phase()

        // 蛾眉月
        let phase2 = SolarDay::from_ymd(2023, 9, 16).get_phase()
      
还可以计算当天的公历日是当前月相的第几天。

        // 新月第1天
        let d = SolarDay::from_ymd(2023, 9, 15).get_phase_day()
         
        // 0
        let index = d.get_day_index()
      
3. 通过公历时刻 SolarTime得到
由于公历时刻精确到秒，因此出现新月的那一秒月相均为新月，下一秒开始为蛾眉月，以此类推。

        // 新月
        let phase = SolarTime::from_ymd_hms(2025, 9, 22, 3, 54, 7).get_phase()

        // 蛾眉月
        let phase2 = SolarTime::from_ymd_hms(2025, 9, 22, 3, 54, 8).get_phase()
      
4. 通过索引值进行初始化
调用from_index(lunar_year, lunar_month, index)得到月相对象。lunar_year为农历年；lunar_month为农历月，闰月传负数；index为数字，从0开始，当索引值越界时，会自动轮回偏移。

        // 2025年七月的第7个月相：下弦月
        let phase = Phase::from_index(2025, 7, 6)
         
        // 该月相起始公历日为：2025年9月14日
        let day = phase.get_solar_day()

        // 该月相起始公历时刻为：2025年9月14日 18:32:57
        let time = phase.get_solar_time()
      
5. 通过名称进行初始化
调用from_name(lunar_year, lunar_month, name)得到月相对象。lunar_year为农历年；lunar_month为农历月，闰月传负数；name为字符串，当名称不存在时，会抛出参数异常。

        // 2025年七月的下弦月
        let phase = Phase::from_name(2025, 7, "下弦月")
         
        // 该月相起始公历日为：2025年9月14日
        let day = phase.get_solar_day()

        // 该月相起始公历时刻为：2025年9月14日 18:32:57
        let time = phase.get_solar_time()
      
## 星座 Constellation轮回

星座依次为：白羊、金牛、双子、巨蟹、狮子、处女、天秤、天蝎、射手、摩羯、水瓶、双鱼。

### 如何得到星座？

1. 通过公历日 SolarDay得到
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let constellation = solar_day.get_constellation()
      
## 节气 SolarTerm轮回

节气依次为：冬至、小寒、大寒、立春、雨水、惊蛰、春分、清明、谷雨、立夏、小满、芒种、夏至、小暑、大暑、立秋、处暑、白露、秋分、寒露、霜降、立冬、小雪、大雪。节气时间精确到秒，算法引自寿星天文历。节气的初始化需要带上公历年份：

1. 通过索引值进行初始化
调用from_index(year, index)得到其对象。year为公历年，当传入2013年时，取到的冬至，实际上是在2012年，这里一定要注意；index为数字，从0开始，当索引值越界时，会自动轮回偏移。

        // 2013年的第1个节气：冬至
        let term = SolarTerm::from_index(2013, 0)
      
2. 通过名称进行初始化
调用from_name(year, name)得到其对象。year为公历年，当传入2013年时，取到的冬至，实际上是在2012年，这里一定要注意；name为字符串，当名称不存在时，会抛出参数异常。

        // 2013年的立春
        let term = SolarTerm::from_name(2013, "立春")
      
3. 通过公历日得到当天所在节气
        let solar_day = SolarDay::from_ymd(2023, 1, 1)
        let term = solar_day.get_term()
      
也可以知道指定公历日位于节气的第几天：

        let solar_day = SolarDay::from_ymd(2023, 12, 7)
         
        // 大雪第1天
        let term_day = solar_day.get_term_day()
         
        // 0
        let day_index = term_day.get_day_index()
      
4. 通过公历时刻得到当时所在节气
        let solar_time = SolarTime::from_ymd_hms(2023, 1, 1, 13, 5, 20)
        let term = solar_time.get_term()
      
### 从节气可以得到些什么？

1. 是否节令
is_jie()返回为true或false。

        let term = SolarTerm::from_name(2013, "冬至")
         
        // false
        let is_jie = term.is_jie()
      
2. 是否气令
is_qi()返回为true或false。

        let term = SolarTerm::from_name(2013, "冬至")
         
        // true
        let is_qi = term.is_qi()
      
3. 儒略日
通过先取得儒略日，再将儒略日转换为公历时刻，可得到精确到秒级的节气时刻，也可将儒略日转换为公历日，得到现代天文算法计算出的精确公历日。

get_julian_day()返回为儒略日 JulianDay。

        let term = SolarTerm::from_name(2013, "冬至")
         
        let julian_day = term.get_julian_day()
      
4. 公历日
直接取得的公历日，在历法不精确的古代，与通过儒略日方式取得的公历日可能存在偏差，在制作日历时建议使用本方法，以符合史实。

get_solar_day()返回为公历日 SolarDay。

        let term = SolarTerm::from_name(2013, "冬至")
         
        let d = term.get_solar_day()
      
## 儒略日 JulianDay

儒略日可以通过以下几种方式得到：

1. 通过儒略日数值进行初始化
调用from_julian_day(jd)得到其对象。jd为小数。

        // 公历2023年1月1日
        let julian_day = JulianDay::from_julian_day(2459945.5)
      
2. 通过公历年月日时分秒进行初始化
调用from_ymd_hms(year, month, day, hour, minute, second)得到其对象。

        let julian_day = JulianDay::from_ymd_hms(2023, 1, 1, 0, 0, 0)
      
3. 通过公历日 SolarDay转换而来。
        let julian_day = SolarDay::from_ymd(2023, 1, 1).get_julian_day()
      
4. 通过公历时刻 SolarTime转换而来。
        let julian_day = SolarTime::from_ymd_hms(2023, 1, 1, 12, 30, 0).get_julian_day()
      
### 从儒略日可以得到些什么？

1. 数值
get_day()返回小数。

        let julian_day = SolarDay::from_ymd(2023, 1, 1).get_julian_day()
         
        // 2459945.5
        let jd = julian_day.get_day()
      
2. 公历日
get_solar_day()返回公历日 SolarDay。

        let julian_day = JulianDay::from_julian_day(2459945.5)
         
        // 2023年1月1日
        let solar_day = julian_day.get_solar_day()
      
3. 公历时刻
get_solar_time()返回公历时刻 SolarTime。

        let julian_day = JulianDay::from_julian_day(2459945.5)
         
        // 2023年1月1日 00:00:00
        let solar_time = julian_day.get_solar_time()
      
4. 星期
通过儒略日计算的星期是最准的，基姆拉尔森和蔡勒公式计算星期的准确性，在儒略日面前都是弟弟，不服来辩。

get_week()返回星期 Week。

        let julian_day = JulianDay::from_julian_day(2459945.5)
         
        // 日
        let week = julian_day.get_week()
      
## 法定假日 LegalHoliday

法定假日有：元旦、春节、清明节、劳动节、端午节、中秋节、国庆节、国庆中秋、抗战胜利日。仅支持2002年(含)至2026年(含)的法定假日。可以通过公历日 SolarDay得到，也可指定年、月、日得到。

        let solar_day = SolarDay::from_ymd(2023, 10, 1)

        // 国庆节
        let holiday = solar_day.get_legal_holiday()
         
        // 国庆节
        let holiday2 = LegalHoliday::from_ymd(2023, 10, 1)
        
        // 非法定假日，返回None
        let holiday3 = LegalHoliday::from_ymd(2023, 4, 20)
      
### 调休怎么判断？

通过调用法定假日的is_work()方法得到当天是否上班。

        // 春节
        let holiday = LegalHoliday::from_ymd(2024, 2, 4)

        // true，代表要上班
        let work = holiday.is_work()
      
### 如何更新法定假日的数据？

法定假日指国家规定的放假和调休安排，来源于国务院办公厅发布的国办发明电文件。可前往http://www.gov.cn/zhengce/xxgk/index.htm搜索节假日。一般是每年11月到12月初发布来年的节假日安排。

目前仅支持从2001年12月29日到2026年12月31日的法定假日安排，一般可以有两种方式更新法定假日数据：

1. Tyme发布新版本时更新，如果未及时更新，欢迎催更。

2. 自己维护节假日数据，可通过LegalHoliday::set_data("节假日数据")来简单粗暴的替换Tyme的所有节假日数据。

数据格式为将每一个法定节假日数据直接拼接为一个长字符串，每个法定假日长度固定位13，如：2001122900+03

8位：yyyyMMdd格式的日期（20011229为2001年12月29日）；
1位：0代表上班，1代表放假（0为上班）；
1位：名称索引，0元旦 1春节 2清明节 3劳动节 4端午节 5中秋节 6国庆节 7国庆中秋 8抗战胜利日（0为元旦）；
1位：+节假日位于当天之后，-节假日位于当天之前（+为元旦在2001年12月29日之后）；
2位：节假日相对于当天的偏移天数，不足10天的需补0（03为元旦在2001年12月29日之后第3天）。
### 如何实现放假倒计时？

通过next(1)获取下一个法定假日，相同假期名称且不上班的，取第一天。

        // 设置最多10条
        let mut size = 10
         
        // 取今天
        let year = 2024
        let today = SolarDay::from_ymd(year, 8, 5)
         
        let mut name : String? = None
        let mut result : Array[LegalHoliday] = []
         
        // 元旦当天肯定放假
        let mut holiday = LegalHoliday::from_ymd(year, 1, 1)
        while holiday is Some(h) && size > 0 {
          let nm = h.get_name()
          if nm != name && not(h.is_work()) && h.get_day().is_after(today) {
            result.push(h)
            name = nm
            size -= 1
          }
          holiday = h.next(1)
        }
         
        for h in result {
          println("距 \{h.get_name()}放假 还有 \{h.get_day().subtract(today) - 1} 天")
        }
      
如果只取一个最近的法定假日，就简单许多。

        // 取今天
        let year = 2024
        let today = SolarDay::from_ymd(year, 8, 5)
         
        // 元旦当天肯定放假
        let mut holiday = LegalHoliday::from_ymd(year, 1, 1)
        while holiday is Some(h) {
          if not(h.is_work()) && h.get_day().is_after(today) {
            println("距 \{h.get_name()}放假 还有 \{h.get_day().subtract(today) - 1} 天")
            break
          }
          holiday = h.next(1)
        }
      
## 公历现代节日 SolarFestival

公历现代节日有：元旦、妇女节、植树节、劳动节、青年节、儿童节、建党节、建军节、教师节、国庆节。可以通过公历日 SolarDay得到，也可指定年、月、日得到，也可指定索引得到。

        // 元旦
        let festival = SolarDay::from_ymd(2023, 1, 1).get_festival()

        // 2023年第1个公历现代节日，元旦
        let festival2 = SolarFestival::from_index(2023, 0)
         
        // 非公历现代节日，返回None
        let festival3 = SolarDay::from_ymd(2023, 1, 20).get_festival()

        // 非公历现代节日，返回None
        let festival4 = SolarFestival::from_ymd(2023, 4, 20)
      
公历现代节日都设有起始年，你可以用get_start_year()得到。

        // 元旦
        let festival = SolarDay::from_ymd(2023, 1, 1).get_festival()
         
        // 1950
        let start_year = festival.get_start_year()
      
公历现代节日没有洋节，如需支持请参考事件 Event。

## 农历传统节日 LunarFestival

农历传统节日有：春节、元宵节、龙头节、上巳节、清明节、端午节、七夕节、中元节、中秋节、重阳节、冬至节、腊八节、除夕。可以通过农历日 LunarDay得到，也可指定农历年、月、日得到，也可指定索引得到。

        // 元宵节
        let festival = LunarDay::from_ymd(2023, 1, 15).get_festival()
         
        // 2023年第1个农历传统节日，春节
        let festival2 = LunarFestival::from_index(2023, 0)
         
        // 非农历传统节日，返回None
        let festival3 = LunarDay::from_ymd(2023, 1, 2).get_festival()

        // 非农历传统节日，返回None
        let festival4 = LunarFestival::from_ymd(2023, 1, 2)
      
## 星期 Week轮回

星期依次为：日、一、二、三、四、五、六。如下代码可指定从周几开始输出一周：

        // 以周一为起点
        let start_index = 1
        let mut week = Week::from_index(start_index)
        for i in 0..<7 {
          println(week)
          // 往后推1天
          week = week.next(1)
        }
      
## 三候 ThreePhenology轮回

每个节气持续15天左右，每隔5天为一候，因此从节气日开始，分别为初候、二候、三候。

### 如何得到三候？

1. 从公历日 SolarDay初始化
        // 初候
        let three_phenology = SolarDay::from_ymd(2020, 4, 23).get_phenology_day().get_phenology().get_three_phenology()
      
## 三伏天 DogDay

三伏，是初伏、中伏和末伏的统称，是一年中最热的时节。

民谚云："夏至三庚入伏，冬至逢壬数九。"

三伏即是从夏至后第3个庚日算起，初伏为10天，中伏为10天或20天，末伏为10天。当夏至与立秋之间出现4个庚日时中伏为10天，出现5个庚日则为20天。

### 如何得到三伏天？

1. 从公历日 SolarDay初始化
        // 末伏第2天
        let dog_day = SolarDay::from_ymd(2012, 8, 8).get_dog_day()
      
## 三柱 ThreePillars

三柱，分别为干支形式的年柱、月柱、日柱的集合。

### 如何得到三柱？

1. 从年干支、月干支、日干支初始化
参数为年干支、月干支、日干支，可以同为字符串，也可同为干支 SixtyCycle对象。

        // 初始化方式一
        let t = ThreePillars::new("丁丑", "癸卯", "癸丑")
         
        // 初始化方式二
        let t2 = ThreePillars::new(
          SixtyCycle::from_name("丁丑"),
          SixtyCycle::from_name("癸卯"),
          SixtyCycle::from_name("癸丑")
        )
      
2. 从农历日 LunarDay得到三柱
        // 农历2025年九月十一，三柱为：乙巳 丙戌 癸酉
        let t = LunarDay::from_ymd(2025, 9, 11).get_three_pillars()
      
3. 从干支日 SixtyCycleDay得到三柱
        // 公历2025年10月31日，三柱为：乙巳 丙戌 癸酉
        let t = SolarDay::from_ymd(2025, 10, 31).get_sixty_cycle_day().get_three_pillars()
      
### 从三柱可以得到些什么？

1. 三柱反推公历日列表
get_solar_days(start_year, end_year)，参数start_year为开始年份，支持1-9999年；参数end_year为结束年份，支持1-9999年。返回为公历日 SolarDay的列表。

三柱由于只能精确到日，所以主要应用于日历的反推，节气算法在不同时期不同，现代采用定气天文推算，古代某些时期采用平气修正，某些时期采用定气修正。

        // 1937年3月27日、1997年3月12日
        let days = ThreePillars::new("丁丑", "癸卯", "癸丑").get_solar_days(1900, 2024)
      
2. 年柱
get_year()，返回为干支 SixtyCycle。

        let t = ThreePillars::new("丁丑", "癸卯", "癸丑")
        // 丁丑
        let year = t.get_year()
      
3. 月柱
get_month()，返回为干支 SixtyCycle。

        let t = ThreePillars::new("丁丑", "癸卯", "癸丑")
        // 癸卯
        let month = t.get_month()
      
4. 日柱
get_day()，返回为干支 SixtyCycle。

        let t = ThreePillars::new("丁丑", "癸卯", "癸丑")
        // 癸丑
        let day = t.get_day()
      
## 五行 Element轮回

五行依次为：木、火、土、金、水。

1. 我生的
        let me = Element::from_name("火")
         
        // 土 （火生土）
        let el = me.get_reinforce()
      
2. 我克的
        let me = Element::from_name("金")
         
        // 木 （金克木）
        let el = me.get_restrain()
      
3. 生我的
        let me = Element::from_name("土")
         
        // 火 （火生土）
        let el = me.get_reinforced()
      
4. 克我的
        let me = Element::from_name("木")
         
        // 金 （金克木）
        let el = me.get_restrained()
      
## 六曜 SixStar轮回

六曜是中国传统历法中的一种注文，用以标示每日的凶吉。它起源于中国，据传由诸葛亮首创，称为"孔明六曜星"，主要用于军事韬略。但实际上，六曜是否形成于三国时期尚无定论，另一说认为六曜为唐代李淳风所创。后来传至日本，并于当地流行，在中国则日渐式微。历代版本有所转变，现时的版本分为先胜、友引、先负、佛灭、大安和赤口六种。

大安是六曜中最为吉利的一天，可以说在一整天的任何时间段都是吉利的。

友引仅次于大吉，仅在正午（11时-13时）为凶。

先胜和先负为一对，分别为上午吉和下午吉。上午吉，因此叫作先胜（早即赢），上午不吉，因此叫作先负（早即输）。日本人认为先胜日很适合博一把赌输赢，因此会把运动会和各类比赛放到这一天。而在先负日则期待平稳度过。

赤口被认为是凶日，做什么都不好，只有在短暂的正午(11时-13时)是吉利的。

佛灭则是六曜当中最不吉利的一天。

        // 友引
        let six_star = SolarDay::from_ymd(2020, 4, 10).get_lunar_day().get_six_star()
      
## 小六壬 MinorRen轮回

小六壬是一种传统的中国占卜方法，它使用一种特殊的掌诀系统来预测未来的事件。小六壬的占卜过程涉及六个掌诀位，分别是大安、留连、速喜、赤口、小吉和空亡，这些掌诀位代表了占卜的不同结果和事物的吉凶。

### 如何得到小六壬？

1. 从农历月 LunarMonth、农历日 LunarDay、农历时辰 LunarHour得到
        // 速喜
        let minor_ren = LunarMonth::from_ym(1991, 3).get_minor_ren()

        // 大安
        let minor_ren2 = LunarDay::from_ymd(2024, 3, 5).get_minor_ren()

        // 留连
        let minor_ren3 = LunarHour::from_ymd_hms(2024, 9, 7, 10, 0, 0).get_minor_ren()
      
### 从小六壬可以得到些什么？

1. 吉凶 Luck
大安、速喜、小吉为吉，留连、赤口、空亡为凶。

        // 大安
        let minor_ren = LunarDay::from_ymd(2024, 3, 5).get_minor_ren()

        // 吉
        let luck = minor_ren.get_luck()
      
2. 五行 Element
        // 大安
        let minor_ren = LunarDay::from_ymd(2024, 3, 5).get_minor_ren()

        // 木
        let element = minor_ren.get_element()
      
## 七曜 SevenStar轮回

也称七政、七纬、七耀，与星期一一对应，分别为：日、月、火、水、木、金、土。以下为七曜和星期的相互转换示例：

        // 二
        let week = Week::from_index(2)
        // 火
        let seven_star = week.get_seven_star()
         
        let seven_star2 = SevenStar::from_name("土")
        // 六
        let week2 = seven_star2.get_week()
      
## 八字 EightChar

所谓八字，就是出生年、月、日、时辰的干支(分别称年柱、月柱、日柱、时柱)，共8个字。

### 如何得到八字？

1. 从四柱初始化
参数为年干支、月干支、日干支、时干支，可以同为字符串，也可同为干支 SixtyCycle对象。

        // 初始化方式一
        let eight_char = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉")
         
        // 初始化方式二
        let eight_char2 = EightChar::new(
          SixtyCycle::from_name("丁丑"),
          SixtyCycle::from_name("癸卯"),
          SixtyCycle::from_name("癸丑"),
          SixtyCycle::from_name("辛酉")
        )
      
2. 从时辰 LunarHour得到八字（默认23:00-23:59日干支为明天）
        // 2023年正月初一 10:00:00的八字
        let eight_char = LunarHour::from_ymd_hms(2023, 1, 1, 10, 0, 0).get_eight_char()
      
由于有的流派认为23:00-23:59日干支为当天，有的流派则认为应该算明天，可通过EightCharProvider来切换，默认支持以下几种方式，你也可以自定义。(切换后会影响八字转公历时刻的结果)

a. 默认（23:00-23:59日干支为明天，对应Lunar流派1）
        LunarHour::set_provider(DefaultEightCharProvider)
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 23, 0, 0)
        let eight_char = lunar_hour.get_eight_char()
      
b. Lunar流派2（23:00-23:59日干支为当天）
        LunarHour::set_provider(LunarSect2EightCharProvider)
        let lunar_hour = LunarHour::from_ymd_hms(2023, 1, 1, 23, 0, 0)
        let eight_char = lunar_hour.get_eight_char()
      
c. 自定义
实现EightCharProvider trait。

        // 实现EightCharProvider trait
        struct MyEightCharProvider {
          // 实现get_eight_char方法
        }
        impl EightCharProvider for MyEightCharProvider {
          // ...
        }
         
        LunarHour::set_provider(MyEightCharProvider{})
      
### 从八字可以得到些什么？

1. 八字转公历时刻列表
get_solar_times(start_year, end_year)，参数start_year为开始年份，支持1-9999年；参数end_year为结束年份，支持1-9999年。返回为公历时刻 SolarTime的列表。

        // 1937年3月27日 18:00:00、1997年3月12日 18:00:00
        let solar_times = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉").get_solar_times(1900, 2024)
      
2. 年柱
get_year()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉")
        // 丁丑
        let year = eight_char.get_year()
      
3. 月柱
get_month()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉")
        // 癸卯
        let month = eight_char.get_month()
      
4. 日柱
get_day()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉")
        // 癸丑
        let day = eight_char.get_day()
      
5. 时柱
get_hour()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("丁丑", "癸卯", "癸丑", "辛酉")
        // 辛酉
        let hour = eight_char.get_hour()
      
5. 胎元
get_fetal_origin()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉")
        // 壬子
        let fetal_origin = eight_char.get_fetal_origin()
      
6. 胎息
get_fetal_breath()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉")
        // 甲寅
        let fetal_breath = eight_char.get_fetal_breath()
      
7. 命宫
get_own_sign()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉")
        // 癸亥
        let own_sign = eight_char.get_own_sign()
      
8. 身宫
get_body_sign()，返回为干支 SixtyCycle。

        let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉")
        // 己未
        let body_sign = eight_char.get_body_sign()
      
9. 建除十二值神(已废弃)
get_duty()，返回为建除十二值神 Duty。

        let eight_char = EightChar::new("癸卯", "辛酉", "己亥", "癸酉")
        let duty = eight_char.get_duty()
      
## 九野 Land轮回

九野和方位一一对应，依次为：玄天、朱天、苍天、阳天、钧天、幽天、颢天、变天、炎天。

### 从九野可以得到些什么？

1. 方位
get_direction()返回为方位 Direction。

        let land = Land::from_name("玄天")
         
        // 北
        let direction = land.get_direction()
      
## 九星 NineStar轮回

九星指北斗九星，我们熟知的北斗七星(天枢、天璇、天玑、天权、玉衡、开阳、摇光)，在古代实际上有9颗，而随着时间的推移，另外2颗(洞明、隐元)逐渐暗淡，人眼已经不容易观察到。

### 如何得到九星？

1. 通过农历年 LunarYear得到年九星
        // 三碧木
        let nine_star = LunarYear::from_year(2024).get_nine_star()
      
2. 通过农历月 LunarMonth得到月九星
        // 二黑土
        let nine_star = LunarMonth::from_ym(2024, 4).get_nine_star()
      
3. 通过农历日 LunarDay得到日九星
        // 六白金
        let nine_star = LunarDay::from_ymd(2024, 4, 13).get_nine_star()
      
4. 通过农历时辰 LunarHour得到时九星
        // 九紫火
        let nine_star = LunarHour::from_ymd_hms(2024, 4, 13, 21, 55, 0).get_nine_star()
      
### 从九星可以得到些什么？

1. 颜色
        
        let nine_star = LunarYear::from_year(2024).get_nine_star()
        // 碧
        let color = nine_star.get_color()
      
2. 五行
        
        let nine_star = LunarYear::from_year(2024).get_nine_star()
        // 木
        let element = nine_star.get_element()
      
3. 方位
        
        let nine_star = LunarYear::from_year(2024).get_nine_star()
        // 东
        let direction = nine_star.get_direction()
      
4. 北斗九星
        
        let nine_star = LunarYear::from_year(2024).get_nine_star()
        // 天玑
        let dipper = nine_star.get_dipper()
      
## 北斗九星 Dipper轮回

北斗九星分别为：天枢、天璇、天玑、天权、玉衡、开阳、摇光、洞明、隐元。

### 如何得到北斗九星？

1. 通过九星 NineStar得到
        // 天玑
        let dipper = LunarYear::from_year(2024).get_nine_star().get_dipper()
      
## 数九天 NineDay

数九，又称冬九九，是中国民间一种计算寒天与春暖花开日期的方法。一般"三九、四九"是一年中最冷的时段。当数到九个"九天"（九九八十一天），便春深日暖、万物生机盎然，是春耕的时候了。

民谚云："夏至三庚入伏，冬至逢壬数九。"

数九即是从冬至逢壬日算起，每九天算一"九"。但是大部分人都不知道壬日是哪一天，就干脆采用按冬至日作为一九的开始了。这里的算法也是按冬至日起算。

还记得小时候学的数九歌吗？

一九二九不出手，三九四九冰上走，五九六九沿河看柳，七九河开，八九燕来，九九加一九，耕牛遍地走。

### 如何得到数九天？

1. 从公历日 SolarDay初始化
        // 一九第2天
        let nine_day = SolarDay::from_ymd(2020, 12, 22).get_nine_day()
      
## 十神 TenStar轮回

十神是根据两个天干之间的五行关系得出的。生我者，正印偏印。我生者，伤官食神。克我者，正官七杀。我克者，正财偏财。同我者，劫财比肩。

        // 比肩
        let ten_star = HeavenStem::from_name("甲").get_ten_star(HeavenStem::from_name("甲"))
      
## 长生十二神 Terrain轮回

长生十二神又叫地势，是天干和地支之间的关系得出的。分别为：长生、沐浴、冠带、临官、帝旺、衰、病、死、墓、绝、胎、养。

        // 沐浴
        let terrain = HeavenStem::from_name("癸").get_terrain(EarthBranch::from_name("寅"))
      
## 建除十二值神 Duty轮回

建除十二值神依次为：建、除、满、平、定、执、破、危、成、收、开、闭。

### 如何得到建除十二值神？

1. 从农历日 LunarDay得到
        // 农历2021年正月初一的建除十二值神
        let duty = LunarDay::from_ymd(2021, 1, 1).get_duty()
      
2. 从八字 EightChar得到
有些场景需要以节令切换的时刻区分，节令切换当天则会有两个值神，就需要从八字获取。

        // 农历2021年正月初一 13:00:00的建除十二值神
        let duty = LunarHour::from_ymd_hms(2021, 1, 1, 13, 0, 0).get_eight_char().get_duty()
      
## 黄道黑道十二神 TwelveStar轮回

黄道黑道十二神依次为：青龙、明堂、天刑；朱雀、金贵、天德；白虎、玉堂、天牢；玄武、司命、勾陈。

### 从黄道黑道十二神可以得到些什么？

1. 黄道黑道
get_ecliptic()返回为黄道黑道 Ecliptic。

        let twelve_star = TwelveStar::from_name("青龙")
         
        // 黄道
        let ecliptic = twelve_star.get_ecliptic()
      
## 黄道黑道 Ecliptic轮回

黄道黑道就两种，依次为：黄道、黑道。

### 从黄道黑道可以得到些什么？

1. 吉凶
get_luck()返回为吉凶 Luck。

        let ecliptic = Ecliptic::from_name("黄道")
         
        // 吉
        let luck = ecliptic.get_luck()
      
## 二十八宿 TwentyEightStar轮回

二十八宿，是黄道附近的二十八组星象总称。上古时代人们根据日月星辰的运行轨迹和位置，把黄道附近的星象划分为二十八组，俗称二十八宿，包括：


        东方七宿：角、亢、氐、房、心、尾、箕；
        北方七宿：斗、牛、女、虚、危、室、壁；
        西方七宿：奎、娄、胃、昴、毕、觜、参；
        南方七宿：井、鬼、柳、星、张、翼、轸。
      
### 从二十八宿可以得到些什么？

1. 七曜
get_seven_star()返回为七曜 SevenStar。

        // 农历日
        let d = LunarDay::from_ymd(2020, 4, 13)
         
        // 翼
        let star = d.get_twenty_eight_star()
         
        // 火
        let seven_star = star.get_seven_star()
      
2. 九野
get_land()返回为九野 Land。

        // 农历日
        let d = LunarDay::from_ymd(2020, 4, 13)
         
        // 翼
        let star = d.get_twenty_eight_star()
         
        // 阳天
        let land = star.get_land()
      
3. 宫
get_zone()返回为宫 Zone。

        // 农历日
        let d = LunarDay::from_ymd(2020, 4, 13)
         
        // 翼
        let star = d.get_twenty_eight_star()
         
        // 南
        let zone = star.get_zone()
      
4. 动物
get_animal()返回为动物 Animal。

        let d = LunarDay::from_ymd(2020, 4, 13)

        // 翼
        let star = d.get_twenty_eight_star()
         
        // 蛇
        let animal = star.get_animal()
      
5. 吉凶
get_luck()返回为吉凶 Luck。

        // 农历日
        let d = LunarDay::from_ymd(2020, 4, 13)
         
        // 翼
        let star = d.get_twenty_eight_star()
         
        // 吉
        let luck = star.get_luck()
      
## 七十二候 PhenologyDay

七十二候，是我国古代用来指导农事活动的历法补充。它是根据黄河流域的地理、气候、和自然界的一些景象编写而成，以五日为候，三候为气，六气为时，四时为岁，一年"二十四节气"共七十二候。各候均以一个物候现象相应，称"候应"。其中植物候应有植物的幼芽萌动、开花、结实等；动物候应有动物的始振、始鸣、交配、迁徙等；非生物候应有始冻、解冻、雷始发声等。七十二候"候应"的依次变化，反映了一年中物候和气候变化的一般情况。

### 如何得到七十二候？

1. 从公历日 SolarDay初始化
        // 萍始生第5天
        let phenology_day = SolarDay::from_ymd(2020, 4, 23).get_phenology_day()
      
如果不需要知道是第几天，可以直接使用候 Phenology，也代表七十二候。

1. 通过索引值进行初始化
调用from_index(year, index)得到其对象。year为公历年，注意公历年的候其实是从上一年年底就开始了；index为数字，从0开始，当索引值越界时，会自动轮回偏移。

        // 2026年的第2个候：麋角解
        let p = Phenology::from_index(2026, 1)
      
2. 通过名称进行初始化
调用from_name(year, name)得到其对象。year为公历年，注意公历年的候其实是从上一年年底就开始了；name为字符串，当名称不存在时，会抛出参数异常。

        // 2026年的麋角解
        let p = Phenology::from_name(2026, "麋角解")
      
3. 通过公历日得到当天所在候
        let d = SolarDay::from_ymd(2025, 12, 26)
        let p = d.get_phenology()
         
        // 等同
        let p2 = d.get_phenology_day().get_phenology()
      
也可以知道指定公历日位于候的第几天：

        let d = SolarDay::from_ymd(2025, 12, 26)
         
        // 麋角解第1天
        let pd = d.get_phenology_day()
         
        // 0
        let day_index = pd.get_day_index()
      
4. 通过公历时刻得到当时所在候
        let t = SolarTime::from_ymd_hms(2025, 12, 26, 20, 49, 36)
        let p = t.get_phenology()
      
## 干支 SixtyCycle轮回

干支，又叫六十甲子、六十干支周，依次为：甲子、乙丑、丙寅、丁卯、戊辰、己巳、庚午、辛未、壬申、癸酉、甲戌、乙亥、丙子、丁丑、戊寅、己卯、庚辰、辛巳、壬午、癸未、甲申、乙酉、丙戌、丁亥、戊子、己丑、庚寅、辛卯、壬辰、癸巳、甲午、乙未、丙申、丁酉、戊戌、己亥、庚子、辛丑、壬寅、癸卯、甲辰、乙巳、丙午、丁未、戊申、己酉、庚戌、辛亥、壬子、癸丑、甲寅、乙卯、丙辰、丁巳、戊午、己未、庚申、辛酉、壬戌、癸亥。

### 从干支可以得到些什么？

1. 天干
返回为天干 HeavenStem。

        let sixty_cycle = SixtyCycle::from_index(1)

        // 乙
        let heaven_stem = sixty_cycle.get_heaven_stem()
      
2. 地支
返回为地支 EarthBranch。

        let sixty_cycle = SixtyCycle::from_index(1)

        // 丑
        let earth_branch = sixty_cycle.get_earth_branch()
      
3. 纳音
返回为纳音 Sound。

        let sixty_cycle = SixtyCycle::from_index(1)

        // 海中金
        let sound = sixty_cycle.get_sound()
      
4. 彭祖百忌
返回为彭祖百忌 PengZu。

        let sixty_cycle = SixtyCycle::from_index(1)

        // 乙不栽植千株不长 丑不冠带主不还乡
        let peng_zu = sixty_cycle.get_peng_zu()
      
5. 旬
返回为旬 Ten。

        let sixty_cycle = SixtyCycle::from_name("乙卯")

        // 甲寅
        let ten = sixty_cycle.get_ten()
      
6. 旬空
也称空亡，10天干与12地支匹配，必定会多出来2个地支，这2个即为旬空。返回为地支 EarthBranch。

        let sixty_cycle = SixtyCycle::from_name("甲子")

        // 戌, 亥
        let extra_earth_branches = sixty_cycle.get_extra_earth_branches()
      
## 天干 HeavenStem轮回

天干也叫天元，依次为：甲、乙、丙、丁、戊、己、庚、辛、壬、癸。

### 从天干可以得到些什么？

1. 五行
返回为五行 Element。

        let heaven_stem = HeavenStem::from_name("丙")
         
        // 火
        let element = heaven_stem.get_element()
      
2. 阴阳
返回为阴阳 YinYang。

        let heaven_stem = HeavenStem::from_name("甲")
         
        // 阳
        let yin_yang = heaven_stem.get_yin_yang()
      
3. 方位
返回为方位 Direction。

        let heaven_stem = HeavenStem::from_name("甲")
         
        // 方位：东
        let direction = heaven_stem.get_direction()
         
        // 喜神方位（《喜神方位歌》甲己在艮乙庚乾，丙辛坤位喜神安。丁壬只在离宫坐，戊癸原在在巽间。）
        let direction2 = heaven_stem.get_joy_direction()
         
        // 阳贵神方位（《阳贵神歌》甲戊坤艮位，乙己是坤坎，庚辛居离艮，丙丁兑与乾，震巽属何日，壬癸贵神安。）
        let direction3 = heaven_stem.get_yang_direction()
         
        // 阴贵神方位（《阴贵神歌》甲戊见牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸蛇兔藏，庚辛逢虎马，此是贵神方。）
        let direction4 = heaven_stem.get_yin_direction()
         
        // 财神方位（《财神方位歌》甲乙东北是财神，丙丁向在西南寻，戊己正北坐方位，庚辛正东去安身，壬癸原来正南坐，便是财神方位真。）
        let direction5 = heaven_stem.get_wealth_direction()
         
        // 福神方位（《福神方位歌》甲乙东南是福神，丙丁正东是堪宜，戊北己南庚辛坤，壬在乾方癸在西。）
        let direction6 = heaven_stem.get_mascot_direction()
      
4. 天干彭祖百忌
返回为天干彭祖百忌 PengZuHeavenStem。

        let heaven_stem = HeavenStem::from_name("甲")
         
        // 甲不开仓财物耗散
        let peng_zu_heaven_stem = heaven_stem.get_peng_zu_heaven_stem()
      
5. 十神
调用get_ten_star(heaven_stem)得到十神，参数为天干 HeavenStem ，返回为十神 TenStar。十神是通过五行判断，规则为：生我者，正印偏印。我生者，伤官食神。克我者，正官七杀。我克者，正财偏财。同我者，劫财比肩。

        // 日元(日主)
        let me = HeavenStem::from_name("癸")
         
        // 正财
        let ten_star = me.get_ten_star(HeavenStem::from_name("丙"))
      
6. 长生十二神(地势)
调用get_terrain(earth_branch)得到长生十二神，参数为地支 EarthBranch ，返回为长生十二神 Terrain。长生十二神可通过不同的组合，得到自坐和星运。

        // 八字
        let eight_char = EightChar::new("丙寅", "癸巳", "癸酉", "己未")

        // 日元(日主)：癸
        let me = eight_char.get_day().get_heaven_stem()
         
        // 年柱星运：沐浴
        let terrain = me.get_terrain(eight_char.get_year().get_earth_branch())

        // 月柱
        let month = eight_char.get_month()

        // 月柱自坐：胎
        let terrain2 = month.get_heaven_stem().get_terrain(month.get_earth_branch())
      
7. 五合
甲己合，乙庚合，丙辛合，丁壬合，戊癸合。调用get_combine()，返回为天干 HeavenStem。

        let heaven_stem = HeavenStem::from_name("甲")
         
        // 己
        let combine_heaven_stem = heaven_stem.get_combine()
      
8. 合化
甲己合化土，乙庚合化金，丙辛合化水，丁壬合化木，戊癸合化火。调用combine(target)，参数为天干 HeavenStem ，返回为五行 Element。如果无法合化，返回None。

        let heaven_stem = HeavenStem::from_name("甲")
         
        // 土
        let element = heaven_stem.combine(HeavenStem::from_name("己"))
      
## 地支 EarthBranch轮回

地支也叫地元，依次为：子、丑、寅、卯、辰、巳、午、未、申、酉、戌、亥。

### 从地支可以得到些什么？

1. 五行
返回为五行 Element。

        let earth_branch = EarthBranch::from_name("寅")
         
        // 木
        let element = earth_branch.get_element()
      
2. 阴阳
返回为阴阳 YinYang。

        let earth_branch = EarthBranch::from_name("子")
         
        // 阳
        let yin_yang = earth_branch.get_yin_yang()
      
3. 方位
返回为方位 Direction。

        let earth_branch = EarthBranch::from_name("子")
         
        // 方位：北
        let direction = earth_branch.get_direction()
      
4. 地支彭祖百忌
返回为地支彭祖百忌 PengZuEarthBranch。

        let earth_branch = EarthBranch::from_name("子")
         
        // 子不问卜自惹祸殃
        let peng_zu_earth_branch = earth_branch.get_peng_zu_earth_branch()
      
5. 生肖
返回为生肖 Zodiac。

        let earth_branch = EarthBranch::from_name("子")
         
        // 鼠
        let zodiac = earth_branch.get_zodiac()
      
6. 六冲
子午冲，丑未冲，寅申冲，辰戌冲，卯酉冲，巳亥冲。get_opposite()返回为地支 EarthBranch。

        let earth_branch = EarthBranch::from_name("子")
         
        // 午
        let opposite_earth_branch = earth_branch.get_opposite()
      
7. 六合
子丑合，寅亥合，卯戌合，辰酉合，巳申合，午未合。get_combine()返回为地支 EarthBranch。

        let earth_branch = EarthBranch::from_name("子")
         
        // 丑
        let combine_earth_branch = earth_branch.get_combine()
      
8. 六害
子未害、丑午害、寅巳害、卯辰害、申亥害、酉戌害。get_harm()返回为地支 EarthBranch。

        let earth_branch = EarthBranch::from_name("子")
         
        // 未
        let harm_earth_branch = earth_branch.get_harm()
      
9. 合化
子丑合化土，寅亥合化木，卯戌合化火，辰酉合化金，巳申合化水，午未合化土。combine(target)，target参数为地支 EarthBranch，返回为五行 Element。如果无法合化，返回None。

        let earth_branch = EarthBranch::from_name("子")
         
        // 土
        let element = earth_branch.combine(EarthBranch::from_name("丑"))
      
10. 煞
逢巳日、酉日、丑日必煞东；亥日、卯日、未日必煞西；申日、子日、辰日必煞南；寅日、午日、戌日必煞北。get_ominous()返回为方位 Direction。

        let earth_branch = EarthBranch::from_name("子")
         
        // 南
        let direction = earth_branch.get_ominous()
      
11. 藏干之本气(主气)
get_hide_heaven_stem_main()返回为天干 HeavenStem。

        let earth_branch = EarthBranch::from_name("子")
         
        // 癸
        let heaven_stem = earth_branch.get_hide_heaven_stem_main()
      
12. 藏干之中气
get_hide_heaven_stem_middle()返回为天干 HeavenStem，无中气的返回None。

        let earth_branch = EarthBranch::from_name("寅")
         
        // 丙
        let heaven_stem = earth_branch.get_hide_heaven_stem_middle()
      
13. 藏干之余气
get_hide_heaven_stem_residual()返回为天干 HeavenStem，无余气的返回None。

        let earth_branch = EarthBranch::from_name("寅")
         
        // 戊
        let heaven_stem = earth_branch.get_hide_heaven_stem_residual()
      
14. 藏干列表
get_hide_heaven_stems()返回为藏干 HideHeavenStem的列表，注意：有些可能缺少中气或余气。

        let earth_branch = EarthBranch::from_name("寅")
         
        // 癸, 丙, 戊
        let hide_heaven_stems = earth_branch.get_hide_heaven_stems()
      
## 藏干 HideHeavenStem

‌‌地支藏干也叫人元，是指地支中包藏着天干，每一个地支里都藏着一至三个天干‌。遁藏的天干依据其力量强弱，可以分为本气、中气以及余气。

### 如何得到藏干？

1. 从地支 EarthBranch得到藏干列表
        let earth_branch = EarthBranch::from_name("寅")
         
        // 癸, 丙, 戊
        let hide_heaven_stems = earth_branch.get_hide_heaven_stems()
      
2. 从人元司令分野 HideHeavenStemDay得到藏干
        let hide_heaven_stem_day = SolarDay::from_ymd(2024, 12, 4).get_hide_heaven_stem_day()
         
        // 壬
        let hide_heaven_stem = hide_heaven_stem_day.get_hide_heaven_stem()
      
### 从藏干可以得到些什么？

1. 天干
返回为天干 HeavenStem。

        let hide_heaven_stem_day = SolarDay::from_ymd(2024, 12, 4).get_hide_heaven_stem_day()
         
        let hide_heaven_stem = hide_heaven_stem_day.get_hide_heaven_stem()
         
        // 壬
        let heaven_stem = hide_heaven_stem.get_heaven_stem()
      
2. 藏干类型
返回为藏干类型 HideHeavenStemType。

        let hide_heaven_stem_day = SolarDay::from_ymd(2024, 12, 4).get_hide_heaven_stem_day()
         
        let hide_heaven_stem = hide_heaven_stem_day.get_hide_heaven_stem()
         
        // 本气
        let hide_heaven_stem_type = hide_heaven_stem.get_type()
      
## 人元司令分野 HideHeavenStemDay

‌‌人元司令分野是指在八字命理学中，将每个月份中五行之气各自司职当令的情况，以及这些气在该月内轮流管理的天数进行详细划分的一种方法。具体来说，人元司令分野涉及余气、中气、本气三种五行之气的轮流司令。每个月份或节气区间内，这三种气各自占据一定的天数，共同构成了该月的五行力量分布。

### 如何得到人元司令分野？

1. 从公历日 SolarDay得到人元司令分野
        // 壬水第16天
        let hide_heaven_stem_day = SolarDay::from_ymd(2024, 12, 4).get_hide_heaven_stem_day()
      
### 从人元司令分野可以得到些什么？

1. 藏干
get_hide_heaven_stem()返回为藏干 HideHeavenStem。

        let hide_heaven_stem_day = SolarDay::from_ymd(2024, 12, 4).get_hide_heaven_stem_day()
         
        // 壬
        let hide_heaven_stem = hide_heaven_stem_day.get_hide_heaven_stem()
      
2. 天索引（节气后第几天）
get_day_index()返回为当令天干在节气后的第几天（0 起，节气当天为 0）。上例"壬水第16天"即 day_index = 15。

        // 15
        let day_index = hide_heaven_stem_day.get_day_index()
      
## 真黄经人元司令分野 EclipticHideHeavenStemDay

‌‌真黄经人元司令分野与按日划分的人元司令分野（HideHeavenStemDay）对应：不按"节气后第几天"计数，而是直接以太阳视黄经（真黄经 + 黄经章动 + 光行差修正，含章动与光行差）的度数划分司令分野。每个节令起黄经 315°（立春）每 30° 为一令，令内按司令段（第1/2/3段）划分，每段占据固定度数。

月令黄经起点与司令段划分：

| 月令 | 黄经起点 | 第1段 | 第2段 | 第3段 |
|------|---------|-------|-------|-------|
| 寅（立春） | 315° | 戊 7° | 丙 7° | 甲 16° |
| 卯（惊蛰） | 345° | 甲 10° | — | 乙 20° |
| 辰（清明） | 15° | 乙 9° | 癸 3° | 戊 18° |
| 巳（立夏） | 45° | 戊 5° | 庚 9° | 丙 16° |
| 午（芒种） | 75° | 丙 10° | 己 9° | 丁 11° |
| 未（小暑） | 105° | 丁 9° | 乙 3° | 己 18° |
| 申（立秋） | 135° | 戊 10° | 壬 3° | 庚 17° |
| 酉（白露） | 165° | 庚 10° | — | 辛 20° |
| 戌（寒露） | 195° | 辛 9° | 丁 3° | 戊 18° |
| 亥（立冬） | 225° | 戊 7° | 甲 5° | 壬 18° |
| 子（大雪） | 255° | 壬 10° | — | 癸 20° |
| 丑（小寒） | 285° | 癸 9° | 辛 3° | 己 18° |

### 与按日版（HideHeavenStemDay）的差异

两版共用同一张司令分野表（各令度数合计 30°，见上表），但定位方式不同，在节气边界处存在系统性差异：

| 差异点 | 按日版 HideHeavenStemDay | 按黄经版 EclipticHideHeavenStemDay |
|--------|--------------------------|-----------------------------------|
| 定位依据 | 节气所在公历日（当天 0:00 即切换） | 太阳视黄经精确度数（到 315° 才切换） |
| 节气当天 | 0:00 起即报新令首位（如立春当天报戊土·第1段） | 节气时刻前仍报旧令末段（如立春 16:27 前报己土·第3段） |
| 首段天数 | 首段计数含节气当天 | 按度数折算（7° ≈ 7.1 日） |
| 末段 | 开放到下一节令（日版末段不设固定宽度，从第 (前两段) 天起覆盖至下一节令） | 剩余度数（如寅月甲木 16°、丑月己土 18°） |
| 精确度 | 日级 | 秒级（随视黄经连续变化） |

示例：2024 年立春为 2 月 4 日 16:27。当天 00:00 起，按日版已报戊土·第1段（立春当日第 1 天）；按黄经版在 16:27 前仍报己土·第3段（视黄经未到 315°），16:27 后才切为戊土·第1段。两版在节气时刻之后一致（均为戊土·第1段）。注意立春时刻逐年漂移（如 2025 年为 2 月 3 日 22:10），不能以固定钟点断言差异。

两种实现各自独立、均可单独使用；需要与 Go 版 tyme4go 行为一致时用按日版，需要黄经精确划分时用本接口。

### 如何得到真黄经人元司令分野？

1. 从公历时刻 SolarTime得到真黄经人元司令分野
        // 壬水
        let ecliptic_hide_heaven_stem_day = SolarTime::from_ymdhms(2024, 12, 4, 12, 0, 0).unwrap().get_hide_heaven_stem_by_ecliptic()
      
### 从真黄经人元司令分野可以得到些什么？

1. 当令天干
get_hide_heaven_stem()返回为藏干 HideHeavenStem（其藏干类型恒为本气 Main，无分类意义；当令的是哪一段请看 get_sector_index）。

        let ecliptic_hide_heaven_stem_day = SolarTime::from_ymdhms(2024, 12, 4, 12, 0, 0).unwrap().get_hide_heaven_stem_by_ecliptic()
         
        // 壬
        let hide_heaven_stem = ecliptic_hide_heaven_stem_day.get_hide_heaven_stem()
      
2. 司令段序
get_sector_index()返回为当前当令的是第几段（0/1/2 = 第1/2/3段，与藏干分类无关）。

        // 2（第3段）
        let sector_index = ecliptic_hide_heaven_stem_day.get_sector_index()
      
3. 太阳黄经在月令内的度数
get_month_lon()返回为太阳黄经在月令内的度数，范围 [0, 30)。

        // 27.49...（度）
        let month_lon = ecliptic_hide_heaven_stem_day.get_month_lon()
      
4. 司令段起点度数
get_lon_offset()返回为当前司令段起点在月令内的黄经度数（如立春月戊土段 0、丙火段 7、甲木段 14）。

        // 12.0
        let lon_offset = ecliptic_hide_heaven_stem_day.get_lon_offset()
      
5. 段内度数
get_angle_in_sector()返回为太阳黄经在当前司令段内的度数（month_lon - lon_offset）。

        let angle_in_sector = ecliptic_hide_heaven_stem_day.get_angle_in_sector()
      
## 纳音 Sound轮回

纳音依次为：海中金、炉中火、大林木、路旁土、剑锋金、山头火、涧下水、城头土、白蜡金、杨柳木、泉中水、屋上土、霹雳火、松柏木、长流水、沙中金、山下火、平地木、壁上土、金箔金、覆灯火、天河水、大驿土、钗钏金、桑柘木、大溪水、沙中土、天上火、石榴木、大海水。

## 彭祖百忌 PengZu

彭祖百忌，指在天干地支记日中的某日或当日里的某时不要做某事否则会发生某事。口诀如下：

        // 天干忌讳
        甲不开仓财物耗散，乙不栽植千株不长；
        丙不修灶必见灾殃，丁不剃头头必生疮；
        戊不受田田主不祥，己不破券二比并亡；
        庚不经络织机虚张，辛不合酱主人不尝；
        壬不泱水更难提防，癸不词讼理弱敌强。
         
        // 地支忌讳
        子不问卜自惹祸殃，丑不冠带主不还乡；
        寅不祭祀神鬼不尝，卯不穿井水泉不香；
        辰不哭泣必主重丧，巳不远行财物伏藏；
        午不苫盖屋主更张，未不服药毒气入肠；
        申不安床鬼祟入房，酉不会客醉坐颠狂；
        戌不吃犬作怪上床，亥不嫁娶不利新郎。
      
### 如何得到彭祖百忌？

1. 从干支 SixtyCycle得到
        // 甲不开仓财物耗散 子不问卜自惹祸殃
        let peng_zu = SixtyCycle::from_name("甲子").get_peng_zu()
      
### 从彭祖百忌可以得到些什么？

1. 天干彭祖百忌
get_peng_zu_heaven_stem()返回为天干彭祖百忌 PengZuHeavenStem。

        let peng_zu = SixtyCycle::from_name("甲子").get_peng_zu()
         
        // 甲不开仓财物耗散
        let peng_zu_heaven_stem = peng_zu.get_peng_zu_heaven_stem()
      
2. 地支彭祖百忌
get_peng_zu_earth_branch()返回为地支彭祖百忌 PengZuEarthBranch。

        let peng_zu = SixtyCycle::from_name("甲子").get_peng_zu()
         
        // 子不问卜自惹祸殃
        let peng_zu_earth_branch = peng_zu.get_peng_zu_earth_branch()
      
也可直接通过天干 HeavenStem获取天干彭祖百忌 PengZuHeavenStem，通过地支 EarthBranch直接获取地支彭祖百忌 PengZuEarthBranch。

        // 甲不开仓财物耗散
        let peng_zu_heaven_stem = HeavenStem::from_name("甲").get_peng_zu_heaven_stem()
         
        // 子不问卜自惹祸殃
        let peng_zu_earth_branch = EarthBranch::from_name("子").get_peng_zu_earth_branch()
      
## 吉凶 Luck轮回

目前只支持两种，依次为：吉、凶。

## 方位 Direction轮回

依据后天八卦排序：坎北、坤西南、震东、巽东南、中、乾西北、兑西、艮东北、离南），方位依次为：北、西南、东、东南、中、西北、西、东北、南。

### 从方位可以得到些什么？

1. 九野
get_land()返回为九野 Land。

        let direction = Direction::from_name("北")
         
        // 玄天
        let land = direction.get_land()
      
## 宫 Zone轮回

宫依次为：东、北、西、南。

### 从宫可以得到些什么？

1. 方位
get_direction()返回为方位 Direction。

        let zone = Zone::from_name("东")
         
        // 东
        let direction = zone.get_direction()
      
2. 神兽
get_beast()返回为神兽 Beast。

        let zone = Zone::from_name("东")
         
        // 青龙
        let direction = zone.get_beast()
      
## 神兽 Beast轮回

神兽和宫一一对应，依次为：青龙、玄武、白虎、朱雀。

### 从神兽可以得到些什么？

1. 宫
get_zone()返回为宫 Zone。

        let beast = Beast::from_name("青龙")
         
        // 东
        let zone = beast.get_zone()
      
## 动物 Animal轮回

动物一般用于二十八宿，依次为：蛟、龙、貉、兔、狐、虎、豹、獬、牛、蝠、鼠、燕、猪、獝、狼、狗、彘、鸡、乌、猴、猿、犴、羊、獐、马、鹿、蛇、蚓。

### 如何得到动物？

1. 从二十八宿 TwentyEightStar得到
        let d = LunarDay::from_ymd(2020, 4, 13)

        // 翼
        let star = d.get_twenty_eight_star()
         
        // 蛇
        let animal = star.get_animal()
      
## 元 Sixty轮回

一元等于三运，也就是60年，1甲子，元依次为：上元、中元、下元。常说三元九运，可以涵盖180年。

### 如何得到元？

1. 从运 Twenty得到
        // 九运
        let twenty = LunarYear::from_year(1863).get_twenty()
         
        // 下元
        let sixty = twenty.get_sixty()
      
## 运 Twenty轮回

20年为1运，一共有九运，依次为：一运、二运、三运、四运、五运、六运、七运、八运、九运。

### 如何得到运？

1. 从农历年 LunarYear得到
        // 二运
        let twenty = LunarYear::from_year(1884).get_twenty()
      
## 旬 Ten轮回

旬依次为：甲子、甲戌、甲申、甲午、甲辰、甲寅。1旬=10，常听说的八旬老人指80岁的老人，每月有上旬、中旬、下旬，指的则是10天。6旬正好为60年，对应六十甲子。

### 如何得到旬？

从干支 SixtyCycle得到。

        let sixty_cycle = SixtyCycle::from_name("乙卯")

        // 甲寅
        let ten = sixty_cycle.get_ten()
      
## 梅雨天 PlumRainDay

江淮流域一带约6月上旬后出现的阴雨天气，称做梅雨期。梅雨期的始日谓"入梅"，也称"入霉"、"进梅"；梅雨期的终日谓"出梅"，也称"出霉"，"断梅"。梅雨期间的降水称为梅雨，此时正值江南梅子成熟期，故得名。

芒种后的第1个丙日入梅，小暑后的第1个未日出梅。

### 如何得到梅雨天？

1. 从公历日 SolarDay初始化
        // 入梅第1天
        let plum_rain_day = SolarDay::from_ymd(2024, 6, 11).get_plum_rain_day()
      
## 逐月胎神 FetusMonth轮回

胎神是掌管妇女胎孕之事的神灵。民间认为胎神是不能触犯的，触犯了胎神就会危及母腹中的婴儿。胎神的活动被看成是有规律的，它往往按照时间的移动而处在房间的不同位置。正十二月在床房，二三九十门户中，四六十一灶勿犯，五甲七子八厕凶。闰月无胎神。

### 如何得到逐月胎神？

1. 从农历月 LunarMonth初始化
        let lunar_month = LunarMonth::from_ym(2024, 4)
        // 占厨灶
        let fetus = lunar_month.get_fetus()
      
## 逐日胎神 FetusDay

参考多方资料对比、修正，最终形成了这个我自认为最靠谱的逐日胎神表。

        甲子日 占门碓 外东南, 乙丑日 碓磨厕 外东南, 丙寅日 厨灶炉 外正南, 丁卯日 仓库门 外正南, 戊辰日 房床栖 外正南, 己巳日 占门床 外正南, 庚午日 占碓磨 外正南, 辛未日 厨灶厕 外西南, 壬申日 仓库炉 外西南, 癸酉日 房床门 外西南
        甲戌日 占门栖 外西南, 乙亥日 碓磨床 外西南, 丙子日 厨灶碓 外西南, 丁丑日 仓库厕 外正西, 戊寅日 房床炉 外正西, 己卯日 占大门 外正西, 庚辰日 碓磨栖 外正西, 辛巳日 厨灶床 外正西, 壬午日 仓库碓 外西北, 癸未日 房床厕 外西北
        甲申日 占门炉 外西北, 乙酉日 碓磨门 外西北, 丙戌日 厨灶栖 外西北, 丁亥日 仓库床 外西北, 戊子日 房床碓 外正北, 己丑日 占门厕 外正北, 庚寅日 碓磨炉 外正北, 辛卯日 厨灶门 外正北, 壬辰日 仓库栖 外正北, 癸巳日 占房床 房内北
        甲午日 占门碓 房内北, 乙未日 碓磨厕 房内北, 丙申日 厨灶炉 房内北, 丁酉日 仓库门 房内北, 戊戌日 房床栖 房内中, 己亥日 占门床 房内中, 庚子日 占碓磨 房内南, 辛丑日 厨灶厕 房内南, 壬寅日 仓库炉 房内南, 癸卯日 房床门 房内西
        甲辰日 占门栖 房内东, 乙巳日 碓磨床 房内东, 丙午日 厨灶碓 房内东, 丁未日 仓库厕 房内东, 戊申日 房床炉 房内中, 己酉日 占大门 外东北, 庚戌日 碓磨栖 外东北, 辛亥日 厨灶床 外东北, 壬子日 仓库碓 外东北, 癸丑日 房床厕 外东北
        甲寅日 占门炉 外东北, 乙卯日 碓磨门 外正东, 丙辰日 厨灶栖 外正东, 丁巳日 仓库床 外正东, 戊午日 房床碓 外正东, 己未日 占门厕 外正东, 庚申日 碓磨炉 外东南, 辛酉日 厨灶门 外东南, 壬戌日 仓库栖 外东南, 癸亥日 占房床 外东南
      
### 如何得到逐日胎神？

1. 从农历日 LunarDay初始化
        let lunar_day = LunarDay::from_ymd(2024, 4, 22)
        // 占房床 房内北
        let fetus = lunar_day.get_fetus_day()
      
### 从逐日胎神可以得到些什么？

1. 内外 Side
        let fetus = LunarDay::from_ymd(2024, 4, 22).get_fetus_day()
        // 内
        let side = fetus.get_side()
      
2. 方位 Direction
        let fetus = LunarDay::from_ymd(2024, 4, 22).get_fetus_day()
        // 北
        let direction = fetus.get_direction()
      
3. 天干六甲胎神 FetusHeavenStem
        let fetus = LunarDay::from_ymd(2024, 4, 22).get_fetus_day()
        // 房
        let fetus_heaven_stem = fetus.get_fetus_heaven_stem()
      
4. 地支六甲胎神 FetusEarthBranch
        let fetus = LunarDay::from_ymd(2024, 4, 22).get_fetus_day()
        // 床
        let fetus_earth_branch = fetus.get_fetus_earth_branch()
      
## 天干六甲胎神 FetusHeavenStem

天干六甲胎神歌：甲己之日占在门，乙庚碓磨休移动。丙辛厨灶莫相干，丁壬仓库忌修弄。戊癸房床若移整，犯之孕妇堕孩童。

天干六甲胎神所在位置分别为：门、碓磨、厨灶、仓库、房床。

## 地支六甲胎神 FetusEarthBranch

地支六甲胎神歌：子午二日碓须忌，丑未厕道莫修移。寅申火炉休要动，卯酉大门修当避。辰戌鸡栖巳亥床，犯着六甲身堕胎。

地支六甲胎神所在位置分别为：碓、厕、炉、门、栖、床。

## 灶马头 KitchenGodSteed

灶马头是中国传统文化中的一种特殊日历工具，主要用于预测一年的年景和收成情况。这一术语源自灶王爷的形象，因为灶王爷的画像中一直都是骑马巡视人间，便有了灶马头这一说法。它通常是一张印有灶神像和年历表的纸，上面记录了阴历、节气、农事等内容。

### 如何得到灶马头？

1. 从农历年 LunarYear得到
        // 第1种
        let kitchen_god_steed1 = LunarYear::from_year(2017).get_kitchen_god_steed()

        // 第2种
        let kitchen_god_steed2 = KitchenGodSteed::from_lunar_year(2017)
      
### 从灶马头可以得到些什么？

1. 几鼠偷粮、草子几分、几牛耕田、花收几分、几龙治水、几马驮谷、几鸡抢米、几姑看蚕、几屠共猪、甲田几分、几人分饼、几日得金、几人几丙、几人几锄
        let kitchen_god_steed = KitchenGodSteed::from_lunar_year(2017)
         
        // 十鼠偷粮
        let mouse = kitchen_god_steed.get_mouse()
        // 草子十分
        let grass = kitchen_god_steed.get_grass()
        // 十一牛耕田
        let cattle = kitchen_god_steed.get_cattle()
        // 花收一分
        let flower = kitchen_god_steed.get_flower()
        // 二龙治水
        let dragon = kitchen_god_steed.get_dragon()
        // 四马驮谷
        let horse = kitchen_god_steed.get_horse()
        // 七鸡抢米
        let chicken = kitchen_god_steed.get_chicken()
        // 七姑看蚕
        let silkworm = kitchen_god_steed.get_silkworm()
        // 九屠共猪
        let pig = kitchen_god_steed.get_pig()
        // 甲田十分
        let field = kitchen_god_steed.get_field()
        // 二人分饼
        let cake = kitchen_god_steed.get_cake()
        // 七日得金
        let gold = kitchen_god_steed.get_gold()
        // 十二人二丙
        let people_cakes = kitchen_god_steed.get_people_cakes()
        // 十二人三锄
        let people_hoes = kitchen_god_steed.get_people_hoes()
      
## 宜忌 Taboo

宜忌包括每日宜忌、时辰宜忌，数据仅供参考。

### 如何得到每日宜忌？

1. 从农历日 LunarDay或干支日 SixtyCycleDay得到，两者是一致的。
        let d = SolarDay::from_ymd(2024, 6, 26).get_lunar_day()
        // let d = SolarDay::from_ymd(2024, 6, 26).get_sixty_cycle_day()

        // 宜：嫁娶, 祭祀, 理发, 作灶, 修饰垣墙, 平治道涂, 整手足甲, 沐浴, 冠笄
        let taboos = d.get_recommends()
         
        // 忌：破土, 出行, 栽种
        let taboos2 = d.get_avoids()
      
### 如何得到时辰宜忌？

1. 从农历时辰 LunarHour或干支时辰 SixtyCycleHour得到，两者是一致的。
        let h = SolarTime::from_ymd_hms(2024, 4, 22, 0, 0, 0).get_lunar_hour()
        // let h = SolarTime::from_ymd_hms(2024, 4, 22, 0, 0, 0).get_sixty_cycle_hour()
         
        // 宜：嫁娶, 交易, 开市, 安床, 祭祀, 求财
        let taboos = h.get_recommends()
         
        // 忌：出行, 移徙, 赴任, 词讼, 祈福, 修造, 求嗣
        let taboos2 = h.get_avoids()
      
## 神煞 God

目前只支持农历日的吉神宜趋、凶神宜忌。

### 如何得到吉神宜趋和凶神宜忌？

1. 从农历日 LunarDay或干支日 SixtyCycleDay得到，两者是一致的。
        let d = SolarDay::from_ymd(1954, 7, 16).get_lunar_day()
        // let d = SolarDay::from_ymd(1954, 7, 16).get_sixty_cycle_day()
         
        // 获得当天的神煞列表
        let gods = d.get_gods()
         
        // 吉神宜趋
        let mut good_gods : Array[God] = []
        // 凶神宜忌
        let mut bad_gods : Array[God] = []
         
        // 遍历，根据神煞吉凶区分吉神和凶神
        for god in gods {
          if god.get_luck().get_name() == "吉" {
            good_gods.push(god)
          } else {
            bad_gods.push(god)
          }
        }
      
## 童限 ChildLimit

出生童限起运大运十年
小运小运小运小运小运小运小运小运小运小运
流年流年流年流年流年流年流年流年流年流年
如上图所示，童限为从出生到起运之间的时间，童限的开始即出生，童限的结束即起运。

        // 得到公历2022年3月9日 20:51:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(2022, 3, 9, 20, 51, 0), Gender::Man)
      
### 从童限可以得到些什么？

1. 八字 EightChar
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 辛未 辛丑 戊申 戊午
        let eight_char = child_limit.get_eight_char()
      
2. 性别 Gender
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // Gender::Man (男)
        let gender = child_limit.get_gender()
      
3. 是否顺推
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // false (逆推)
        let forward = child_limit.is_forward()
      
4. 年数
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 9
        let n = child_limit.get_year_count()
      
5. 月数
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 0
        let n = child_limit.get_month_count()
      
6. 日数
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 9
        let n = child_limit.get_day_count()
      
7. 小时数
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 6
        let n = child_limit.get_hour_count()
      
8. 分钟数
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 58
        let n = child_limit.get_minute_count()
      
9. 开始(即出生)的公历时刻
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 1992年2月2日 12:00:00
        let time = child_limit.get_start_time()
      
10. 结束(即开始起运)的公历时刻
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 2001年2月11日 18:58:00
        let time = child_limit.get_end_time()
      
11. 大运 DecadeFortune
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 庚子
        let decade_fortune = child_limit.get_start_decade_fortune()
      
12. 小运 Fortune
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)
         
        // 戊申
        let fortune = child_limit.get_start_fortune()
      
### 如何切换童限(起运)计算的流派？

童限的计算可通过ChildLimitProvider来切换，默认支持以下几种计算方式，你也可以自定义。

1. 默认
计算出生时刻和节令时刻相差的秒数，按3天 = 1年（3天 = 60秒 * 60 * 24 * 3 = 259200秒 = 1年）、1天 = 4月（1天 = 60秒 * 60 * 24 = 86400秒 = 4月，86400秒 / 4 = 21600秒 = 1月）、1时 = 5天（1时 = 60秒 * 60 = 3600秒 = 5天，3600秒 / 5 = 720秒 = 1天）、1分 = 2时（1分 = 60秒 = 2时，60秒 / 2 = 30秒 = 1时）、1秒 = 2分（1秒 / 2 = 0.5秒 = 1分）进行推移，最终起运时间精确到分钟。

        ChildLimit::set_provider(DefaultChildLimitProvider)
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(2022, 3, 9, 20, 51, 0), Gender::Man)
      
2. 元亨利贞
计算出生时刻和节令时刻相差的分钟数，按3天 = 1年（3天 = 60分 * 24 * 3 = 4320分 = 1年）、1天 = 4月（1天 = 60分 * 24 = 1440分， 1440分 / 4 = 360分 = 1月）、1时 = 5天（1时 = 60分 = 5天，60分 / 5 = 12分 = 1天）进行推移，最终起运时间精确到日。

        ChildLimit::set_provider(China95ChildLimitProvider)
      
3. Lunar的流派1
直接用相差的天数和时辰数计算，按3天 = 1年、1天 = 4月、1时辰 = 10天进行推移，最终起运时间精确到日。

        ChildLimit::set_provider(LunarSect1ChildLimitProvider)
      
4. Lunar的流派2
计算出生时刻和节令时刻相差的分钟数，按3天 = 1年（3天 = 60分 * 24 * 3 = 4320分 = 1年）、1天 = 4月（1天 = 60分 * 24 = 1440分， 1440分 / 4 = 360分 = 1月）、1时 = 5天（1时 = 60分 = 5天，60分 / 5 = 12分 = 1天）、1分 = 2时进行推移，最终起运时间精确到小时。

        ChildLimit::set_provider(LunarSect2ChildLimitProvider)
      
5. 自定义
实现ChildLimitProvider trait，或继承AbstractChildLimitProvider。

        // 实现ChildLimitProvider trait
        struct MyChildLimitProvider {
          // 实现get_info方法
        }
        impl ChildLimitProvider for MyChildLimitProvider {
          // ...
        }
         
        ChildLimit::set_provider(MyChildLimitProvider{})
      
## 大运 DecadeFortune

自起运开始，每十年为一大运。童限结束的公历时刻，即开始起运，是大运的开始。

        // 得到公历2022年3月9日 20:51:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(2022, 3, 9, 20, 51, 0), Gender::Man)

        // 开始的大运
        let decade_fortune = child_limit.get_start_decade_fortune()
      
### 从大运可以得到些什么？

1. 开始年龄
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 10 (10岁)
        let age = decade_fortune.get_start_age()
      
2. 结束年龄
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 19 (19岁)
        let age = decade_fortune.get_end_age()
      
3. 开始农历年 LunarYear(已废弃)
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 农历辛巳年
        let year = decade_fortune.get_start_lunar_year()
      
4. 结束农历年 LunarYear(已废弃)
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 农历庚寅年
        let year = decade_fortune.get_end_lunar_year()
      
5. 开始干支年 SixtyCycleYear
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 辛巳年
        let year = decade_fortune.get_start_sixty_cycle_year()
      
6. 结束干支年 SixtyCycleYear
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 庚寅年
        let year = decade_fortune.get_end_sixty_cycle_year()
      
7. 干支 SixtyCycle
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 庚子
        let sixty_cycle = decade_fortune.get_sixty_cycle()
      
8. 本轮大运中开始的小运 Fortune
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let decade_fortune = child_limit.get_start_decade_fortune()
         
        // 戊申
        let fortune = decade_fortune.get_start_fortune()
      
9. 如何得到多轮大运？
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的大运 (庚子)
        let mut decade_fortune = child_limit.get_start_decade_fortune()
         
        // 下一轮大运
        decade_fortune = decade_fortune.next(1)
         
        // 上一轮大运
        decade_fortune = decade_fortune.next(-1)
      
## 小运 Fortune

在十年大运中，每一年为一小运。童限结束的公历时刻，既是大运的开始，也是小运的开始。

        // 得到公历2022年3月9日 20:51:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(2022, 3, 9, 20, 51, 0), Gender::Man)

        // 开始的小运
        let fortune = child_limit.get_start_fortune()
      
### 从小运可以得到些什么？

1. 年龄
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的小运 (戊申)
        let fortune = child_limit.get_start_fortune()
         
        // 10 (10岁)
        let age = fortune.get_age()
      
2. 农历年 LunarYear(已废弃)
由于1大运为10年，对应10小运，因此1小运对应1年，称为流年，但注意小运干支并不等于流年干支。

        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的小运 (戊申)
        let fortune = child_limit.get_start_fortune()
         
        // 农历辛巳年
        let year = fortune.get_lunar_year()
      
3. 干支年 SixtyCycleYear
由于1大运为10年，对应10小运，因此1小运对应1年，称为流年，但注意小运干支并不等于流年干支。

        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的小运 (戊申)
        let fortune = child_limit.get_start_fortune()
         
        // 辛巳年
        let year = fortune.get_sixty_cycle_year()
      
4. 干支 SixtyCycle
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的小运 (戊申)
        let fortune = child_limit.get_start_fortune()
         
        // 戊申
        let sixty_cycle = fortune.get_sixty_cycle()
      
5. 如何得到多轮小运？
        // 得到公历1992年2月2日 12:00:00生男的童限
        let child_limit = ChildLimit::from_solar_time(SolarTime::from_ymd_hms(1992, 2, 2, 12, 0, 0), Gender::Man)

        // 开始的小运 (戊申)
        let mut fortune = child_limit.get_start_fortune()
         
        // 下一个小运
        fortune = fortune.next(1)
         
        // 上一个小运
        fortune = fortune.next(-1)
      
### 八字排盘的示例

公历
2026
年 
8
月 
5
日 
2
时 
44
分 
23
秒 
男
 
晚子时日柱算明天
 起运流派
默认
年柱月柱日柱时柱
主星正官偏财元男偏印
天干丙乙辛己
地支午未亥丑
藏干
丁 七杀己 偏印
己 偏印丁 七杀乙 偏财
壬 伤官甲 正财
己 偏印癸 食神辛 比肩
星运病衰沐浴养
自坐帝旺养沐浴墓
空亡寅卯辰巳寅卯午未
纳音天河水沙中金钗钏金霹雳火
农历：农历丙午年六月廿三己丑时
节气：小暑(7月7日 09:56:57) 立秋(8月7日 19:42:43)
胎元：丙戌(屋上土) 胎息：丙寅(炉中火)
命宫：丁酉(山下火) 身宫：丁酉(山下火)
起运：0年10个月24天20时40分后起运 (公历2027年6月29日 23:24:23)
大运
童限
2026
2027
1 - 1岁
偏财
丙申
2027
2036
2 - 11岁
正官
丁酉
2037
2046
12 - 21岁
七杀
戊戌
2047
2056
22 - 31岁
正印
己亥
2057
2066
32 - 41岁
偏印
庚子
2067
2076
42 - 51岁
劫财
辛丑
2077
2086
52 - 61岁
比肩
壬寅
2087
2096
62 - 71岁
伤官
癸卯
2097
2106
72 - 81岁
食神
甲辰
2107
2116
82 - 91岁
正财
乙巳
2117
2126
92 - 101岁
偏财
小运
庚寅
2026
1岁
劫财
流年
丙午
正官
流月
庚寅
劫财
辛卯
比肩
壬辰
伤官
癸巳
食神
甲午
正财
乙未
偏财
丙申
正官
丁酉
七杀
戊戌
正印
己亥
偏印
庚子
劫财
辛丑
比肩
## 事件 Event

经常有人问，为什么公历现代节日中没有情人节，没有圣诞节等？我不主张在公历现代节日中增加洋节，但是您可以通过事件来实现。tyme中没有内置默认的事件，所有事件都需要您自行定义，具体可以参考源代码中的单元测试用例和事件类型 EventType，单元测试代码中有各种类型事件的示例。

### 使用案例

        // 更新数据，自270年起，公历2月14日为情人节
        EventManager::update("情人节", Event::builder().solar_day(2, 14, 0).start_year(270).build())

        // 也可以通过字符串数据更新
        EventManager::update_data("情人节", "@0Wi__04I情人节")
         
        // 也可以一次性替换所有事件数据
        EventManager::set_data("@0Wi__04I情人节")
         
        // 取情人节事件
        let e = Event::from_name("情人节")

        // 打印事件名称
        println(e.get_name())
        // 打印事件数据
        println(e.get_data())
         
        // 2026年的情人节对应的公历日：2026年2月14日
        let d = e.get_solar_day(2026)
         
        // 获取公历2025年2月14日的事件列表：情人节
        let events = Event::from_solar_day(SolarDay::from_ymd(2025, 2, 14))
         
        // 打印2026年的所有事件
        for event in Event::all() {
          println("\{event} = \{event.get_solar_day(2026)}")
        }
      
### 特殊日期处理

如果公历生日是闰年的2月29，那下一年可能2月只有28天，或者农历生日是某月的三十，而下一年当月只有29天，如果想在没有那一天的时候自动选择前一天，类似这样的场景，事件也是支持的。例如：

        // 如果没有2月29，则倒推1天，通过Event::builder()指定公历日，第3个参数为顺延天数，设为-1则往前推1天，设为1则往后推1天，最小支持-31天，最大支持31天。
        EventManager::update("公历生日", Event::builder().solar_day(2, 29, -1).start_year(2004).build())
         
        // 取公历生日事件
        let e = Event::from_name("公历生日")
         
        // 2008年是闰年，2月有29天：2008年2月29日
        let d = e.get_solar_day(2008)
         
        // 2005年不是闰年，2月没有29，则返回2005年2月28日
        let d2 = e.get_solar_day(2005)
         
        // 不偏移
        EventManager::update("公历生日", Event::builder().solar_day(2, 29, 0).start_year(2004).build())

        let e2 = Event::from_name("公历生日")
         
        // 2005年不是闰年，2月没有29，则返回None
        let d3 = e2.get_solar_day(2005)
      
## 事件管理器 EventManager

事件管理器负责新增、更新和删除事件，所有事件都以名称作为唯一标识。

1. 删除事件
        EventManager::remove("情人节")
      
2. 新增/更新事件
如果事件数据中没有该名称，则新增，否则更新对应名称事件的数据。

        // 通过事件构造器创建事件
        EventManager::update("情人节", Event::builder().solar_day(2, 14, 0).start_year(270).build())

        // 通过字符串数据更新
        EventManager::update_data("情人节", "@0Wi__04I情人节")

        // 对已经存在的事件改名
        EventManager::update("情人节", Event::builder().name("西方传统情人节").solar_day(2, 14, 0).start_year(270).build())
        EventManager::update_data("情人节", "@0Wi__04I西方传统情人节")
         
        // 一次性替换所有事件数据
        EventManager::set_data("@0Wi__04I情人节@2VV__000农历传统节日:春节")
      
## 事件构造器 EventBuilder

由于事件数据经过编码压缩以尽量节省数据长度，所以采用事件构造器来创建事件。

1. 实例化构造器
        // 该方法返回一个构造器实例
        let builder = Event::builder()
      
2. 中间过程
构造器支持链式调用。

        // 公历1月1日，自1950年起，元旦，第3个参数为0不顺延
        Event::builder().solar_day(1, 1, 0).start_year(1950)
         
        // 农历二月初二，龙头节，第3个参数为0不顺延
        Event::builder().lunar_day(2, 2, 0)
         
        // 清明节（节气，冬至为0依次类推），第2个参数为0不顺延
        Event::builder().term_day(7, 0)
         
        // 5月的第2个星期日（0123456代表周日到周六），自1914年起，母亲节
        Event::builder().solar_week(5, 2, 0).start_year(1914)
         
        // 立春（节气，冬至为0依次类推）后第5个戊日（天干，甲为0依次类推，第5个戊日即找到第1个戊日往后推40天，由于顺延天数最远支持-31到31天，所以这里设置为顺延30天，然后通过偏移再追加10天），春社
        Event::builder().term_heaven_stem(3, 4, 30).offset(10)
         
        // 除夕，13代表明年正月，1代表初一，然后偏移-1天即除夕
        Event::builder().lunar_day(13, 1, 0).offset(-1)
      
3. 生成事件
构造器构造完后，调用该方法生成事件对象。

        let builder = Event::builder()
        // 中间过程...

        // 生成事件
        let e = builder.build()
      
## 枚举

枚举类型都可以调用以下几个方法（有些开发语言可能不支持）：

1. 名称
调用get_name()返回名称字符串。

        // 性别
        let gender = Gender::from_name("男")
        // 男
        let name = gender.get_name()
      
2. 代码
调用get_code()返回数字代码。

        // 性别
        let gender = Gender::from_name("男")
        // 1
        let code = gender.get_code()
      
3. 通过代码进行初始化
调用from_code(code)得到枚举对象。code为数字代码。

        // 阴
        let yin_yang = YinYang::from_code(0)
      
4. 通过名称进行初始化
调用from_name(name)得到枚举对象。name为字符串，当名称不存在时，返回None。

        // 阴
        let yin_yang = YinYang::from_name("阴")
      
## 节日类型 FestivalType(已废弃)

节日类型枚举值有：Day=0=日期，Term=1=节气，Eve=2=除夕。

## 性别 Gender

性别枚举值有：Woman=0=女，Man=1=男。

## 内外 Side

内外枚举值有：In=0=内，Out=1=外。

## 阴阳 YinYang

阴阳枚举值有：Yin=0=阴，Yang=1=阳。

## 藏干类型 HideHeavenStemType

藏干类型枚举值有：Residual=0=余气，Middle=1=中气、Main=2=本气。

## 事件类型 EventType

事件类型枚举值有：SolarDay=0=公历日期，SolarWeek=1=几月第几个星期几、LunarDay=2=农历日期、TermDay=3=节气日期、TermHs=4=节气天干、TermEb=5=节气地支。

### 公历日期

2月14日情人节、公历生日等。

### 几月第几个星期几

母亲节、父亲节等。

### 农历日期

春节、元宵节、农历生日等。

### 节气日期

冬至节、寒食节等。

### 节气天干

春社、秋社、三伏、入梅等。

### 节气地支

出梅等。