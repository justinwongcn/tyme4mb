// two_digits 两位补零

///|
fn two_digits(n : Int) -> String {
  if n < 10 {
    "0" + n.to_string()
  } else {
    n.to_string()
  }
}

///|
// SolarTime 公历时刻
pub struct SolarTime {
  second_unit : SecondUnit
}

///|
extend SolarTime with Culture::{get_name}

///|
extend SolarTime with Show::{to_string}

///|
pub fn SolarTime::new(second_unit : SecondUnit) -> SolarTime {
  { second_unit, }
}

///|
// equals 是否相等
pub fn SolarTime::equals(self : SolarTime, target : SolarTime) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_year 年
pub fn SolarTime::get_year(self : SolarTime) -> Int {
  self.second_unit.day_unit.month_unit.year_unit.get_year()
}

///|
// get_month 月
pub fn SolarTime::get_month(self : SolarTime) -> Int {
  self.second_unit.day_unit.month_unit.get_month()
}

///|
// get_day 日
pub fn SolarTime::get_day(self : SolarTime) -> Int {
  self.second_unit.day_unit.get_day()
}

///|
// get_hour 时
pub fn SolarTime::get_hour(self : SolarTime) -> Int {
  self.second_unit.get_hour()
}

///|
// get_minute 分
pub fn SolarTime::get_minute(self : SolarTime) -> Int {
  self.second_unit.get_minute()
}

///|
// get_second 秒
pub fn SolarTime::get_second(self : SolarTime) -> Int {
  self.second_unit.get_second()
}

///|
// get_julian_day 儒略日
pub fn SolarTime::get_julian_day(self : SolarTime) -> JulianDay {
  JulianDay::from_ymdhms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    self.get_hour(),
    self.get_minute(),
    self.get_second(),
  )
}

///|
// get_compare_index 用于比较大小的索引
pub fn SolarTime::get_compare_index(self : SolarTime) -> Int64 {
  self.second_unit.get_compare_index()
}

///|
// is_before 是否在指定公历时刻之前
pub fn SolarTime::is_before(self : SolarTime, target : SolarTime) -> Bool {
  self.get_compare_index() < target.get_compare_index()
}

///|
// is_after 是否在指定公历时刻之后
pub fn SolarTime::is_after(self : SolarTime, target : SolarTime) -> Bool {
  self.get_compare_index() > target.get_compare_index()
}

