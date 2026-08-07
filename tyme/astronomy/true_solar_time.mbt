// 真太阳时支持函数 (基于 astro 仓库精确公式)
// 均时差公式来自 astro 仓库 basic/sun.go 的 SunTime：
//   EoT = (太阳几何黄经 - 光行差 - 太阳视赤经 + 黄经章动 × cos(真黄赤交角)) / 15

///|
// mean_obliquity 平黄赤交角（IAU 1980 公式）
// t: J2000 起力学时世纪数
// 返回: 弧度
pub fn mean_obliquity(t : Double) -> Double {
  let t2 = t * t
  let t3 = t2 * t
  // 84381.448 角秒 = 23°26'21.448"
  let eps_arcsec = 84381.448 - 46.8150 * t - 0.00059 * t2 + 0.001813 * t3
  eps_arcsec / SecondPerRad
}

///|
// nutation_obliquity 交角章动
// 复用 nut_b 数组，使用 cos 替代 sin，取 nut_b[i+4]（交角系数）
// 首项长期变化修正：+0.089*t（对应 IAU 1980 系数 8.9）
pub fn nutation_obliquity(t : Double) -> Double {
  let mut a = 0.089 * t
  let t2 = t * t
  let mut de = 0.0
  let j = nut_b.length()
  for i = 0; i < j; i = i + 5 {
    de += (nut_b[i + 4] + a) *
      @math.cos(nut_b[i] + nut_b[i + 1] * t + nut_b[i + 2] * t2)
    a = 0.0
  }
  de / 100.0 / SecondPerRad
}

///|
// true_obliquity 真黄赤交角 = 平黄赤交角 + 交角章动
pub fn true_obliquity(t : Double) -> Double {
  mean_obliquity(t) + nutation_obliquity(t)
}

///|
// lo_to_ra 黄经→赤经变换
// 对应 astro 仓库 basic/coordinate.go 的 LoToRa
// t: J2000 起力学时世纪数（用于查黄赤交角）
// lo: 黄经（弧度）
// bo: 黄纬（弧度），太阳黄纬≈0
// 返回: 赤经（弧度，[0, 2π)）
pub fn lo_to_ra(t : Double, lo : Double, bo : Double) -> Double {
  let eps = true_obliquity(t)
  let ra = @math.atan2(
    @math.sin(lo) * @math.cos(eps) - @math.tan(bo) * @math.sin(eps),
    @math.cos(lo),
  )
  if ra < 0.0 {
    ra + Pi2
  } else {
    ra
  }
}

///|
// sun_apparent_ra 太阳视赤经
// 使用 sa_lon(t, 10) 获取太阳视黄经（含章动+光行差），再转为赤经
// t: J2000 起力学时世纪数
// 返回: 赤经（弧度，[0, 2π)）
pub fn sun_apparent_ra(t : Double) -> Double {
  lo_to_ra(t, sa_lon(t, 10), 0.0)
}

///|
// equation_of_time 均时差
// 公式来自 astro 仓库 basic/sun.go 的 SunTime：
//   EoT = (SunLo - 0.0057183 - HSunApparentRa + Nutation×cos(ε)) / 15
// 关键：SunLo 使用低精度公式，HSunApparentRa 使用高精度 VSOP87
// 这种精度混用是 astro 公式的固有设计，产生均时差的主要变化项
// 所有量在弧度制下计算，最后转为小时
// t: J2000 起力学时世纪数
// 返回: 均时差（小时，[-12, 12)）
pub fn equation_of_time(t : Double) -> Double {
  // 1. 低精度太阳几何黄经（对应 astro 的 planet.SunLo）
  // SunLo 使用千年数 T = (jd-2451545)/365250 = t_centuries / 10
  let t_k = t / 10.0 // 世纪→千年
  let sun_lo_deg = 280.4664567 +
    360007.6982779 * t_k +
    0.03032028 * t_k * t_k +
    t_k * t_k * t_k / 49931.0 -
    t_k * t_k * t_k * t_k / 15299.0 -
    t_k * t_k * t_k * t_k * t_k / 1988000.0
  let sun_lo_deg = sun_lo_deg - @math.floor(sun_lo_deg / 360.0) * 360.0
  let sun_lo = sun_lo_deg * @math.PI / 180.0 // 度→弧度

  // 2. 固定光行差常数 0.0057183° → 弧度
  let ab = 0.0057183 * @math.PI / 180.0

  // 3. 高精度太阳视赤经（弧度，[0, 2π)）
  let ra = sun_apparent_ra(t)

  // 4. 黄经章动和真黄赤交角（弧度）
  let nut = nutation_lon2(t)
  let eps = true_obliquity(t)

  // 5. 均时差 = (SunLo - 光行差 - 视赤经 + 章动×cos(ε)) 弧度
  let diff = sun_lo - ab - ra + nut * @math.cos(eps)
  // 归一化到 [-π, π)
  let eot_rad = diff - Pi2 * @math.floor(diff / Pi2 + 0.5)
  eot_rad * 12.0 / @math.PI // 弧度→小时
}
