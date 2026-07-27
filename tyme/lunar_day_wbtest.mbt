// 测试套件：LunarDay（对应 Go test/LunarDay_test.go，一比一翻译）

///|
test "lunar_day_0" {
  let d = LunarDay::from_ymd(0, 11, 18).unwrap()
  expect_eq(d.get_solar_day().to_string(), "1年1月1日", "LunarDay(0,11,18).GetSolarDay().String()")
}

///|
test "lunar_day_1" {
  let d = LunarDay::from_ymd(9999, 12, 2).unwrap()
  expect_eq(d.get_solar_day().to_string(), "9999年12月31日", "LunarDay(9999,12,2).GetSolarDay().String()")
}

///|
test "lunar_day_2" {
  let d = LunarDay::from_ymd(2023, 8, 24).unwrap()
  expect_eq(d.get_sixty_cycle().to_string(), "己亥", "LunarDay(2023,8,24).GetSixtyCycle().String()")
}

///|
test "lunar_day_3" {
  let d = LunarDay::from_ymd(2012, 3, 1).unwrap()
  expect_eq(d.next(60).to_string(), "农历壬辰年闰四月初一", "LunarDay(2012,3,1).Next(60).String()")
}

// 二十八宿测试
///|
test "lunar_day_4" {
  let d = LunarDay::from_ymd(2020, 4, 13).unwrap()
  let star = d.get_twenty_eight_star()
  expect_eq(
    star.get_zone().get_name(),
    "南",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetZone().GetName()",
  )
  expect_eq(
    star.get_zone().get_beast().get_name(),
    "朱雀",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetZone().GetBeast().GetName()",
  )
  expect_eq(
    star.get_name(),
    "翼",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetName()",
  )
  expect_eq(
    star.get_seven_star().get_name(),
    "火",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetSevenStar().GetName()",
  )
  expect_eq(
    star.get_animal().get_name(),
    "蛇",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetAnimal().GetName()",
  )
  expect_eq(
    star.get_luck().get_name(),
    "凶",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetLuck().GetName()",
  )
  expect_eq(
    star.get_land().get_name(),
    "阳天",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetLand().GetName()",
  )
  expect_eq(
    star.get_land().get_direction().get_name(),
    "东南",
    "LunarDay(2020,4,13).GetTwentyEightStar().GetLand().GetDirection().GetName()",
  )
}

///|
test "lunar_day_5" {
  let d = LunarDay::from_ymd(2024, 1, 1).unwrap()
  expect_eq(d.next(31).to_string(), "农历甲辰年二月初三", "LunarDay(2024,1,1).Next(31).String()")
}
