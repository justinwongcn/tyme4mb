///|
// EclipticHideHeavenStemDay 真黄经人元司令分野
// 按太阳真黄经（视黄经，含章动与光行差）的度数在人元司令分野中的定位。
// 月令 = 当前节令（黄经 315° 立春起，每 30° 一令：立春315° 惊蛰345° 清明15° 立夏45° 芒种75° 小暑105° 立秋135° 白露165° 寒露195° 立冬225° 大雪255° 小寒285°）
// 段 = 月令内黄经度数落入的分段（如立春后 [0,7)° 戊土、[7,14)° 丙火、[14,30)° 甲木）。
// 注意：司令分野的段序（第1/2/3段）只表示当令顺序，与藏干的本气/中气/余气分类无关；
// 故 sector_index 为段序的权威表达，get_hide_heaven_stem() 返回的 HideHeavenStem 类型恒为 Main（无分类占位）。
pub struct EclipticHideHeavenStemDay {
  hide_heaven_stem : HideHeavenStem
  month_lon : Double
  lon_offset : Double
  angle_in_sector : Double
  sector_index : Int
}

///|
extend EclipticHideHeavenStemDay with Culture::{get_name}

///|
pub fn EclipticHideHeavenStemDay::new(
  hide_heaven_stem : HideHeavenStem,
  month_lon : Double,
  lon_offset : Double,
  angle_in_sector : Double,
  sector_index : Int,
) -> EclipticHideHeavenStemDay {
  { hide_heaven_stem, month_lon, lon_offset, angle_in_sector, sector_index }
}

///|
// get_hide_heaven_stem 藏干（类型恒为 Main，仅取天干；段序请看 get_sector_index）
pub fn EclipticHideHeavenStemDay::get_hide_heaven_stem(
  self : EclipticHideHeavenStemDay,
) -> HideHeavenStem {
  self.hide_heaven_stem
}

///|
// get_sector_index 司令段序（0/1/2 = 第1/2/3段当令，与藏干分类无关）
pub fn EclipticHideHeavenStemDay::get_sector_index(
  self : EclipticHideHeavenStemDay,
) -> Int {
  self.sector_index
}

///|
// get_month_lon 太阳黄经在月令内的度数 [0, 30)
pub fn EclipticHideHeavenStemDay::get_month_lon(
  self : EclipticHideHeavenStemDay,
) -> Double {
  self.month_lon
}

///|
// get_lon_offset 当前司令段起点在月令内的黄经度数（如立春后戊7°段为 0、丙7°段为 7）
pub fn EclipticHideHeavenStemDay::get_lon_offset(
  self : EclipticHideHeavenStemDay,
) -> Double {
  self.lon_offset
}

///|
// get_angle_in_sector 太阳黄经在当前司令段内的度数（month_lon - lon_offset）
pub fn EclipticHideHeavenStemDay::get_angle_in_sector(
  self : EclipticHideHeavenStemDay,
) -> Double {
  self.angle_in_sector
}

///|
pub impl Culture for EclipticHideHeavenStemDay with fn get_name(
  self : EclipticHideHeavenStemDay,
) -> String {
  let heaven_stem = self.get_hide_heaven_stem().get_heaven_stem()
  "\{heaven_stem.get_name()}\{heaven_stem.get_element().get_name()}"
}

///|
pub impl Show for EclipticHideHeavenStemDay with fn to_string(
  self : EclipticHideHeavenStemDay,
) -> String {
  self.get_name()
}

// ecliptic_hide_heaven_stem_sectors 12 个月令的人元司令分野分段表（度数制）
// 参数 k 为月令序号：0=小寒(285°) 1=立春(315°) 2=惊蛰(345°) 3=清明(15°) 4=立夏(45°) 5=芒种(75°) 6=小暑(105°) 7=立秋(135°) 8=白露(165°) 9=寒露(195°) 10=立冬(225°) 11=大雪(255°)，
// 由太阳黄经 (lon_deg - 285 + 360)/30 取整后 mod 12 得出（黄经 285° 起每 30° 一令）
// 每项 (天干索引, 段长度数)，段长合计 30；无中段位的月令（卯/酉/子）中间段为 (0,0) 占位
// 段序（数组下标 0/1/2）仅表示第1/2/3段当令，与藏干的本气/中气/余气分类无关

