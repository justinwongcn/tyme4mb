// 太阳位置支持函数

///|
// solar_declination 太阳视赤纬
// δ = asin(sin(真黄赤交角) × sin(太阳视黄经))，视黄经含章动与光行差
// t: J2000 起力学时世纪数
// 返回: 弧度 [-π/2, π/2]
pub fn solar_declination(t : Double) -> Double {
  @math.asin(@math.sin(true_obliquity(t)) * @math.sin(sa_lon(t, 10)))
}
