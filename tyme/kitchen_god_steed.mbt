///|
// KitchenGodSteed 灶马头
pub struct KitchenGodSteed {
  // 正月初一的干支
  first_day_sixty_cycle : SixtyCycle
}

///|
// numbers 数字
pub fn numbers() -> Array[String] {
  ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"]
}

///|
// new 从农历年构造
pub fn KitchenGodSteed::new(lunar_year : Int) -> KitchenGodSteed {
  let lunar_day = LunarDay::from_ymd(lunar_year, 1, 1).unwrap()
  KitchenGodSteed::{
    first_day_sixty_cycle : lunar_day.get_sixty_cycle(),
  }
}

///|
// from_lunar_year 从农历年初始化
pub fn KitchenGodSteed::from_lunar_year(lunar_year : Int) -> KitchenGodSteed {
  KitchenGodSteed::new(lunar_year)
}

///|
// by_heaven_stem 根据天干获取序数
fn KitchenGodSteed::by_heaven_stem(self : KitchenGodSteed, n : Int) -> String {
  numbers()[self.first_day_sixty_cycle.get_heaven_stem().loop_tyme.steps_to(n)]
}

///|
// by_earth_branch 根据地支获取序数
fn KitchenGodSteed::by_earth_branch(self : KitchenGodSteed, n : Int) -> String {
  numbers()[self.first_day_sixty_cycle.get_earth_branch().loop_tyme.steps_to(n)]
}

///|
// get_mouse 几鼠偷粮
pub fn KitchenGodSteed::get_mouse(self : KitchenGodSteed) -> String {
  self.by_earth_branch(0) + "鼠偷粮"
}

///|
// get_grass 草子几分
pub fn KitchenGodSteed::get_grass(self : KitchenGodSteed) -> String {
  "草子\{self.by_earth_branch(0)}分"
}

///|
// get_cattle 几牛耕田
pub fn KitchenGodSteed::get_cattle(self : KitchenGodSteed) -> String {
  self.by_earth_branch(1) + "牛耕田"
}

///|
// get_flower 花收几分
pub fn KitchenGodSteed::get_flower(self : KitchenGodSteed) -> String {
  "花收\{self.by_earth_branch(3)}分"
}

///|
// get_dragon 几龙治水
pub fn KitchenGodSteed::get_dragon(self : KitchenGodSteed) -> String {
  self.by_earth_branch(4) + "龙治水"
}

///|
// get_horse 几马驮谷
pub fn KitchenGodSteed::get_horse(self : KitchenGodSteed) -> String {
  self.by_earth_branch(6) + "马驮谷"
}

///|
// get_chicken 几鸡抢米
pub fn KitchenGodSteed::get_chicken(self : KitchenGodSteed) -> String {
  self.by_earth_branch(9) + "鸡抢米"
}

///|
// get_silkworm 几姑看蚕
pub fn KitchenGodSteed::get_silkworm(self : KitchenGodSteed) -> String {
  self.by_earth_branch(9) + "姑看蚕"
}

///|
// get_pig 几屠共猪
pub fn KitchenGodSteed::get_pig(self : KitchenGodSteed) -> String {
  self.by_earth_branch(11) + "屠共猪"
}

///|
// get_field 甲田几分
pub fn KitchenGodSteed::get_field(self : KitchenGodSteed) -> String {
  "甲田\{self.by_heaven_stem(0)}分"
}

///|
// get_cake 几人分饼
pub fn KitchenGodSteed::get_cake(self : KitchenGodSteed) -> String {
  self.by_heaven_stem(2) + "人分饼"
}

///|
// get_gold 几日得金
pub fn KitchenGodSteed::get_gold(self : KitchenGodSteed) -> String {
  self.by_heaven_stem(7) + "日得金"
}

///|
// get_people_cakes 几人几丙
pub fn KitchenGodSteed::get_people_cakes(self : KitchenGodSteed) -> String {
  "\{self.by_earth_branch(2)}人\{self.by_heaven_stem(2)}丙"
}

///|
// get_people_hoes 几人几锄
pub fn KitchenGodSteed::get_people_hoes(self : KitchenGodSteed) -> String {
  "\{self.by_earth_branch(2)}人\{self.by_heaven_stem(3)}锄"
}

///|
impl Culture for KitchenGodSteed with get_name(_ : KitchenGodSteed) -> String {
  "灶马头"
}

///|
impl Show for KitchenGodSteed with to_string(self : KitchenGodSteed) -> String {
  self.get_name()
}
