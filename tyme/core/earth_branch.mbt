///|
// EarthBranchNames 地支名称
pub fn earth_branch_names() -> Array[String] {
  [
    "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌",
    "亥",
  ]
}

///|
// EarthBranch 地支（地元）
pub struct EarthBranch {
  loop_tyme : LoopTyme
}

///|
extend EarthBranch with Culture::{get_name}

///|
extend EarthBranch with Show::{to_string}

///|
extend EarthBranch with Tyme::{next}

///|
pub fn EarthBranch::get_index(self : EarthBranch) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn EarthBranch::get_size(self : EarthBranch) -> Int {
  self.loop_tyme.get_size()
}

///|
pub fn EarthBranch::steps_to(self : EarthBranch, target_index : Int) -> Int {
  self.loop_tyme.steps_to(target_index)
}

///|
pub fn EarthBranch::steps_back_to(
  self : EarthBranch,
  target_index : Int,
) -> Int {
  self.loop_tyme.steps_back_to(target_index)
}

///|
pub fn EarthBranch::steps_close_to(
  self : EarthBranch,
  target_index : Int,
) -> Int {
  self.loop_tyme.steps_close_to(target_index)
}

///|
pub fn EarthBranch::from_index(index : Int) -> EarthBranch {
  { loop_tyme: LoopTyme::from_index(earth_branch_names(), index), }
}

///|
pub fn EarthBranch::from_name(name : String) -> Result[EarthBranch, String] {
  match LoopTyme::from_name(earth_branch_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, })
    Err(e) => Err(e)
  }
}

