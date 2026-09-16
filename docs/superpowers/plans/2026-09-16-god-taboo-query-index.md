# God/Taboo Query Index Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace repeated God/Taboo encoded-string scanning with module-initialized direct indexes without changing any public API or observable result.

**Architecture:** Keep the existing encoded strings as the single source of truth, parse them once into private nested indexes, and materialize a fresh public result array on every query. Preserve parse failures inside `Result` cells so public query functions retain their existing error channel.

**Tech Stack:** MoonBit `0.1.20260803`, `moon` check/test/bench, white-box tests, native differential output, Git worktree.

**Execution clarification (approved):** Record a compilable baseline and benchmark in Task 1. Add each private-builder test immediately before its implementation in Task 2 or 3, respectively, so the focused test can go RED then GREEN without leaving Task 1 unbuildable.

## Global Constraints

- Do not change public function signatures, public type shapes, call sites, result ordering, result names, or error text.
- Keep `tyme/core/pkg.generated.mbti` and `tyme/pkg.generated.mbti` byte-identical.
- Keep the encoded God/Taboo strings as the only authoritative data; do not duplicate them into hand-maintained decoded tables.
- Return a newly allocated `Array[God]` or `Array[Taboo]` for every public query.
- Limit production changes to `tyme/core/god.mbt` and `tyme/core/taboo.mbt`.
- Verify `wasm`, `wasm-gc`, `js`, and `native` separately because the existing print-heavy differential tests can corrupt UTF-8 output when all targets run concurrently.

---

### Task 1: Establish immutable behavior, interface, and performance baselines

**Files:**
- Create: `tyme/core/god_taboo_bench_wbtest.mbt`
- Read: `tyme/core/xref_gt_wbtest.mbt`
- Read: `tyme/core/pkg.generated.mbti`
- Read: `tyme/pkg.generated.mbti`

**Interfaces:**
- Consumes: existing five public God/Taboo query functions.
- Produces: a repeatable benchmark and baseline artifacts under `/tmp`.

- [ ] **Step 1: Capture the public interfaces and full native differential output**

Run:

```bash
cp tyme/core/pkg.generated.mbti /tmp/tyme4mb-core-before.mbti
cp tyme/pkg.generated.mbti /tmp/tyme4mb-facade-before.mbti
moon test --target native tyme/core/xref_gt_wbtest.mbt -f xref_gt > /tmp/tyme4mb-xref-gt-before.txt
```

Expected: command exits `0`; the output file contains the complete `GO`, `TB`, `GG`, `TDR`, `TDA`, `THR`, and `THA` records.

- [ ] **Step 2: Add the benchmark harness**

Create `tyme/core/god_taboo_bench_wbtest.mbt` using `@bench.T`. Build 12 representative month pillars and all 60 day pillars outside the timed closure:

```moonbit
///|
test (b : @bench.T) {
  let cases : Array[(SixtyCycleMonth, SixtyCycleDay, SixtyCycle)] = []
  for m = 0; m < 12; m = m + 1 {
    let month = SixtyCycleMonth::new(
      SixtyCycleYear::from_year(2024).unwrap(),
      SixtyCycle::from_index(m),
    )
    for d = 0; d < 60; d = d + 1 {
      let day = SixtyCycleDay::new(
        SolarDay::from_ymd(2024, 1, 1).unwrap(),
        month,
        SixtyCycle::from_index(d),
      )
      cases.push((month, day, SixtyCycle::from_index(m)))
    }
  }
  b.bench(name="god_taboo_12x60_queries", fn() {
    let mut checksum = 0
    for item in cases {
      checksum = checksum + God::get_day_gods(item.0, item.1).unwrap().length()
      checksum = checksum + Taboo::get_day_recommends(item.0, item.1).unwrap().length()
      checksum = checksum + Taboo::get_day_avoids(item.0, item.1).unwrap().length()
      checksum = checksum + Taboo::get_hour_recommends(item.1.get_sixty_cycle(), item.2).unwrap().length()
      checksum = checksum + Taboo::get_hour_avoids(item.1.get_sixty_cycle(), item.2).unwrap().length()
    }
    b.keep(checksum)
  })
}
```

- [ ] **Step 3: Record the native benchmark baseline**

Run:

