// ======== 核心天文位置计算：太阳/月亮黄经、章动、光行差、视黄经 ========

///|
fn nutation_lon2(t : Double) -> Double {
  let mut a = -1.742 * t
  let t2 = t * t
  let mut dl = 0.0
  let j = nut_b.length()
  for i = 0; i < j; i = i + 5 {
    dl += (nut_b[i + 3] + a) *
      @math.sin(nut_b[i] + nut_b[i + 1] * t + nut_b[i + 2] * t2)
    a = 0.0
  }
  dl / 100.0 / SecondPerRad
}

///|
fn e_lon(t : Double, n : Int) -> Double {
  let t = t / 10.0
  let mut v = 0.0
  let mut tn = 1.0
  let pn = 1
  let m0 = xl0[pn + 1] - xl0[pn]
  for i = 0; i < 6; i = i + 1 {
    let n1 = xl0[pn + i].to_int()
    let n2 = xl0[pn + 1 + i].to_int()
    let n0 = n2 - n1
    if n0 == 0 {
      continue
    }
    let mut m = 0
    if n < 0 {
      m = n2
    } else {
      m = ((3 * n * n0).to_double() / m0 + 0.5).to_int() + n1
      if i != 0 {
        m += 3
      }
      if m > n2 {
        m = n2
      }
    }
    let mut c = 0.0
    for j = n1; j < m; j = j + 3 {
      c += xl0[j] * @math.cos(xl0[j + 1] + t * xl0[j + 2])
    }
    v += c * tn
    tn = tn * t
  }
  v /= xl0[0]
  let t2 = t * t
  let t3 = t2 * t
  v + (-0.0728 - 2.7702 * t - 1.1019 * t2 - 0.0996 * t3) / SecondPerRad
}

///|
fn m_lon(t : Double, n : Int) -> Double {
  let ob = xl1
  let obl = ob[0].length()
  let mut tn = 1.0
  let mut v = 0.0
  let mut t2 = t * t
  let mut t3 = t2 * t
  let mut t4 = t3 * t
  let t5 = t4 * t
  let tx = t - 10.0
  v += (
      3.81034409 +
      8399.684730072 * t -
      3.319e-05 * t2 +
      3.11e-08 * t3 -
      2.033e-10 * t4
    ) *
    SecondPerRad
  v += 5028.792262 * t +
    1.1124406 * t2 +
    0.00007699 * t3 -
    0.000023479 * t4 -
    0.0000000178 * t5
  if tx > 0.0 {
    v += -0.866 + 1.43 * tx + 0.054 * tx * tx
  }
  t2 /= 10000.0
  t3 /= 100000000.0
  t4 /= 100000000.0
  let mut n = n * 6
  if n < 0 {
    n = obl
  }
  let x = ob.length()
  for i = 0; i < x; i = i + 1 {
    let f = ob[i]
    let l = obl
    let fl = f.length()
    let mut m = ((n * l).to_double() / obl.to_double() + 0.5).to_int()
    if i > 0 {
      m += 6
    }
    if m >= l {
      m = l
    }
    if m > fl {
      m = fl / 6 * 6
    }
    let mut c = 0.0
    for j = 0; j < m; j = j + 6 {
      c += f[j] *
        @math.cos(
          f[j + 1] +
          t * f[j + 2] +
          t2 * f[j + 3] +
          t3 * f[j + 4] +
          t4 * f[j + 5],
        )
    }
    v += c * tn
    tn *= t
  }
  v / SecondPerRad
}

///|
fn gxc_sun_lon(t : Double) -> Double {
  let t2 = t * t
  -20.49552 *
  (
    1.0 +
    (0.016708634 - 0.000042037 * t - 0.0000001267 * t2) *
    @math.cos(-0.043126 + 628.301955 * t - 0.000002732 * t2)
  ) /
  SecondPerRad
}

///|
fn ev(t : Double) -> Double {
  let f = 628.307585 * t
  628.332 +
  21.0 * @math.sin(1.527 + f) +
  0.44 * @math.sin(1.48 + f * 2.0) +
  0.129 * @math.sin(5.82 + f) * t +
  0.00055 * @math.sin(4.21 + f) * t * t
}

///|
pub fn sa_lon(t : Double, n : Int) -> Double {
  e_lon(t, n) + nutation_lon2(t) + gxc_sun_lon(t) + @math.PI
}

// ======== ΔT 计算与黄经反算时刻：sa_lon_t、msa_lon_t 等 ========

///|
fn dt_ext(y : Double, jsd : Double) -> Double {
  let dy = (y - 1820.0) / 100.0
  -20.0 + jsd * dy * dy
}

