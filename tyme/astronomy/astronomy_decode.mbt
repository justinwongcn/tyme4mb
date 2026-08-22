// ======== decode：把压缩标记串展开为 0/1 修正序列（qb/sb 使用） ========

///|
fn decode(s : String) -> String {
  let o = "0000000000"
  let o2 = o + o
  let mut s = s
  s = s.replace_all(old="J", new="00")
  s = s.replace_all(old="I", new="000")
  s = s.replace_all(old="H", new="0000")
  s = s.replace_all(old="G", new="00000")
  s = s.replace_all(old="t", new="02")
  s = s.replace_all(old="s", new="002")
  s = s.replace_all(old="r", new="0002")
  s = s.replace_all(old="q", new="00002")
  s = s.replace_all(old="p", new="000002")
  s = s.replace_all(old="o", new="0000002")
  s = s.replace_all(old="n", new="00000002")
  s = s.replace_all(old="m", new="000000002")
  s = s.replace_all(old="l", new="0000000002")
  s = s.replace_all(old="k", new="01")
  s = s.replace_all(old="j", new="0101")
  s = s.replace_all(old="i", new="001")
  s = s.replace_all(old="h", new="001001")
  s = s.replace_all(old="g", new="0001")
  s = s.replace_all(old="f", new="00001")
  s = s.replace_all(old="e", new="000001")
  s = s.replace_all(old="d", new="0000001")
  s = s.replace_all(old="c", new="00000001")
  s = s.replace_all(old="b", new="000000001")
  s = s.replace_all(old="a", new="0000000001")
  s = s.replace_all(old="A", new=o2 + o2 + o2)
  s = s.replace_all(old="B", new=o2 + o2 + o)
  s = s.replace_all(old="C", new=o2 + o2)
  s = s.replace_all(old="D", new=o2 + o)
  s = s.replace_all(old="E", new=o2)
  s = s.replace_all(old="F", new=o)
  s
}