```bash
moon bench --target native tyme/core/god_taboo_bench_wbtest.mbt | tee /tmp/tyme4mb-god-taboo-bench-before.txt
```

Expected: benchmark completes and reports `god_taboo_12x60_queries`. Do not add an absolute timing assertion.

- [ ] **Step 4: Commit the benchmark harness**

```bash
git add tyme/core/god_taboo_bench_wbtest.mbt
git commit -m "bench: establish god taboo query baseline"
```

### Task 2: Build and use the God direct index

**Files:**
- Modify: `tyme/core/god.mbt`
- Create: `tyme/core/god_query_index_wbtest.mbt`

**Interfaces:**
- Consumes: `parse_hex(String) -> Result[Int, String]` from the same package and the existing encoded God strings.
- Produces: `build_god_query_index(Array[String]) -> Array[Array[Result[Array[Int], String]]]` and a private module-level query index.

- [ ] **Step 0: Write failing white-box tests for the desired private God index builder**

Create `tyme/core/god_query_index_wbtest.mbt` with the God builder test:

```moonbit
///|
test "build_god_query_index_preserves_record_order" {
  let index = build_god_query_index([";000102;013C"])
  inspect(index[0][0], content="Ok([1, 2])")
  inspect(index[0][1], content="Ok([60])")
}

```

Run the focused test and verify compilation fails specifically because `build_god_query_index` does not exist.

Run:

```bash
moon test --target native tyme/core/god_query_index_wbtest.mbt
```

Then add public result-isolation characterization tests to the God test file:

Use this small constructor helper in the God test file; Task 3 duplicates it in the Taboo test file so each implementation unit can compile independently:

```moonbit
fn god_taboo_case(month_index : Int, day_index : Int) -> (SixtyCycleMonth, SixtyCycleDay) {
  let month = SixtyCycleMonth::new(
    SixtyCycleYear::from_year(2024).unwrap(),
    SixtyCycle::from_index(month_index),
  )
  let day = SixtyCycleDay::new(
    SolarDay::from_ymd(2024, 1, 1).unwrap(),
    month,
    SixtyCycle::from_index(day_index),
  )
  (month, day)
}

///|
test "god_query_returns_independent_arrays" {
  let (month, day) = god_taboo_case(0, 0)
  let gods1 = God::get_day_gods(month, day).unwrap()
  let god_count = gods1.length()
  gods1.push(God::from_index(0))
  inspect(
    God::get_day_gods(month, day).unwrap().length() == god_count,
    content="true",
  )
}
```

Add the God boundary assertion:

```moonbit
///|
test "god_query_covers_last_day_index" {
  let (month, day) = god_taboo_case(11, 59)
  let _ = God::get_day_gods(month, day).unwrap()
}
```

These public tests characterize existing behavior; the builder test is the mandatory RED test.

- [ ] **Step 1: Convert only the God encoded container to a private module value**

Change the declaration line `fn day_gods() -> Array[String] {` to `let day_god_data : Array[String] = [`; remove the function's separate array-opening `[` and replace its final array-closing `]` plus function-closing `}` with one module-value closing `]`. Do not alter any encoded string character or its order.

- [ ] **Step 2: Implement the minimal God index builder**

Add `build_god_query_index`. For every row:

1. create 60 `Ok([])` cells;
2. split the row into records on `;` once during initialization;
3. parse the first two characters as the day index;
4. parse the remaining characters in two-character groups, preserving order;
5. store either `Ok(ids)` or the original `parse_hex` error in that day cell.

If the two-character day prefix itself is invalid, store that error in every still-unset cell for the row so no initialization panic is introduced. Bounds-check the parsed day index before assigning.

Initialize the production index once:

```moonbit
let day_god_query_index = build_god_query_index(day_god_data)
```

- [ ] **Step 3: Replace runtime scanning with indexed materialization**

In `God::get_day_gods`, preserve the existing month-row calculation:

```moonbit
let month_index = month
  .get_sixty_cycle()
  .get_earth_branch()
  .next(-2)
  .get_index()
let day_index = day.get_sixty_cycle().get_index()
```

Read `day_god_query_index[month_index][day_index]`. Return the saved `Err` unchanged, or map the saved integer IDs into a newly created `Array[God]` using `God::from_index`.

Remove the now-unused `format_hex2` and per-query scanning loop.