///|
fn dt_calc(y : Double) -> Double {
  let size = dt_at.length()
  let y0 = dt_at[size - 2]
  let t0 = dt_at[size - 1]
  if y >= y0 {
    let jsd = 31.0
    if y > y0 + 100.0 {
      return dt_ext(y, jsd)
    }
    let v = dt_ext(y, jsd)
    let dv = dt_ext(y0, jsd) - t0
    return v - dv * (y0 + 100.0 - y) / 100.0
  }
  let mut i = 0
  while i < size {
    if y < dt_at[i + 5] {
      break
    }
    i += 5
  }
  let t1 = (y - dt_at[i]) / (dt_at[i + 5] - dt_at[i]) * 10.0
  let t2 = t1 * t1
  let t3 = t2 * t1
  dt_at[i + 1] + dt_at[i + 2] * t1 + dt_at[i + 3] * t2 + dt_at[i + 4] * t3
}

///|
pub fn dt_t(t : Double) -> Double {
  dt_calc(t / 365.2425 + 2000.0) / SecondPerDay
}

///|
fn mv(t : Double) -> Double {
  let v = 8399.71 -
    914.0 * @math.sin(0.7848 + 8328.691425 * t + 0.0001523 * t * t)
  v -
  (
    179.0 * @math.sin(2.543 + 15542.7543 * t) +
    160.0 * @math.sin(0.1874 + 7214.0629 * t) +
    62.0 * @math.sin(3.14 + 16657.3828 * t) +
    34.0 * @math.sin(4.827 + 16866.9323 * t) +
    22.0 * @math.sin(4.9 + 23871.4457 * t) +
    12.0 * @math.sin(2.59 + 14914.4523 * t) +
    7.0 * @math.sin(0.23 + 6585.7609 * t) +
    5.0 * @math.sin(0.9 + 25195.624 * t) +
    5.0 * @math.sin(2.32 - 7700.3895 * t) +
    5.0 * @math.sin(3.88 + 8956.9934 * t) +
    5.0 * @math.sin(0.49 + 7771.3771 * t)
  )
}

///|
pub fn sa_lon_t(w : Double) -> Double {
  let mut v = 628.3319653318
  let mut t = (w - 1.75347 - @math.PI) / v
  v = ev(t)
  t += (w - sa_lon(t, 10)) / v
  t + (w - sa_lon(t, -1)) / ev(t)
}

///|
fn msa_lon(t : Double, mn : Int, sn : Int) -> Double {
  m_lon(t, mn) + -3.4e-6 - (e_lon(t, sn) + gxc_sun_lon(t) + @math.PI)
}

///|
pub fn msa_lon_t(w : Double) -> Double {
  let mut v = 7771.37714500204
  let mut t = (w + 1.08472) / v
  t += (w - msa_lon(t, 3, 3)) / v
  v = mv(t) - ev(t)
  t += (w - msa_lon(t, 20, 10)) / v
  t + (w - msa_lon(t, -1, 60)) / v
}

// ======== 高/低精度节气、朔日推算：qi_high、qi_low、shuo_high、shuo_low ========

///|
fn sa_lon_t2(w : Double) -> Double {
  let v = 628.3319653318
  let mut t = (w - 1.75347 - @math.PI) / v
  t -= (
      0.000005297 * t * t +
      0.0334166 * @math.cos(4.669257 + 628.307585 * t) +
      0.0002061 * @math.cos(2.67823 + 628.307585 * t) * t
    ) /
    v
  t +
  (
    w -
    e_lon(t, 8) -
    @math.PI +
    (20.5 + 17.2 * @math.sin(2.1824 - 33.75705 * t)) / SecondPerRad
  ) /
  v
}

///|
fn msa_lon_t2(w : Double) -> Double {
  let mut v = 7771.37714500204
  let mut t = (w + 1.08472) / v
  let mut t2 = t * t
  t -= (
      -0.00003309 * t2 +
      0.10976 * @math.cos(0.784758 + 8328.6914246 * t + 0.000152292 * t2) +
      0.02224 * @math.cos(0.18740 + 7214.0628654 * t - 0.00021848 * t2) -
      0.03342 * @math.cos(4.669257 + 628.307585 * t)
    ) /
    v
  t2 = t * t
  let l = m_lon(t, 20) -
    (
      4.8950632 +
      628.3319653318 * t +
      0.000005297 * t2 +
      0.0334166 * @math.cos(4.669257 + 628.307585 * t) +
      0.0002061 * @math.cos(2.67823 + 628.307585 * t) * t +
      0.000349 * @math.cos(4.6261 + 1256.61517 * t) -
      20.5 / SecondPerRad
    )
  v = 7771.38 -
    914.0 * @math.sin(0.7848 + 8328.691425 * t + 0.0001523 * t2) -
    179.0 * @math.sin(2.543 + 15542.7543 * t) -
    160.0 * @math.sin(0.1874 + 7214.0629 * t)
  t + (w - l) / v
}

///|
fn qi_high(w : Double) -> Double {
  let mut t = sa_lon_t2(w) * 36525.0
  t = t - dt_t(t) + OneThird
  // 截断取余，结果符号与被除数一致
  let f = t + 0.5
  let v = (f - (if f < 0.0 { @math.ceil(f) } else { @math.floor(f) })) *
    SecondPerDay
  if v < 1200.0 || v > SecondPerDay - 1200.0 {
    t = sa_lon_t(w) * 36525.0 - dt_t(t) + OneThird
  }
  t
}

