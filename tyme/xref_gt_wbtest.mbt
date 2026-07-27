// 测试套件：xref_gt（对应 Go test/xref_gt_test.go TestXrefGodTaboo，一比一 print 差分移植）
//
// 该文件是「打印型」差分测试：仅打印，不做断言（与 Go 原版一致）。
// 差分 harness 会将本文件 `moon test` 的 stdout 与 Go 版 TestXrefGodTaboo 的 stdout 做对比。
// God / Taboo 为 LoopTyme 枚举：from_index 返回值本身（非 Result），
// next / get_name / to_string 由 Tyme / Culture / Show trait 提供。

///|
test "xref_gt" {
  // ---------- God 枚举本体 ----------
  for i = 0; i < 151; i = i + 1 {
    let o = God::from_index(i)
    println("GO \{i} \{o.get_name()}|\{o.to_string()}|\{o.get_luck().get_name()}")
    println("GON \{i} \{o.next(37).get_name()} \{o.next(-37).get_name()}")
  }
  // ---------- Taboo 枚举本体 ----------
  for i = 0; i < 140; i = i + 1 {
    let o = Taboo::from_index(i)
    println("TB \{i} \{o.get_name()}|\{o.to_string()}")
    println("TBN \{i} \{o.next(37).get_name()} \{o.next(-37).get_name()}")
  }
  // ---------- 组合逻辑：全 60x60 干支 ----------
  // 局部闭包：把 Result[Array[T], String] 拼成与 Go joinGods/joinTaboos 相同的逗号串（含尾逗号）
  let join_gods = fn(r : Result[Array[God], String]) -> String {
    match r {
      Ok(gods) => {
        let mut s = ""
        for g in gods {
          s = s + g.get_name() + ","
        }
        s
      }
      Err(e) => "ERR:" + e
    }
  }
  let join_taboos = fn(r : Result[Array[Taboo], String]) -> String {
    match r {
      Ok(v) => {
        let mut s = ""
        for x in v {
          s = s + x.get_name() + ","
        }
        s
      }
      Err(e) => "ERR:" + e
    }
  }
  for m = 0; m < 60; m = m + 1 {
    let mo = SixtyCycle::from_index(m)
    for d = 0; d < 60; d = d + 1 {
      let da = SixtyCycle::from_index(d)
      println("GG \{m} \{d} \{join_gods(God::get_day_gods(mo, da))}")
      println("TDR \{m} \{d} \{join_taboos(Taboo::get_day_recommends(mo, da))}")
      println("TDA \{m} \{d} \{join_taboos(Taboo::get_day_avoids(mo, da))}")
      println("THR \{m} \{d} \{join_taboos(Taboo::get_hour_recommends(mo, da))}")
      println("THA \{m} \{d} \{join_taboos(Taboo::get_hour_avoids(mo, da))}")
    }
  }
}