///|
// validate 校验
pub fn SolarTime::validate(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[Unit, String] {
  match SecondUnit::validate(year, month, day, hour, minute, second) {
    Ok(_) => SolarDay::validate(year, month, day)
    Err(e) => Err(e)
  }
}

///|
// from_ymdhms 从年月日时分秒构造
pub fn SolarTime::from_ymdhms(
  year : Int,
  month : Int,
  day : Int,
  hour : Int,
  minute : Int,
  second : Int,
) -> Result[SolarTime, String] {
  match SolarTime::validate(year, month, day, hour, minute, second) {
    Ok(_) =>
      Ok({
        second_unit: SecondUnit::new(
          DayUnit::new(MonthUnit::new(YearUnit::new(year), month), day),
          hour,
          minute,
          second,
        ),
      })
    Err(e) => Err(e)
  }
}

///|
// get_solar_day 公历日
pub fn SolarTime::get_solar_day(self : SolarTime) -> SolarDay {
  match SolarDay::from_ymd(self.get_year(), self.get_month(), self.get_day()) {
    Ok(d) => d
    Err(_) => SolarDay::new(self.second_unit.day_unit)
  }
}

///|
// next 偏移 n 秒
pub fn SolarTime::next(self : SolarTime, n : Int) -> SolarTime {
  if n == 0 {
    match
      SolarTime::from_ymdhms(
        self.get_year(),
        self.get_month(),
        self.get_day(),
        self.get_hour(),
        self.get_minute(),
        self.get_second(),
      ) {
      Ok(t) => t
      Err(_) => SolarTime::new(self.second_unit)
    }
  } else {
    let ts = self.get_hour() * 3600 +
      self.get_minute() * 60 +
      self.get_second() +
      n
    let s = AbstractCulture::index_of(ts, 86400)
    let d = self.get_solar_day().next(AbstractCulture::floor_div(ts, 86400))
    match
      SolarTime::from_ymdhms(
        d.get_year(),
        d.get_month(),
        d.get_day(),
        s / 3600,
        s % 3600 / 60,
        s % 60,
      ) {
      Ok(t) => t
      Err(_) => SolarTime::new(self.second_unit)
    }
  }
}

///|
// subtract 公历时刻相减，获得相差秒数
// 注：此处乘以 86400 必须用 Int64 防止 32 位静默溢出
pub fn SolarTime::subtract(self : SolarTime, target : SolarTime) -> Int64 {
  self.get_solar_day().subtract(target.get_solar_day()).to_int64() * 86400L +
  self.second_unit.get_seconds_in_day().to_int64() -
  target.second_unit.get_seconds_in_day().to_int64()
}

///|
// get_term 节气
pub fn SolarTime::get_term(self : SolarTime) -> SolarTerm {
  let mut term = self.get_solar_day().get_term()
  if self.is_before(term.get_julian_day().get_solar_time_unchecked()) {
    term = term.next(-1)
  }
  term
}

///|
// get_phenology 候
pub fn SolarTime::get_phenology(self : SolarTime) -> Phenology {
  let mut p = self.get_solar_day().get_phenology()
  if self.is_before(p.get_julian_day().get_solar_time_unchecked()) {
    p = p.next(-1)
  }
  p
}

///|
// get_phase 月相（先经农历时辰→农历日→农历月，取次月首朔推算）
pub fn SolarTime::get_phase(self : SolarTime) -> Phase {
  let month = self.get_lunar_hour().get_lunar_day().get_lunar_month().next(1)
  let mut p = Phase::from_index(
    month.get_year(),
    month.get_month_with_leap(),
    0,
  )
  while p.get_solar_time().is_after(self) {
    p = p.next(-1)
  }
  p
}

///|
// get_lunar_hour 农历时辰（先经 GetSolarDay().GetLunarDay() 做公历→农历转换）
pub fn SolarTime::get_lunar_hour(self : SolarTime) -> LunarHour {
  let d = self.get_solar_day().get_lunar_day()
  LunarHour::from_ymd_hms(
    d.get_year(),
    d.get_month(),
    d.get_day(),
    self.get_hour(),
    self.get_minute(),
    self.get_second(),
  ).unwrap()
}

///|
// get_sixty_cycle_hour 干支时辰
pub fn SolarTime::get_sixty_cycle_hour(self : SolarTime) -> SixtyCycleHour {
  SixtyCycleHour::from_solar_time(self)
}

///|
// td_centuries_at 时刻对应的 J2000 起力学时世纪数（北京时间儒略日 → UT → ΔT → TD）
fn SolarTime::td_centuries_at(self : SolarTime) -> Double {
  let jd = self.get_julian_day().get_day() // 北京时间儒略日
  let jd_ut = jd - OneThird // → UT（减 8h）
  let t_ut = jd_ut - J2000.to_double() // J2000 起 UT 天数
  let dt = dt_t(t_ut) // ΔT（天）
  (t_ut + dt) / 36525.0 // J2000 起 TD 世纪数
}

///|
// eot_seconds_at 均时差（秒，未取整）
fn SolarTime::eot_seconds_at(self : SolarTime) -> Double {
  equation_of_time(self.td_centuries_at()) * 3600.0
}

///|
// to_true_solar_time 真太阳时
// 根据出生地经度将钟表时间（北京时间 UTC+8）转换为真太阳时
// longitude: 经度（东正西负，如北京 116.39）
// 真太阳时 = 钟表时间 + (经度 - 120°) × 4分钟/度 + 均时差
pub fn SolarTime::to_true_solar_time(
  self : SolarTime,
  longitude : Double,
) -> SolarTime {
  // 经度修正 + 均时差 → 总修正秒数
  let lon_corr = (longitude - 120.0) * 240.0 // (经度-标准经度)×4min/度 → 秒
  let eot_corr = self.eot_seconds_at() // 均时差 → 秒
  let total = @math.round(lon_corr + eot_corr).to_int()

  // 偏移并返回新的 SolarTime
  self.next(total)
}

///|
// get_solar_noon 太阳正午（真太阳时 12:00）对应的钟表时刻，为 to_true_solar_time 的逆运算
// 正午 = 12:00 − 经度修正 − 均时差；均时差取当日 12:00 处的值
//（均时差随日期缓慢变化，在正午偏移窗口内（西部最大约 2 小时）的漂移约 1 秒量级，不影响分钟级精度）
// longitude: 经度（东正西负）；极端经度差下返回值可能落在相邻日期
pub fn SolarTime::get_solar_noon(
  self : SolarTime,
  longitude : Double,
) -> SolarTime {
  let noon0 = SolarTime::from_ymdhms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    12,
    0,
    0,
  ).unwrap()
  let lon_corr = (longitude - 120.0) * 240.0
  let offset = @math.round(lon_corr + noon0.eot_seconds_at()).to_int()
  noon0.next(-offset)
}

