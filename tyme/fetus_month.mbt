///|
// FetusMonth 逐月胎神（正十二月在床房，二三九十门户中，四六十一灶勿犯，五甲七子八厕凶。）
pub struct FetusMonth {
  loop_tyme : LoopTyme
}

///|
// fetus_month_names 逐月胎神名称
pub fn fetus_month_names() -> Array[String] {
  ["占房床", "占户窗", "占门堂", "占厨灶", "占房床", "占床仓", "占碓磨", "占厕户", "占门房", "占房床", "占灶炉", "占房床"]
}

///|
// new 从索引构造
pub fn FetusMonth::new(index : Int) -> FetusMonth {
  FetusMonth::{
    loop_tyme : LoopTyme::from_index(fetus_month_names(), index),
  }
}

///|
// from_lunar_month 从农历月初始化
pub fn FetusMonth::from_lunar_month(lunar_month : LunarMonth) -> Option[FetusMonth] {
  if lunar_month.is_leap() {
    return None
  }
  Some(FetusMonth::new(lunar_month.get_month() - 1))
}

///|
// next 推移
pub fn FetusMonth::next(self : FetusMonth, n : Int) -> FetusMonth {
  FetusMonth::new(self.loop_tyme.next_index(n))
}

///|
// get_index 索引
pub fn FetusMonth::get_index(self : FetusMonth) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_name 名称
pub fn FetusMonth::get_name(self : FetusMonth) -> String {
  fetus_month_names()[self.loop_tyme.get_index()]
}

///|
impl Culture for FetusMonth with get_name(self : FetusMonth) -> String {
  self.get_name()
}

///|
impl Show for FetusMonth with to_string(self : FetusMonth) -> String {
  self.get_name()
}

///|
impl Tyme for FetusMonth with next(
  self : FetusMonth,
  n : Int,
) -> FetusMonth {
  self.next(n)
}