///|
fn ecliptic_hide_heaven_stem_sectors(k : Int) -> Array[(Int, Int)] {
  match k {
    // 小寒(285°): 癸9 辛3 己18
    0 => [(9, 9), (7, 3), (5, 18)]
    // 立春(315°): 戊7 丙7 甲16
    1 => [(4, 7), (2, 7), (0, 16)]
    // 惊蛰(345°): 甲10 乙20（仅两段）
    2 => [(0, 10), (0, 0), (1, 20)]
    // 清明(15°): 乙9 癸3 戊18
    3 => [(1, 9), (9, 3), (4, 18)]
    // 立夏(45°): 戊5 庚9 丙16
    4 => [(4, 5), (6, 9), (2, 16)]
    // 芒种(75°): 丙10 己9 丁11
    5 => [(2, 10), (5, 9), (3, 11)]
    // 小暑(105°): 丁9 乙3 己18
    6 => [(3, 9), (1, 3), (5, 18)]
    // 立秋(135°): 戊10 壬3 庚17
    7 => [(4, 10), (8, 3), (6, 17)]
    // 白露(165°): 庚10 辛20（仅两段）
    8 => [(6, 10), (0, 0), (7, 20)]
    // 寒露(195°): 辛9 丁3 戊18
    9 => [(7, 9), (3, 3), (4, 18)]
    // 立冬(225°): 戊7 甲5 壬18
    10 => [(4, 7), (0, 5), (8, 18)]
    // 大雪(255°): 壬10 癸20（仅两段）
    _ => [(8, 10), (0, 0), (9, 20)]
  }
}

///|
// get_hide_heaven_stem_by_ecliptic 真黄经人元司令分野
// 以太阳真黄经（视黄经）度数代替按日计数划分司令分野：
// 月令与段位全部由黄经度数直接定位（不经节气时刻表），故与按日版在节气边界附近可能存在 1~2 分钟的自然错位
// 适用年限：约 1000~3000 年（ΔT 用天文观测表 + 抛物线/三次式外推，极端年份黄经误差约 0.03°~0.05°，不影响 1° 级段位）
pub fn SolarTime::get_hide_heaven_stem_by_ecliptic(
  self : SolarTime,
) -> EclipticHideHeavenStemDay {
  // 1. 太阳视黄经（弧度）：北京时间儒略日 → UT（减8h）→ ΔT → TD 世纪数 → sa_lon
  let lon_rad = self.get_julian_day().get_day()
    |> fn(jd) { jd - OneThird } // 北京时间 → UT（减 8h）
    |> fn(jd_ut) { jd_ut - J2000.to_double() } // J2000 起 UT 天数
    |> fn(t_ut) { (t_ut + dt_t(t_ut)) / 36525.0 } // ΔT → J2000 起 TD 世纪数
    |> fn(t_td) { sa_lon(t_td, 10) }
  // 2. 归一化到 [0, 360) 度
  let lon_deg = lon_rad * 180.0 / @math.PI
  let lon_deg = lon_deg - 360.0 * @math.floor(lon_deg / 360.0)
  // 3. 月令序号 k：黄经 285°（小寒）起每 30° 一令，mod 12 轮回
  let k = @math.floor((lon_deg - 285.0 + 360.0) / 30.0).to_int() % 12
  // 4. 月令黄经起点（度）
  let jie_lon = ((285 + 30 * k) % 360).to_double()
  // 5. 月令内黄经度数 [0, 30)
  let mut month_lon = lon_deg - jie_lon
  if month_lon < 0.0 {
    month_lon = month_lon + 360.0
  }
  month_lon = month_lon - 30.0 * @math.floor(month_lon / 30.0)
  // 6. 分段定位（左闭右开 [start, start+len)）
  let sectors = ecliptic_hide_heaven_stem_sectors(k)
  let mut start = 0.0
  let mut index = 0
  let mut stem_index = 0
  let mut found = false
  for i, sector in sectors {
    let (stem, len) = sector
    if len == 0 {
      continue
    }
    let end = start + len.to_double()
    if month_lon < end {
      stem_index = stem
      index = i
      found = true
      break
    }
    start = end
  }
  // 防御：分段表每令段宽合计恒为 30、month_lon 经归一化后恒 ∈ [0,30)，
  // 正常情况下循环必在末段命中。若不命中说明月令表或归一化被改动破坏，显式报错而非静默回退。
  if !found {
    abort(
      "ecliptic hide heaven stem: sector not found for month_lon=\{month_lon} k=\{k}",
    )
  }
  EclipticHideHeavenStemDay::new(
    HideHeavenStem::from_index(stem_index, Main), // 类型恒为 Main（司令无藏干分类），段序见 sector_index
    month_lon,
    start,
    month_lon - start,
    index,
  )
}