///|
// sun_half_day_seconds 半昼长（秒）
// cos H = (cos(90° + 0.833°) − sinφ·sinδ) / (cosφ·cosδ)
// 0.833° = 大气折射 34′ + 太阳视半径 16′；δ 取当日 12:00 时的值
// 极昼（太阳终日在地平线上）或极夜（终日在地平线下）返回 None
fn SolarTime::sun_half_day_seconds(
  self : SolarTime,
  latitude : Double,
) -> Double? {
  let noon0 = SolarTime::from_ymdhms(
    self.get_year(),
    self.get_month(),
    self.get_day(),
    12,
    0,
    0,
  ).unwrap()
  let rad = @math.PI / 180.0
  let decl = solar_declination(noon0.td_centuries_at())
  let cos_h = (@math.cos(90.833 * rad) -
    @math.sin(latitude * rad) * @math.sin(decl)) /
    (@math.cos(latitude * rad) * @math.cos(decl))
  if cos_h < -1.0 || cos_h > 1.0 {
    return None
  }
  // 时角弧度 → 小时（π = 12 小时）→ 秒
  Some(@math.acos(cos_h) * 12.0 / @math.PI * 3600.0)
}

///|
// get_sunrise 日出钟表时刻（太阳视半径 16′ + 大气折射 34′，精度约 ±1 分钟）
// 极昼或极夜返回 None（可用 get_solar_noon 时刻太阳在地平线上/下区分二者）
// latitude: 纬度（北正南负）；longitude: 经度（东正西负）
pub fn SolarTime::get_sunrise(
  self : SolarTime,
  latitude : Double,
  longitude : Double,
) -> SolarTime? {
  match self.sun_half_day_seconds(latitude) {
    None => None
    Some(h) =>
      Some(self.get_solar_noon(longitude).next(-@math.round(h).to_int()))
  }
}

///|
// get_sunset 日落钟表时刻（太阳视半径 16′ + 大气折射 34′，精度约 ±1 分钟）
// 极昼或极夜返回 None
// latitude: 纬度（北正南负）；longitude: 经度（东正西负）
pub fn SolarTime::get_sunset(
  self : SolarTime,
  latitude : Double,
  longitude : Double,
) -> SolarTime? {
  match self.sun_half_day_seconds(latitude) {
    None => None
    Some(h) =>
      Some(self.get_solar_noon(longitude).next(@math.round(h).to_int()))
  }
}

///|
pub impl Culture for SolarTime with fn get_name(self : SolarTime) -> String {
  two_digits(self.get_hour()) +
  ":" +
  two_digits(self.get_minute()) +
  ":" +
  two_digits(self.get_second())
}

///|
pub impl Show for SolarTime with fn to_string(self : SolarTime) -> String {
  self.get_solar_day().to_string() + " " + self.get_name()
}
