///|
// AbstractChildLimitProvider 童限计算抽象（next 为无 self 使用方法 → 关联函数）
#warnings("-struct_never_constructed")
pub struct AbstractChildLimitProvider {}

///|
pub fn AbstractChildLimitProvider::next(
  birth_time : SolarTime,
  add_year : Int,
  add_month : Int,
  add_day : Int,
  add_hour : Int,
  add_minute : Int,
  add_second : Int,
) -> ChildLimitInfo {
  let mut d = birth_time.get_day() + add_day
  let mut h = birth_time.get_hour() + add_hour
  let mut mi = birth_time.get_minute() + add_minute
  let mut s = birth_time.get_second() + add_second
  mi = mi + s / 60
  s = s % 60
  h = h + mi / 60
  mi = mi % 60
  d = d + h / 24
  h = h % 24
  let mt = SolarMonth::from_ym(
    birth_time.get_year() + add_year,
    birth_time.get_month(),
  ).unwrap()
  let mut sm = mt.next(add_month)
  let mut dc = sm.get_day_count()
  while d > dc {
    d = d - dc
    sm = sm.next(1)
    dc = sm.get_day_count()
  }
  let t = SolarTime::from_ymdhms(sm.get_year(), sm.get_month(), d, h, mi, s).unwrap()
  ChildLimitInfo::new(
    birth_time, t, add_year, add_month, add_day, add_hour, add_minute,
  )
}
