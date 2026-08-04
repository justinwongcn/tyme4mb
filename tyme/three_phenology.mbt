///|
// three_phenology_names 三候名称
pub fn three_phenology_names() -> Array[String] {
  ["初候", "二候", "三候"]
}

///|
// ThreePhenology 三候
pub struct ThreePhenology {
  loop_tyme : LoopTyme
}

///|
pub fn ThreePhenology::from_index(index : Int) -> ThreePhenology {
  { loop_tyme: LoopTyme::from_index(three_phenology_names(), index) }
}

///|
pub fn ThreePhenology::from_name(
  name : String,
) -> Result[ThreePhenology, String] {
  match LoopTyme::from_name(three_phenology_names(), name) {
    Ok(p) => Ok({ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn ThreePhenology::get_index(self : ThreePhenology) -> Int {
  self.loop_tyme.get_index()
}

///|
pub impl Culture for ThreePhenology with fn get_name(self : ThreePhenology) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Show for ThreePhenology with fn to_string(self : ThreePhenology) -> String {
  self.loop_tyme.get_name()
}

///|
pub impl Tyme for ThreePhenology with fn next(self : ThreePhenology, n : Int) -> ThreePhenology {
  ThreePhenology::from_index(self.loop_tyme.get_index() + n)
}
