// 共享测试断言 helper（供所有 *_wbtest.mbt 复用）
// 本 MoonBit 版本未绑定 assert 关键字，故用 abort 实现断言失败。
// 所有翻译后的 Go 测试统一调用这里的函数，避免在各文件重复定义造成冲突。

///|
// 断言相等：T 需实现 Eq 与 Show
fn[T : Eq + Show] expect_eq(got : T, expected : T, msg : String) -> Unit {
  if got != expected {
    abort(
      "ASSERT EQ FAIL: \{msg}\n  got     = \{got}\n  expected = \{expected}",
    )
  }
}

///|
// 断言不等
#warnings("-unused_value")
fn[T : Eq + Show] expect_ne(got : T, unexpected : T, msg : String) -> Unit {
  if got == unexpected {
    abort(
      "ASSERT NE FAIL: \{msg}\n  got        = \{got}\n  unexpected = \{unexpected}",
    )
  }
}

///|
// 断言为真
fn expect_true(cond : Bool, msg : String) -> Unit {
  if !cond {
    abort("ASSERT TRUE FAIL: \{msg}")
  }
}

///|
// 断言为假
fn expect_false(cond : Bool, msg : String) -> Unit {
  if cond {
    abort("ASSERT FALSE FAIL: \{msg}")
  }
}

///|
// 浮点近似断言（容许误差 eps）
fn expect_near(a : Double, b : Double, eps : Double, msg : String) -> Unit {
  if (a - b).abs() > eps {
    abort("ASSERT NEAR FAIL: \{msg}\n  a=\{a} b=\{b} eps=\{eps}")
  }
}

///|
// helper 自身健全性（确保 expect_* 可被编译进测试目标）
test "test_helper_sanity" {
  expect_eq(1, 1, "sanity int")
  expect_eq("a", "a", "sanity string")
  expect_true(2 > 1, "sanity true")
  expect_false(1 > 2, "sanity false")
  expect_near(1.0, 1.0001, 1.0e-3, "sanity near")
}