- [ ] **Step 4: Run the God parser and isolation tests and verify GREEN**

Run:

```bash
moon test --target native tyme/core/god_query_index_wbtest.mbt
```

Expected: God builder, boundary, and result-isolation assertions pass.

- [ ] **Step 5: Prove God output compatibility**

Run:

```bash
moon test --target native tyme/core/xref_gt_wbtest.mbt -f xref_gt > /tmp/tyme4mb-xref-gt-after-god.txt
cmp /tmp/tyme4mb-xref-gt-before.txt /tmp/tyme4mb-xref-gt-after-god.txt
```

Expected: `cmp` exits `0`.

- [ ] **Step 6: Commit the God index**

```bash
git add tyme/core/god.mbt tyme/core/god_query_index_wbtest.mbt
git commit -m "perf: index day god queries"
```

---

### Task 3: Build and use the Taboo direct indexes

**Files:**
- Modify: `tyme/core/taboo.mbt`
- Create: `tyme/core/taboo_query_index_wbtest.mbt`

**Interfaces:**
- Consumes: existing `parse_hex(String) -> Result[Int, String]` and encoded day/hour Taboo strings.
- Produces: `build_taboo_query_index(Array[String]) -> Array[Array[(Result[Array[Int], String], Result[Array[Int], String])]]`, plus private day and hour indexes.

- [ ] **Step 0: Write failing white-box tests for the desired private Taboo index builder**

Create `tyme/core/taboo_query_index_wbtest.mbt` with:

```moonbit
///|
test "build_taboo_query_index_preserves_empty_and_nonempty_fields" {
  let index = build_taboo_query_index(["0001,;02,0304"])
  inspect(index[0][0].0, content="Ok([0, 1])")
  inspect(index[0][0].1, content="Ok([])")
  inspect(index[0][1].0, content="Ok([2])")
  inspect(index[0][1].1, content="Ok([3, 4])")
}
```

Before finalizing the fixture, confirm current `String::split` behavior for leading empty segments with a temporary white-box assertion; adjust only the synthetic fixture. Run the focused test and verify RED because `build_taboo_query_index` does not exist. Add the following public characterization tests before implementing the builder (duplicate the small `god_taboo_case` constructor helper from Task 2 so each test file compiles independently):

```moonbit
///|
test "taboo_query_returns_independent_arrays" {
  let (month, day) = god_taboo_case(0, 0)
  let taboos1 = Taboo::get_day_recommends(month, day).unwrap()
  let taboo_count = taboos1.length()
  taboos1.push(Taboo::from_index(0))
  inspect(
    Taboo::get_day_recommends(month, day).unwrap().length() == taboo_count,
    content="true",
  )
}

///|
test "taboo_query_preserves_empty_result" {
  let (month, day) = god_taboo_case(1, 21)
  inspect(Taboo::get_day_avoids(month, day).unwrap(), content="[]")
}

///|
test "taboo_query_covers_last_day_index" {
  let (month, day) = god_taboo_case(11, 59)
  let _ = Taboo::get_day_recommends(month, day).unwrap()
}
```

- [ ] **Step 1: Convert the Taboo encoded containers to private module values**

Replace `day_taboo()` and `hour_taboo()` with `day_taboo_data` and `hour_taboo_data` private module values. Move every encoded string byte-for-byte.

- [ ] **Step 2: Implement the minimal Taboo index builder**

For every primary row:

1. split once on `;` to obtain the 60 day records;
2. split each record once on `,`;
3. parse field `0` as recommends and field `1` as avoids;
4. represent an empty field as `Ok([])`;
5. preserve the exact `parse_hex` error string in the corresponding tuple element.

Create module-level indexes:

```moonbit
let day_taboo_query_index = build_taboo_query_index(day_taboo_data)
let hour_taboo_query_index = build_taboo_query_index(hour_taboo_data)
```

- [ ] **Step 3: Replace `get_taboos` string splitting with indexed materialization**

Change the private helper to consume a prebuilt index rather than encoded strings. Select tuple field `0` or `1`, return its `Err` unchanged, or allocate a new `Array[Taboo]` and populate it with `Taboo::from_index`.

Update the four public callers to pass `day_taboo_query_index` or `hour_taboo_query_index`. Preserve their existing primary/sub-index calculations exactly.