///|
pub fn EarthBranch::equals(self : EarthBranch, target : EarthBranch) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_element 五行
pub fn EarthBranch::get_element(self : EarthBranch) -> Element {
  let a = [4, 2, 0, 0, 2, 1, 1, 2, 3, 3, 2, 4]
  Element::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_yin_yang 阴阳
pub fn EarthBranch::get_yin_yang(self : EarthBranch) -> YinYang {
  if self.loop_tyme.get_index() % 2 == 0 {
    @base.Yang
  } else {
    @base.Yin
  }
}

///|
// get_hide_heaven_stem_main 藏干之本气
pub fn EarthBranch::get_hide_heaven_stem_main(self : EarthBranch) -> HeavenStem {
  let a = [9, 5, 0, 1, 4, 2, 3, 5, 6, 7, 4, 8]
  HeavenStem::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_hide_heaven_stem_middle 藏干之中气，无中气返回None
pub fn EarthBranch::get_hide_heaven_stem_middle(
  self : EarthBranch,
) -> HeavenStem? {
  let a = [-1, 9, 2, -1, 1, 6, 5, 3, 8, -1, 7, 0]
  let n = a[self.loop_tyme.get_index()]
  if n == -1 {
    None
  } else {
    Some(HeavenStem::from_index(n))
  }
}

///|
// get_hide_heaven_stem_residual 藏干之余气，无余气返回None
pub fn EarthBranch::get_hide_heaven_stem_residual(
  self : EarthBranch,
) -> HeavenStem? {
  let a = [-1, 7, 4, -1, 9, 4, -1, 1, 4, -1, 3, -1]
  let n = a[self.loop_tyme.get_index()]
  if n == -1 {
    None
  } else {
    Some(HeavenStem::from_index(n))
  }
}

///|
// get_hide_heaven_stems 藏干列表
pub fn EarthBranch::get_hide_heaven_stems(
  self : EarthBranch,
) -> Array[HideHeavenStem] {
  let l : Array[HideHeavenStem] = []
  let main = self.get_hide_heaven_stem_main()
  l.push(HideHeavenStem::from_index(main.get_index(), Main))
  match self.get_hide_heaven_stem_middle() {
    Some(m) => l.push(HideHeavenStem::from_index(m.get_index(), Middle))
    None => ()
  }
  match self.get_hide_heaven_stem_residual() {
    Some(r) => l.push(HideHeavenStem::from_index(r.get_index(), Residual))
    None => ()
  }
  l
}

///|
// get_zodiac 生肖
pub fn EarthBranch::get_zodiac(self : EarthBranch) -> Zodiac {
  Zodiac::from_index(self.loop_tyme.get_index())
}

///|
// get_direction 方位
pub fn EarthBranch::get_direction(self : EarthBranch) -> Direction {
  let a = [0, 4, 2, 2, 4, 8, 8, 4, 6, 6, 4, 0]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_ominous 煞（逢巳日、酉日、丑日必煞东；亥日、卯日、未日必煞西；申日、子日、辰日必煞南；寅日、午日、戌日必煞北。）
pub fn EarthBranch::get_ominous(self : EarthBranch) -> Direction {
  let a = [8, 2, 0, 6]
  Direction::from_index(a[self.loop_tyme.get_index() % 4])
}

///|
// get_peng_zu_earth_branch 地支彭祖百忌
pub fn EarthBranch::get_peng_zu_earth_branch(
  self : EarthBranch,
) -> PengZuEarthBranch {
  PengZuEarthBranch::from_index(self.loop_tyme.get_index())
}

///|
// get_opposite 六冲（子午冲，丑未冲，寅申冲，辰戌冲，卯酉冲，巳亥冲）
pub fn EarthBranch::get_opposite(self : EarthBranch) -> EarthBranch {
  self.next(6)
}

///|
// get_combine 六合（子丑合，寅亥合，卯戌合，辰酉合，巳申合，午未合）
pub fn EarthBranch::get_combine(self : EarthBranch) -> EarthBranch {
  EarthBranch::from_index(1 - self.loop_tyme.get_index())
}

///|
// get_harm 六害（子未害、丑午害、寅巳害、卯辰害、申亥害、酉戌害）
pub fn EarthBranch::get_harm(self : EarthBranch) -> EarthBranch {
  EarthBranch::from_index(19 - self.loop_tyme.get_index())
}

///|
// combine 合化（子丑合化土，寅亥合化木，卯戌合化火，辰酉合化金，巳申合化水，午未合化土），如果无法合化，返回None
pub fn EarthBranch::combine(
  self : EarthBranch,
  target : EarthBranch,
) -> Element? {
  if self.get_combine().equals(target) {
    let a = [2, 2, 0, 1, 3, 4, 2, 2, 4, 3, 1, 0]
    Some(Element::from_index(a[self.loop_tyme.get_index()]))
  } else {
    None
  }
}

///|
// get_po 六破（子酉破、丑辰破、寅亥破、卯午破、巳申破、戌未破），互破对称
pub fn EarthBranch::get_po(self : EarthBranch) -> EarthBranch {
  let a = [9, 4, 11, 6, 1, 8, 3, 10, 5, 0, 7, 2]
  EarthBranch::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_jue 地支绝（子巳、亥午、寅酉、卯申），土支不参与
pub fn EarthBranch::get_jue(self : EarthBranch) -> EarthBranch? {
  let a = [5, -1, 9, 8, -1, 0, 11, -1, 3, 2, -1, 6]
  let n = a[self.loop_tyme.get_index()]
  if n < 0 {
    None
  } else {
    Some(EarthBranch::from_index(n))
  }
}

///|
// get_xing 地支刑（三刑与自刑）
pub fn EarthBranch::get_xing(self : EarthBranch) -> Array[EarthBranch] {
  match self.loop_tyme.get_index() {
    0 => [EarthBranch::from_index(3)]
    1 => [EarthBranch::from_index(7), EarthBranch::from_index(10)]
    2 => [EarthBranch::from_index(5), EarthBranch::from_index(8)]
    3 => [EarthBranch::from_index(0)]
    4 => [EarthBranch::from_index(4)]
    5 => [EarthBranch::from_index(2), EarthBranch::from_index(8)]
    6 => [EarthBranch::from_index(6)]
    7 => [EarthBranch::from_index(1), EarthBranch::from_index(10)]
    8 => [EarthBranch::from_index(2), EarthBranch::from_index(5)]
    9 => [EarthBranch::from_index(9)]
    10 => [EarthBranch::from_index(1), EarthBranch::from_index(7)]
    11 => [EarthBranch::from_index(11)]
    _ => []
  }
}

///|
// get_an_he 地支暗合（寅丑、卯申、午亥）
pub fn EarthBranch::get_an_he(self : EarthBranch) -> EarthBranch? {
  let a = [-1, 2, 1, 8, -1, -1, 11, -1, 3, -1, -1, 6]
  let n = a[self.loop_tyme.get_index()]
  if n < 0 {
    None
  } else {
    Some(EarthBranch::from_index(n))
  }
}

///|
// get_san_he_element 三合局五行（申子辰合水局，寅午戌合火局，巳酉丑合金局，亥卯未合木局）
pub fn EarthBranch::get_san_he_element(self : EarthBranch) -> Element {
  let a = [4, 3, 1, 0, 4, 3, 1, 0, 4, 3, 1, 0]
  Element::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_san_hui_element 三会方局五行（亥子丑会北方水，寅卯辰会东方木，巳午未会南方火，申酉戌会西方金）
pub fn EarthBranch::get_san_hui_element(self : EarthBranch) -> Element {
  let a = [4, 4, 0, 0, 0, 1, 1, 1, 3, 3, 3, 4]
  Element::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_san_hui_direction 三会方局方位（亥子丑会北方，寅卯辰会东方，巳午未会南方，申酉戌会西方）
pub fn EarthBranch::get_san_hui_direction(self : EarthBranch) -> Direction {
  let a = [0, 0, 2, 2, 2, 8, 8, 8, 6, 6, 6, 0]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
pub impl Culture for EarthBranch with fn get_name(self : EarthBranch) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for EarthBranch with fn to_string(self : EarthBranch) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for EarthBranch with fn next(self : EarthBranch, n : Int) -> EarthBranch {
  EarthBranch::from_index(self.loop_tyme.get_index() + n)
}
