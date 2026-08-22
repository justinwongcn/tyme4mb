///|
test "xref_solar_term" {
  let years = [2000, 2024, 2025, 1900, 2100]
  let idxs = [0, 1, 12, 23]
  for y in years {
    for idx in idxs {
      let o = SolarTerm::from_index(y, idx)
      println("ST \{y} \{idx} \{o.get_name()}|\{o.to_string()}")
      println("STY \{y} \{idx} \{o.get_year()}")
      println("STJ \{y} \{idx} \{o.is_jie()}")
      println("STQ \{y} \{idx} \{o.is_qi()}")
      let jd = (o.get_cursory_julian_day() * 1000000.0 + 0.5).to_int64()
      println("STC \{y} \{idx} \{jd}")
      for n in [-1, 1, 24, -24] {
        println("STN \{y} \{idx} \{n} \{o.next(n).get_name()}")
      }
      match SolarTerm::from_name(y, o.get_name()) {
        Ok(v) => println("STF \{y} \{o.get_name()} \{v.loop_tyme.get_index()}")
        Err(e) => println("STF \{y} \{o.get_name()} -1 \{e}")
      }
    }
  }
}

///|
test "xref_phenology" {
  let years = [2000, 2024, 2025, 1900, 2100]
  let idxs = [0, 1, 35, 71]
  for y in years {
    for idx in idxs {
      let o = Phenology::from_index(y, idx)
      println("PN \{y} \{idx} \{o.get_name()}|\{o.to_string()}")
      println("PNY \{y} \{idx} \{o.get_year()}")
      println("PNI \{y} \{idx} \{o.get_index()}")
      println("PNT \{y} \{idx} \{o.get_three_phenology().get_name()}")
      let jd = (o.get_julian_day().get_day() * 1000000.0 + 0.5).to_int64()
      println("PNJ \{y} \{idx} \{jd}")
      for n in [-1, 1, 72, -72] {
        let nx = o.next(n)
        println("PNN \{y} \{idx} \{n} \{nx.get_name()}|\{nx.get_year()}")
      }
      match Phenology::from_name(y, o.get_name()) {
        Ok(v) =>
          println("PNF \{y} \{o.get_name()} \{v.get_index()} \{v.get_year()}")
        Err(_) => println("PNF \{y} \{o.get_name()} ERR")
      }
    }
  }
  // SolarTermDay 节气第几天
  for y in years {
    for idx in [0, 5, 23] {
      let st = SolarTerm::from_index(y, idx)
      for d in [0, 1, 14] {
        let o = SolarTermDay::new(st, d)
        println(
          "STD \{y} \{idx} \{d} \{o.get_name()}|\{o.to_string()}|\{o.get_solar_term().get_name()}|\{o.get_day_index()}",
        )
      }
    }
  }
}