- [ ] **Step 4: Run all focused tests and verify GREEN**

Run:

```bash
moon test --target native tyme/core/god_query_index_wbtest.mbt tyme/core/taboo_query_index_wbtest.mbt
```

Expected: all parser, representative-result, empty-result, boundary, and return-array-isolation tests pass.

- [ ] **Step 5: Prove complete God/Taboo output compatibility**

Run:

```bash
moon test --target native tyme/core/xref_gt_wbtest.mbt -f xref_gt > /tmp/tyme4mb-xref-gt-after.txt
cmp /tmp/tyme4mb-xref-gt-before.txt /tmp/tyme4mb-xref-gt-after.txt
```

Expected: `cmp` exits `0` with no output.

- [ ] **Step 6: Record the optimized benchmark**

Run:

```bash
moon bench --target native tyme/core/god_taboo_bench_wbtest.mbt | tee /tmp/tyme4mb-god-taboo-bench-after.txt
```

Compare the same benchmark name and checksum with `/tmp/tyme4mb-god-taboo-bench-before.txt`. If performance does not materially improve, stop and investigate rather than committing the implementation.

- [ ] **Step 7: Commit the Taboo indexes**

```bash
git add tyme/core/taboo.mbt tyme/core/taboo_query_index_wbtest.mbt
git commit -m "perf: index taboo queries"
```

---

### Task 4: Verify interfaces, all targets, diff quality, and final performance

**Files:**
- Verify: `tyme/core/pkg.generated.mbti`
- Verify: `tyme/pkg.generated.mbti`
- Verify: all files changed on `codex/god-taboo-index`

**Interfaces:**
- Consumes: completed implementation and baseline artifacts.
- Produces: evidence that the branch is API-compatible, behavior-compatible, cross-target clean, and faster.

- [ ] **Step 1: Regenerate interface metadata and compare it byte-for-byte**

Run:

```bash
moon info
cmp /tmp/tyme4mb-core-before.mbti tyme/core/pkg.generated.mbti
cmp /tmp/tyme4mb-facade-before.mbti tyme/pkg.generated.mbti
```

Expected: both `cmp` commands exit `0`.

- [ ] **Step 2: Run all-target compile checks**

Run:

```bash
moon check --target all
```

Expected: exit `0` with no warnings or errors.

- [ ] **Step 3: Run the complete suite separately on all four targets**

Run:

```bash
verify_dir=$(mktemp -d /tmp/tyme4mb-god-taboo-verify.XXXXXX)
for target in wasm wasm-gc js native; do
  moon test --target "$target" > "$verify_dir/$target.log" 2>&1 || {
    tail -n 80 "$verify_dir/$target.log"
    exit 1
  }
  tail -n 1 "$verify_dir/$target.log"
done
```

Expected for each target: the reported total and passed counts are equal, and the failed count is `0`.

- [ ] **Step 4: Run final differential and benchmark comparisons**

Run:

```bash
cmp /tmp/tyme4mb-xref-gt-before.txt /tmp/tyme4mb-xref-gt-after.txt
moon bench --target native tyme/core/god_taboo_bench_wbtest.mbt
```

Expected: differential output is byte-identical; benchmark checksum matches baseline and timing is materially lower.

- [ ] **Step 5: Inspect the complete branch diff**

Run:

```bash
git diff --check main...HEAD
git diff --stat main...HEAD
git diff main...HEAD -- tyme/core/god.mbt tyme/core/taboo.mbt tyme/core/god_query_index_wbtest.mbt tyme/core/taboo_query_index_wbtest.mbt tyme/core/god_taboo_bench_wbtest.mbt
git status --short --branch
```

Confirm there are no encoded-data edits, unrelated changes, generated interface changes, debug prints, or uncommitted files.

- [ ] **Step 6: Commit any verification-only adjustment, otherwise leave history unchanged**

Only if verification required a legitimate test or documentation correction:

```bash
git add tyme/core/god_query_index_wbtest.mbt tyme/core/taboo_query_index_wbtest.mbt tyme/core/god_taboo_bench_wbtest.mbt docs/superpowers/plans/2026-09-16-god-taboo-query-index.md
git commit -m "test: strengthen god taboo index verification"
```

Do not create an empty commit.