///|
fn shuo_high(w : Double) -> Double {
  let mut t = msa_lon_t2(w) * 36525.0
  t = t - dt_t(t) + OneThird
  // 截断取余，结果符号与被除数一致
  let f = t + 0.5
  let v = (f - (if f < 0.0 { @math.ceil(f) } else { @math.floor(f) })) *
    SecondPerDay
  if v < 1800.0 || v > SecondPerDay - 1800.0 {
    t = msa_lon_t(w) * 36525.0 - dt_t(t) + OneThird
  }
  t
}

///|
fn qi_low(w : Double) -> Double {
  let v = 628.3319653318
  let mut t = (w - 4.895062166) / v
  t -= (
      53.0 * t * t +
      334116.0 * @math.cos(4.67 + 628.307585 * t) +
      2061.0 * @math.cos(2.678 + 628.3076 * t) * t
    ) /
    v /
    10000000.0
  let n = 48950621.66 +
    6283319653.318 * t +
    53.0 * t * t +
    334166.0 * @math.cos(4.669257 + 628.307585 * t) +
    3489.0 * @math.cos(4.6261 + 1256.61517 * t) +
    2060.6 * @math.cos(2.67823 + 628.307585 * t) * t -
    994.0 -
    834.0 * @math.sin(2.1824 - 33.75705 * t)
  t -= (n / 10000000.0 - w) / 628.332 +
    (32.0 * (t + 1.8) * (t + 1.8) - 20.0) / SecondPerDay / 36525.0
  t * 36525.0 + OneThird
}

///|
fn shuo_low(w : Double) -> Double {
  let v = 7771.37714500204
  let mut t = (w + 1.08472) / v
  t -= (
      -0.0000331 * t * t +
      0.10976 * @math.cos(0.785 + 8328.6914 * t) +
      0.02224 * @math.cos(0.187 + 7214.0629 * t) -
      0.03342 * @math.cos(4.669 + 628.3076 * t)
    ) /
    v +
    (32.0 * (t + 1.8) * (t + 1.8) - 20.0) / SecondPerDay / 36525.0
  t * 36525.0 + OneThird
}

// ======== 节气/朔日公开 API：calc_qi、calc_shuo、qi_accurate 等 ========

///|
fn qi_shuo(is_qi : Bool, is_high : Bool, jd : Double, pc : Double) -> Double {
  let w = if is_qi {
    @math.floor((jd + pc - 2451259.0) / 365.2422 * 24.0) * @math.PI / 12.0
  } else {
    @math.floor((jd + pc - 2451551.0) / 29.5306) * Pi2
  }
  let d = if is_qi {
    if is_high {
      qi_high(w)
    } else {
      qi_low(w)
    }
  } else if is_high {
    shuo_high(w)
  } else {
    shuo_low(w)
  }
  @math.floor(d + 0.5)
}

///|
fn calc(
  is_qi : Bool,
  jd : Double,
  kb : Array[Double],
  pc : Double,
  fkb : String,
) -> Double {
  let size = kb.length()
  let mut d = 0.0
  let j = jd + J2000.to_double()
  let f1 = kb[0] - pc
  let f2 = kb[size - 1] - pc
  if j < f1 || j >= 2436935.0 {
    d = qi_shuo(is_qi, true, j, pc)
  } else if j >= f1 && j < f2 {
    let mut i = 0
    while i < size {
      if j + pc < kb[i + 2] {
        break
      }
      i += 2
    }
    d = @math.floor(
      kb[i] + kb[i + 1] * @math.floor((j + pc - kb[i]) / kb[i + 1]) + 0.5,
    )
    if !is_qi && d == 1683460.0 {
      d += 1.0
    }
    d -= J2000.to_double()
  } else if j >= f2 {
    d = qi_shuo(is_qi, false, j, pc)
    let from = if is_qi {
      ((j - f2) / 365.2422 * 24.0).to_int()
    } else {
      ((j - f2) / 29.5306).to_int()
    }
    let n = fkb[from:from + 1].to_owned()
    if n == "1" {
      d += 1.0
    } else if n == "2" {
      d -= 1.0
    }
  }
  d
}

///|
pub fn calc_shuo(jd : Double) -> Double {
  calc(false, jd, shuo_kb, 14.0, sb)
}

///|
pub fn calc_qi(jd : Double) -> Double {
  calc(true, jd, qi_kb, 7.0, qb)
}

///|
pub fn qi_accurate(w : Double) -> Double {
  let t = sa_lon_t(w) * 36525.0
  t - dt_t(t) + OneThird
}

///|
pub fn qi_accurate2(jd : Double) -> Double {
  let d = @math.PI / 12.0
  let w = @math.floor((jd + 293.0) / 365.2422 * 24.0) * d
  let a = qi_accurate(w)
  if a - jd > 5.0 {
    return qi_accurate(w - d)
  }
  if a - jd < -5.0 {
    return qi_accurate(w + d)
  }
  a
}
