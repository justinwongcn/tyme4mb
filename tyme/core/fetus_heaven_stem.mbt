///|
// fetus_heaven_stem_names 天干六甲胎神名称
pub fn fetus_heaven_stem_names() -> Array[String] {
  ["门", "碓磨", "厨灶", "仓库", "房床"]
}

///|
// FetusHeavenStem 天干六甲胎神（《天干六甲胎神歌》甲己之日占在门，乙庚碓磨休移动。丙辛厨灶莫相干，丁壬仓库忌修弄。戊癸房床若移整，犯之孕妇堕孩童。）
pub struct FetusHeavenStem {
  loop_tyme : LoopTyme
}

///|
pub extend FetusHeavenStem with Culture::{get_name}

///|
pub fn FetusHeavenStem::new(index : Int) -> FetusHeavenStem {
  { loop_tyme: LoopTyme::from_index(fetus_heaven_stem_names(), index), }
}

///|
pub fn FetusHeavenStem::get_index(self : FetusHeavenStem) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for FetusHeavenStem with fn get_name(self : FetusHeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for FetusHeavenStem with fn to_string(self : FetusHeavenStem) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for FetusHeavenStem with fn next(self : FetusHeavenStem, n : Int) -> FetusHeavenStem {
  FetusHeavenStem::new(self.loop_tyme.get_index() + n)
}

///|
pub extend FetusHeavenStem with Show::{to_string}

///|
pub extend FetusHeavenStem with Tyme::{next}
