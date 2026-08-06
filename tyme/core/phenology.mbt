///|
// phenology_names 候名称
pub fn phenology_names() -> Array[String] {
  [
    "蚯蚓结", "麋角解", "水泉动", "雁北乡", "鹊始巢", "雉始雊",
    "鸡始乳", "征鸟厉疾", "水泽腹坚", "东风解冻", "蛰虫始振",
    "鱼陟负冰", "獭祭鱼", "候雁北", "草木萌动", "桃始华", "仓庚鸣",
    "鹰化为鸠", "玄鸟至", "雷乃发声", "始电", "桐始华", "田鼠化为鴽",
    "虹始见", "萍始生", "鸣鸠拂其羽", "戴胜降于桑", "蝼蝈鸣",
    "蚯蚓出", "王瓜生", "苦菜秀", "靡草死", "麦秋至", "螳螂生",
    "鵙始鸣", "反舌无声", "鹿角解", "蜩始鸣", "半夏生", "温风至",
    "蟋蟀居壁", "鹰始挚", "腐草为萤", "土润溽暑", "大雨行时",
    "凉风至", "白露降", "寒蝉鸣", "鹰乃祭鸟", "天地始肃", "禾乃登",
    "鸿雁来", "玄鸟归", "群鸟养羞", "雷始收声", "蛰虫坯户", "水始涸",
    "鸿雁来宾", "雀入大水为蛤", "菊有黄花", "豺乃祭兽", "草木黄落",
    "蛰虫咸俯", "水始冰", "地始冻", "雉入大水为蜃", "虹藏不见",
    "天气上升地气下降", "闭塞而成冬", "鹖鴠不鸣", "虎始交", "荔挺出",
  ]
}

///|
// Phenology 候
pub struct Phenology {
  loop_tyme : LoopTyme
  year : Int
}

///|
extend Phenology with Tyme::{next}

///|
pub fn Phenology::from_index(year : Int, index : Int) -> Phenology {
  let parent = LoopTyme::from_index(phenology_names(), index)
  let size = parent.get_size()
  { loop_tyme: parent, year: (year * size + index) / size }
}

///|
pub fn Phenology::from_name(
  year : Int,
  name : String,
) -> Result[Phenology, String] {
  match LoopTyme::from_name(phenology_names(), name) {
    Ok(p) => Ok({ loop_tyme: p, year })
    Err(e) => Err(e)
  }
}

///|
pub impl Culture for Phenology with fn get_name(self : Phenology) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for Phenology with fn to_string(self : Phenology) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for Phenology with fn next(self : Phenology, n : Int) -> Phenology {
  let size = self.loop_tyme.get_size()
  let i = self.loop_tyme.get_index() + n
  Phenology::from_index(
    (self.year * size + i) / size,
    self.loop_tyme.index_of(i),
  )
}

///|
// get_three_phenology 三候
pub fn Phenology::get_three_phenology(self : Phenology) -> ThreePhenology {
  ThreePhenology::from_index(self.loop_tyme.get_index() % 3)
}

///|
// get_year 年
pub fn Phenology::get_year(self : Phenology) -> Int {
  self.year
}

///|
// get_index 索引
pub fn Phenology::get_index(self : Phenology) -> Int {
  self.loop_tyme.get_index()
}

///|
// get_julian_day 儒略日
pub fn Phenology::get_julian_day(self : Phenology) -> JulianDay {
  let t = sa_lon_t(
    (
      self.year.to_double() -
      2000.0 +
      (self.loop_tyme.get_index() - 18).to_double() * 5.0 / 360.0 +
      1.0
    ) *
    2.0 *
    @math.PI,
  )
  JulianDay::from_julian_day(
    t * 36525.0 + J2000.to_double() + 8.0 / 24.0 - dt_t(t * 36525.0),
  )
}
