///|
// HeavenStemNames 天干名称
pub fn heaven_stem_names() -> Array[String] {
  ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
}

///|
// HeavenStem 天干（天元）
pub struct HeavenStem {
  loop_tyme : LoopTyme
}

///|
extend HeavenStem with Culture::{get_name}

///|
extend HeavenStem with Show::{to_string}

///|
extend HeavenStem with Tyme::{next}

///|
pub fn HeavenStem::get_index(self : HeavenStem) -> Int {
  self.loop_tyme.get_index()
}

///|
pub fn HeavenStem::from_index(index : Int) -> HeavenStem {
  HeavenStem::{ loop_tyme: LoopTyme::from_index(heaven_stem_names(), index) }
}

///|
pub fn HeavenStem::from_name(name : String) -> Result[HeavenStem, String] {
  match LoopTyme::from_name(heaven_stem_names(), name) {
    Ok(p) => Ok(HeavenStem::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn HeavenStem::equals(self : HeavenStem, target : HeavenStem) -> Bool {
  self.to_string() == target.to_string()
}

///|
// get_element 五行
pub fn HeavenStem::get_element(self : HeavenStem) -> Element {
  Element::from_index(self.loop_tyme.get_index() / 2)
}

///|
// get_yin_yang 阴阳
pub fn HeavenStem::get_yin_yang(self : HeavenStem) -> YinYang {
  if self.loop_tyme.get_index() % 2 == 0 {
    Yang
  } else {
    Yin
  }
}

///|
// get_ten_star 十神（生我者，正印偏印。我生者，伤官食神。克我者，正官七杀。我克者，正财偏财。同我者，劫财比肩。）
pub fn HeavenStem::get_ten_star(self : HeavenStem, target : HeavenStem) -> TenStar {
  let target_index = target.get_index()
  let mut offset = target_index - self.loop_tyme.get_index()
  if self.loop_tyme.get_index() % 2 != 0 && target_index % 2 == 0 {
    offset = offset + 2
  }
  TenStar::from_index(offset)
}

///|
// get_direction 方位
pub fn HeavenStem::get_direction(self : HeavenStem) -> Direction {
  self.get_element().get_direction()
}

///|
// get_joy_direction 喜神方位（《喜神方位歌》甲己在艮乙庚乾，丙辛坤位喜神安。丁壬只在离宫坐，戊癸原在在巽间。）
pub fn HeavenStem::get_joy_direction(self : HeavenStem) -> Direction {
  let a = [7, 5, 1, 8, 3]
  Direction::from_index(a[self.loop_tyme.get_index() % 5])
}

///|
// get_yang_direction 阳贵神方位（《阳贵神歌》甲戊坤艮位，乙己是坤坎，庚辛居离艮，丙丁兑与乾，震巽属何日，壬癸贵神安。）
pub fn HeavenStem::get_yang_direction(self : HeavenStem) -> Direction {
  let a = [1, 1, 6, 5, 7, 0, 8, 7, 2, 3]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_yin_direction 阴贵神方位（《阴贵神歌》甲戊见牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸蛇兔藏，庚辛逢虎马，此是贵神方。）
pub fn HeavenStem::get_yin_direction(self : HeavenStem) -> Direction {
  let a = [7, 0, 5, 6, 1, 1, 7, 8, 3, 2]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_wealth_direction 财神方位（《财神方位歌》甲乙东北是财神，丙丁向在西南寻，戊己正北坐方位，庚辛正东去安身，壬癸原来正南坐，便是财神方位真。）
pub fn HeavenStem::get_wealth_direction(self : HeavenStem) -> Direction {
  let a = [7, 1, 0, 2, 8]
  Direction::from_index(a[self.loop_tyme.get_index() / 2])
}

///|
// get_mascot_direction 福神方位（《福神方位歌》甲乙东南是福神，丙丁正东是堪宜，戊北己南庚辛坤，壬在乾方癸在西。）
pub fn HeavenStem::get_mascot_direction(self : HeavenStem) -> Direction {
  let a = [3, 3, 2, 2, 0, 8, 1, 1, 5, 6]
  Direction::from_index(a[self.loop_tyme.get_index()])
}

///|
// get_peng_zu_heaven_stem 天干彭祖百忌
pub fn HeavenStem::get_peng_zu_heaven_stem(self : HeavenStem) -> PengZuHeavenStem {
  PengZuHeavenStem::from_index(self.loop_tyme.get_index())
}

///|
// get_terrain 地势(长生十二神)
pub fn HeavenStem::get_terrain(self : HeavenStem, earth_branch : EarthBranch) -> Terrain {
  let earth_branch_index = earth_branch.get_index()
  let mut offset = earth_branch_index
  if Yin.get_code() == self.get_yin_yang().get_code() {
    offset = -offset
  }
  let a = [1, 6, 10, 9, 10, 9, 7, 0, 4, 3]
  Terrain::from_index(a[self.loop_tyme.get_index()] + offset)
}

///|
// get_combine 五合（甲己合，乙庚合，丙辛合，丁壬合，戊癸合）
pub fn HeavenStem::get_combine(self : HeavenStem) -> HeavenStem {
  self.next(5)
}

///|
// combine 合化（甲己合化土，乙庚合化金，丙辛合化水，丁壬合化木，戊癸合化火）,如果无法合化，返回None
pub fn HeavenStem::combine(self : HeavenStem, target : HeavenStem) -> Option[Element] {
  if self.get_combine().equals(target) {
    Some(Element::from_index(self.loop_tyme.get_index() + 2))
  } else {
    None
  }
}

///|
impl Culture for HeavenStem with get_name(self : HeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for HeavenStem with to_string(self : HeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for HeavenStem with next(self : HeavenStem, n : Int) -> HeavenStem {
  HeavenStem::from_index(self.loop_tyme.get_index() + n)
}
