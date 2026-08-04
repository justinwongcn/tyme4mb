///|
// sound_names 纳音名称
pub fn sound_names() -> Array[String] {
  [
    "海中金", "炉中火", "大林木", "路旁土", "剑锋金", "山头火",
    "涧下水", "城头土", "白蜡金", "杨柳木", "泉中水", "屋上土",
    "霹雳火", "松柏木", "长流水", "沙中金", "山下火", "平地木",
    "壁上土", "金箔金", "覆灯火", "天河水", "大驿土", "钗钏金",
    "桑柘木", "大溪水", "沙中土", "天上火", "石榴木", "大海水",
  ]
}

///|
// Sound 纳音
pub struct Sound {
  loop_tyme : LoopTyme
}

///|
extend Sound with Culture::{get_name}

///|
extend Sound with Show::{to_string}

///|
extend Sound with Tyme::{next}

///|
pub fn Sound::from_index(index : Int) -> Sound {
  Sound::{ loop_tyme: LoopTyme::from_index(sound_names(), index) }
}

///|
pub fn Sound::from_name(name : String) -> Result[Sound, String] {
  match LoopTyme::from_name(sound_names(), name) {
    Ok(p) => Ok(Sound::{ loop_tyme: p })
    Err(e) => Err(e)
  }
}

///|
pub fn Sound::get_index(self : Sound) -> Int {
  self.loop_tyme.get_index()
}

///|
impl Culture for Sound with fn get_name(self : Sound) -> String {
  self.loop_tyme.get_name()
}

///|
impl Show for Sound with fn to_string(self : Sound) -> String {
  self.loop_tyme.get_name()
}

///|
impl Tyme for Sound with fn next(self : Sound, n : Int) -> Sound {
  Sound::from_index(self.loop_tyme.get_index() + n)
}
