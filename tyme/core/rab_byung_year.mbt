///|
// RabByungYear 藏历年(公历1027年为藏历元年，第一饶迥火兔年）
pub struct RabByungYear {
  // 饶迥(胜生周)序号，从0开始
  rab_byung_index : Int
  // 五行索引，从0开始
  element_index : Int
  // 生肖索引，从0开始
  zodiac_index : Int
}

///|
extend RabByungYear with Culture::{get_name}

///|
extend RabByungYear with Show::{to_string}

///|
// validate 校验
pub fn RabByungYear::validate(year : Int) -> Result[Unit, String] {
  if year < 1027 || year > 9999 {
    return Err("illegal rab-byung year: " + year.to_string())
  }
  Ok(())
}

///|
// new 从索引构造
pub fn RabByungYear::new(
  rab_byung_index : Int,
  element_index : Int,
  zodiac_index : Int,
) -> Result[RabByungYear, String] {
  if rab_byung_index < 0 || rab_byung_index > 150 {
    return Err("illegal rab-byung index: " + rab_byung_index.to_string())
  }
  if element_index < 0 || element_index >= element_names().length() {
    return Err("illegal element index: " + element_index.to_string())
  }
  if zodiac_index < 0 || zodiac_index >= zodiac_names().length() {
    return Err("illegal zodiac index: " + zodiac_index.to_string())
  }
  Ok({ rab_byung_index, element_index, zodiac_index, })
}

///|
// from_sixty_cycle 从干支构造
pub fn RabByungYear::from_sixty_cycle(
  rab_byung_index : Int,
  sixty_cycle : SixtyCycle,
) -> Result[RabByungYear, String] {
  RabByungYear::new(
    rab_byung_index,
    sixty_cycle.get_heaven_stem().get_element().get_index(),
    sixty_cycle.get_earth_branch().get_zodiac().get_index(),
  )
}

///|
// from_element_zodiac 从五行生肖构造
pub fn RabByungYear::from_element_zodiac(
  rab_byung_index : Int,
  element : RabByungElement,
  zodiac : Zodiac,
) -> Result[RabByungYear, String] {
  RabByungYear::new(rab_byung_index, element.get_index(), zodiac.get_index())
}

///|
// from_year 从年构造
pub fn RabByungYear::from_year(year : Int) -> Result[RabByungYear, String] {
  match RabByungYear::validate(year) {
    Ok(_) =>
      RabByungYear::from_sixty_cycle(
        (year - 1024) / 60,
        SixtyCycle::from_index(year - 4),
      )
    Err(e) => Err(e)
  }
}

///|
// get_rab_byung_index 饶迥序号
pub fn RabByungYear::get_rab_byung_index(self : RabByungYear) -> Int {
  self.rab_byung_index
}

///|
// get_sixty_cycle 干支
pub fn RabByungYear::get_sixty_cycle(self : RabByungYear) -> SixtyCycle {
  SixtyCycle::from_index(
    6 * (self.element_index * 2 + self.zodiac_index % 2) - 5 * self.zodiac_index,
  )
}

///|
// get_zodiac 生肖
pub fn RabByungYear::get_zodiac(self : RabByungYear) -> Zodiac {
  Zodiac::from_index(self.zodiac_index)
}

///|
// get_element 五行
pub fn RabByungYear::get_element(self : RabByungYear) -> RabByungElement {
  RabByungElement::from_index(self.element_index)
}

///|
// get_year 年
pub fn RabByungYear::get_year(self : RabByungYear) -> Int {
  1024 + self.rab_byung_index * 60 + self.get_sixty_cycle().get_index()
}

///|
// get_leap_month 闰月
pub fn RabByungYear::get_leap_month(self : RabByungYear) -> Int {
  let mut n = 1
  let mut m = 4
  let mut t = 1
  let current_year = self.get_year()
  while n < current_year {
    let i = m + 31 + t
    n = n + 2
    m = i - 23
    if i > 35 {
      n = n + 1
      m = m - 12
    }
    t = 1 - t
  }
  if n == current_year {
    return m
  }
  0
}

///|
// get_solar_year 公历年
pub fn RabByungYear::get_solar_year(self : RabByungYear) -> SolarYear {
  match SolarYear::from_year(self.get_year()) {
    Ok(y) => y
    Err(_) => SolarYear::new(YearUnit::new(self.get_year()))
  }
}

///|
// get_first_month 首月
pub fn RabByungYear::get_first_month(self : RabByungYear) -> RabByungMonth {
  match RabByungMonth::new(self.get_year(), 1) {
    Ok(m) => m
    Err(_) =>
      {
        month_unit: MonthUnit::new(YearUnit::new(self.get_year()), 1),
        leap: false,
      }
  }
}

///|
// get_month_count 月数
pub fn RabByungYear::get_month_count(self : RabByungYear) -> Int {
  if self.get_leap_month() < 1 {
    return 12
  }
  13
}

///|
// get_months 月份列表
pub fn RabByungYear::get_months(self : RabByungYear) -> Array[RabByungMonth] {
  let months : Array[RabByungMonth] = []
  let leap_month = self.get_leap_month()
  let year = self.get_year()
  for i = 1; i < 13; i = i + 1 {
    match RabByungMonth::new(year, i) {
      Ok(m) => months.push(m)
      Err(_) => ()
    }
    if i == leap_month {
      match RabByungMonth::new(year, -i) {
        Ok(m) => months.push(m)
        Err(_) => ()
      }
    }
  }
  months
}

///|
// next 推移
pub fn RabByungYear::next(
  self : RabByungYear,
  n : Int,
) -> Result[RabByungYear, String] {
  RabByungYear::from_year(self.get_year() + n)
}

///|
// equals 是否相等（String() 恒空串，故恒 true）
pub fn RabByungYear::equals(self : RabByungYear, target : RabByungYear) -> Bool {
  self.to_string() == target.to_string()
}

///|
pub impl Culture for RabByungYear with fn get_name(self : RabByungYear) -> String {
  let digits = [
    "零", "一", "二", "三", "四", "五", "六", "七", "八", "九",
  ]
  let units = ["", "十", "百"]
  let mut n = self.rab_byung_index + 1
  let mut s = ""
  let mut pos = 0
  while n > 0 {
    let digit = n % 10
    if digit > 0 {
      s = digits[digit] + units[pos] + s
    } else if s != "" {
      s = digits[digit] + s
    }
    n = n / 10
    pos = pos + 1
  }
  if s.length() >= 2 &&
    s.unsafe_get(0).to_int() == '一'.to_int() &&
    s.unsafe_get(1).to_int() == '十'.to_int() {
    // 字节切片 s[3:] 恰去掉"一"（3 字节=1 码点），"一十六"→"十六"；MoonBit 按码点须用 1
    s = s[1:s.length()].to_owned()
  }
  "第\{s}饶迥\{self.get_element().get_name()}\{self.get_zodiac().get_name()}年"
}

///|
pub impl Show for RabByungYear with fn to_string(_ : RabByungYear) -> String {
  // RabByungYear 嵌入 AbstractTyme→AbstractCulture.String() 固定返回 GetName()==""（空串）
  ""
}
