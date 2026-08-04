///|
// solar_month_names 公历月名称
pub fn solar_month_names() -> Array[String] {
  [
    "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月",
    "11月", "12月",
  ]
}

///|
// solar_month_days 各月天数（平年）
pub fn solar_month_days() -> Array[Int] {
  [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
}

///|
// SolarMonth 公历月
pub struct SolarMonth {
  month_unit : MonthUnit
}

///|
extend SolarMonth with Culture::{get_name}

///|
extend SolarMonth with Show::{to_string}

///|
extend SolarMonth with Tyme::{next}

///|
pub fn SolarMonth::new(month_unit : MonthUnit) -> SolarMonth {
  { month_unit, }
}

///|
// equals 是否相等
pub fn SolarMonth::equals(self : SolarMonth, target : SolarMonth) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year 年
pub fn SolarMonth::get_year(self : SolarMonth) -> Int {
  self.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn SolarMonth::get_month(self : SolarMonth) -> Int {
  self.month_unit.get_month()
}

///|
// validate 校验
pub fn SolarMonth::validate(year : Int, month : Int) -> Result[Unit, String] {
  if month < 1 || month > 12 {
    return Err("illegal solar month: " + month.to_string())
  }
  SolarYear::validate(year)
}

///|
// from_ym 从年月构造
pub fn SolarMonth::from_ym(
  year : Int,
  month : Int,
) -> Result[SolarMonth, String] {
  match SolarMonth::validate(year, month) {
    Ok(_) =>
      Ok(SolarMonth::{ month_unit: MonthUnit::new(YearUnit::new(year), month) })
    Err(e) => Err(e)
  }
}

///|
// get_solar_year 公历年
pub fn SolarMonth::get_solar_year(self : SolarMonth) -> SolarYear {
  match SolarYear::from_year(self.get_year()) {
    Ok(y) => y
    Err(_) => SolarYear::new(YearUnit::new(self.get_year()))
  }
}

///|
// get_index_in_year 位于当年的索引(0-11)
pub fn SolarMonth::get_index_in_year(self : SolarMonth) -> Int {
  self.get_month() - 1
}

///|
// get_day_count 天数（1582年10月只有21天）
pub fn SolarMonth::get_day_count(self : SolarMonth) -> Int {
  if self.get_year() == 1582 && self.get_month() == 10 {
    return 21
  }
  let d = solar_month_days()[self.get_index_in_year()]
  if self.get_month() == 2 && self.get_solar_year().is_leap() {
    d + 1
  } else {
    d
  }
}

///|
// get_week_count 周数
pub fn SolarMonth::get_week_count(self : SolarMonth, start : Int) -> Int {
  match SolarDay::from_ymd(self.get_year(), self.get_month(), 1) {
    Ok(d) =>
      @math.ceil(
        (AbstractCulture::index_of(d.get_week().get_index() - start, 7) +
        self.get_day_count()).to_double() /
        7.0,
      ).to_int()
    Err(_) => 0
  }
}

///|
// get_days 本月公历日列表
// ⚠️ 1582 年 10 月 GetDayCount()==21，循环会取到被历法改革跳过的 10/5–10/14，
// 此处跳过非法日，返回该月真实存在的 11 天（1–4、15–21）。
// 该用例无法做差分对拍，已在 xref 测试中排除 1582-10。
pub fn SolarMonth::get_days(self : SolarMonth) -> Array[SolarDay] {
  let l : Array[SolarDay] = []
  let size = self.get_day_count()
  for i = 1; i <= size; i = i + 1 {
    match SolarDay::from_ymd(self.get_year(), self.get_month(), i) {
      Ok(d) => l.push(d)
      Err(_) => ()
    }
  }
  l
}

///|
// get_first_day 本月第1天
pub fn SolarMonth::get_first_day(self : SolarMonth) -> SolarDay {
  match SolarDay::from_ymd(self.get_year(), self.get_month(), 1) {
    Ok(d) => d
    Err(_) =>
      SolarDay::new(
        DayUnit::new(
          MonthUnit::new(YearUnit::new(self.get_year()), self.get_month()),
          1,
        ),
      )
  }
}

///|
// get_weeks 本月公历周列表（参数 start：起始星期，1234560 分别代表星期一至星期天）
pub fn SolarMonth::get_weeks(
  self : SolarMonth,
  start : Int,
) -> Array[SolarWeek] {
  let size = self.get_week_count(start)
  let l : Array[SolarWeek] = []
  for i = 0; i < size; i = i + 1 {
    match SolarWeek::from_ym(self.get_year(), self.get_month(), i, start) {
      Ok(w) => l.push(w)
      Err(_) => ()
    }
  }
  l
}

// 注（2026-08-02 23:20 更新）：get_weeks(start) 已随 SolarWeek 译出而补齐；此前因 SolarWeek 未译而延后。
//   get_week_count / get_days / get_first_day 此前已随 SolarDay.from_ymd 译出。

///|
impl Culture for SolarMonth with fn get_name(self : SolarMonth) -> String {
  solar_month_names()[self.get_index_in_year()]
}

///|
impl Show for SolarMonth with fn to_string(self : SolarMonth) -> String {
  self.get_solar_year().to_string() + self.get_name()
}

///|
impl Tyme for SolarMonth with fn next(self : SolarMonth, n : Int) -> SolarMonth {
  let i = self.get_month() - 1 + n
  match
    SolarMonth::from_ym(
      (self.get_year() * 12 + i) / 12,
      AbstractCulture::index_of(i, 12) + 1,
    ) {
    Ok(m) => m
    Err(_) => self
  }
}
