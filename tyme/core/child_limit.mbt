///|
// child_limit_provider 童限计算接口实现（全局可变，可通过 ChildLimit::set_provider 切换）
pub let child_limit_provider : Ref[&IChildLimitProvider] = Ref::{
  val: DefaultChildLimitProvider::{ },
}

///|
// ChildLimit 童限
pub struct ChildLimit {
  // 八字
  eight_char : EightChar
  // 性别
  gender : Gender
  // 顺逆
  forward : Bool
  // 童限信息
  info : ChildLimitInfo
}

///|
// child_limit_of 共享构造：四柱已给定，节令与童限差值一律按钟表绝对时刻计算
fn child_limit_of(
  eight_char : EightChar,
  birth_time : SolarTime,
  gender : Gender,
) -> ChildLimit {
  // 阳男阴女顺推，阴男阳女逆推
  let yang = eight_char.get_year().get_heaven_stem().get_yin_yang().get_code() ==
    1
  let man = gender.get_code() == 1
  let forward = (yang && man) || (!yang && !man)
  let mut term = birth_time.get_term()
  if !term.is_jie() {
    term = term.next(-1)
  }
  if forward {
    term = term.next(2)
  }
  let info = child_limit_provider.val.get_info(birth_time, term)
  { eight_char, gender, forward, info, }
}

///|
// from_solar_time 从出生公历时刻与性别构造
pub fn ChildLimit::from_solar_time(
  birth_time : SolarTime,
  gender : Gender,
) -> ChildLimit {
  child_limit_of(
    birth_time.get_lunar_hour().get_eight_char(),
    birth_time,
    gender,
  )
}

///|
// from_true_solar_time 从出生钟表时刻（北京时间）、性别与出生地经度构造（真太阳时版）
// 四柱按真太阳时读数计算；节令判断与起运时间差仍按钟表绝对时刻，
// 避免真太阳时读数与钟表系节气时刻混用导致的时间差扭曲（西部经度差可达 2 小时）。
// longitude: 出生地经度（东正西负，如北京 116.39、乌鲁木齐 87.62）
pub fn ChildLimit::from_true_solar_time(
  birth_time : SolarTime,
  gender : Gender,
  longitude : Double,
) -> ChildLimit {
  let tst = birth_time.to_true_solar_time(longitude)
  child_limit_of(tst.get_lunar_hour().get_eight_char(), birth_time, gender)
}

///|
// get_eight_char 八字
pub fn ChildLimit::get_eight_char(self : ChildLimit) -> EightChar {
  self.eight_char
}

///|
// get_gender 性别
pub fn ChildLimit::get_gender(self : ChildLimit) -> Gender {
  self.gender
}

///|
// is_forward 是否顺推
pub fn ChildLimit::is_forward(self : ChildLimit) -> Bool {
  self.forward
}

///|
// get_year_count 年数
pub fn ChildLimit::get_year_count(self : ChildLimit) -> Int {
  self.info.get_year_count()
}

///|
// get_month_count 月数
pub fn ChildLimit::get_month_count(self : ChildLimit) -> Int {
  self.info.get_month_count()
}

///|
// get_day_count 日数
pub fn ChildLimit::get_day_count(self : ChildLimit) -> Int {
  self.info.get_day_count()
}

///|
// get_hour_count 小时数
pub fn ChildLimit::get_hour_count(self : ChildLimit) -> Int {
  self.info.get_hour_count()
}

///|
// get_minute_count 分钟数
pub fn ChildLimit::get_minute_count(self : ChildLimit) -> Int {
  self.info.get_minute_count()
}

///|
// get_start_time 开始(即出生)的公历时刻
pub fn ChildLimit::get_start_time(self : ChildLimit) -> SolarTime {
  self.info.get_start_time()
}

///|
// get_end_time 结束(即开始起运)的公历时刻
pub fn ChildLimit::get_end_time(self : ChildLimit) -> SolarTime {
  self.info.get_end_time()
}

///|
// get_start_decade_fortune 起运大运
pub fn ChildLimit::get_start_decade_fortune(self : ChildLimit) -> DecadeFortune {
  DecadeFortune::from_child_limit(self, 0)
}

///|
// get_decade_fortune 所属大运
pub fn ChildLimit::get_decade_fortune(self : ChildLimit) -> DecadeFortune {
  DecadeFortune::from_child_limit(self, -1)
}

///|
// get_start_fortune 小运
pub fn ChildLimit::get_start_fortune(self : ChildLimit) -> Fortune {
  Fortune::from_child_limit(self, 0)
}

///|
// get_end_lunar_year 结束农历年（已标记 Deprecated）
pub fn ChildLimit::get_end_lunar_year(self : ChildLimit) -> LunarYear {
  LunarYear::from_year(
    self.get_start_time().get_lunar_hour().get_year() +
    self.get_end_time().get_year() -
    self.get_start_time().get_year(),
  ).unwrap()
}

///|
// get_start_sixty_cycle_year 开始(即出生)干支年
pub fn ChildLimit::get_start_sixty_cycle_year(
  self : ChildLimit,
) -> SixtyCycleYear {
  SixtyCycleYear::from_year(self.get_start_time().get_year()).unwrap()
}

///|
// get_end_sixty_cycle_year 结束(即起运)干支年
pub fn ChildLimit::get_end_sixty_cycle_year(
  self : ChildLimit,
) -> SixtyCycleYear {
  SixtyCycleYear::from_year(self.get_end_time().get_year()).unwrap()
}

///|
// get_start_age 开始年龄
pub fn ChildLimit::get_start_age(_ : ChildLimit) -> Int {
  1
}

///|
// get_end_age 结束年龄
pub fn ChildLimit::get_end_age(self : ChildLimit) -> Int {
  let n = self.get_end_sixty_cycle_year().get_year() -
    self.get_start_sixty_cycle_year().get_year()
  if n > 1 {
    return n
  }
  1
}

///|
// set_provider 切换童限计算接口实现
pub fn ChildLimit::set_provider(p : &IChildLimitProvider) -> Unit {
  child_limit_provider.val = p
}

///|
pub impl Show for ChildLimit with fn to_string(self : ChildLimit) -> String {
  self.get_eight_char().to_string() +
  " " +
  self.get_gender().to_string() +
  " " +
  (if self.is_forward() { "顺" } else { "逆" }) +
  " " +
  self.info.to_string()
}
