# Lunar Year Leap Index Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `LunarYear::get_leap_month`'s nested linear scan with an O(1) year-indexed lookup while preserving every public API and result.

**Architecture:** Keep the existing compressed leap-year strings as the single source of truth, but decode them once into a private 10,001-element `Array[Int]` indexed by `year + 1`. Add a full-range characterization test using the old grouped representation as an independent reference, plus a reproducible native release benchmark for the public query path.

**Tech Stack:** MoonBit `0.1.20260803`; `moon.pkg`; `moonbitlang/core/bench`; `moon check`, `moon test`, `moon bench`, and `moon info`.

## Global Constraints

- Do not change any public type, function signature, method-call form, error text, exported symbol, or calendar result.
- Preserve the valid `LunarYear` range `-1..9999`; year `-1` must keep leap month `11`, and non-leap years must return `0`.
- Keep `lunar_year_leap_chars` and `lunar_year_leap_data` as the sole production data source; do not add a hand-maintained year table.
- Do not modify `api.md`, `go.md`, `java.md`, `ts.md`, `tyme/reexports.mbt`, package boundaries, or generated OpenWiki pages.
- Allow one private 10,001-element integer lookup array; do not retain a second production leap-year index.
- Validate all supported targets: `wasm-gc`, `wasm`, `js`, and `native` through `--target all`.
- Preserve unrelated working-tree changes and stage only files named by this plan.

---

## File Map

- Modify `tyme/core/moon.pkg`: make `moonbitlang/core/bench` available only to package tests/benchmarks.
- Create `tyme/core/lunar_year_index_wbtest.mbt`: own the old grouped decoding reference and exhaustive equivalence test.
- Create `tyme/core/lunar_year_bench_wbtest.mbt`: benchmark only the public `LunarYear::get_leap_month` path across all valid years.
- Modify `tyme/core/lunar_year.mbt`: replace the grouped production index and nested query scan with the direct year index.
- Regenerate, but expect no semantic changes in, `tyme/core/pkg.generated.mbti` and `tyme/pkg.generated.mbti`.

### Task 1: Lock Behavior and Measure the Existing Query

**Files:**
- Modify: `tyme/core/moon.pkg`
- Create: `tyme/core/lunar_year_index_wbtest.mbt`
- Create: `tyme/core/lunar_year_bench_wbtest.mbt`
- Snapshot: `/private/tmp/tyme-leap-index-before/tyme.mbti`
- Snapshot: `/private/tmp/tyme-leap-index-before/core.mbti`

**Interfaces:**
- Consumes: `LunarYear::from_year(Int) -> Result[LunarYear, String]`, `LunarYear::get_leap_month(Self) -> Int`, `lunar_year_leap_chars : String`, and `lunar_year_leap_data : Array[String]`.
- Produces: `reference_lunar_year_leap_groups() -> Array[Array[Int]]` for test-only old-semantics comparison and a reusable `moon bench` workload.

- [ ] **Step 1: Save the public-interface baseline**

Run:

```bash
mkdir -p /private/tmp/tyme-leap-index-before
cp tyme/pkg.generated.mbti /private/tmp/tyme-leap-index-before/tyme.mbti
cp tyme/core/pkg.generated.mbti /private/tmp/tyme-leap-index-before/core.mbti
```

Expected: both snapshot files exist and `git status --short` shows no new workspace files from this step.

- [ ] **Step 2: Add the benchmark dependency to test imports only**

Change the second import block in `tyme/core/moon.pkg` to:

```moonbit
import {
  "moonbitlang/core/bench",
  "justinwongcn/tyme4mb/tyme",
}
```

Do not add `bench` to the production import block.

- [ ] **Step 3: Add an independent reference decoder and exhaustive characterization test**

Create `tyme/core/lunar_year_index_wbtest.mbt`:

```moonbit
///|
fn reference_lunar_year_leap_groups() -> Array[Array[Int]] {
  let groups : Array[Array[Int]] = []
  for month_index = 0; month_index < lunar_year_leap_data.length(); month_index = month_index + 1 {
    let encoded = lunar_year_leap_data[month_index]
    let years : Array[Int] = []
    let mut year = 0
    for offset = 0; offset < encoded.length(); offset = offset + 2 {
      let high = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset).to_int(),
      )
      let low = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset + 1).to_int(),
      )
      year = year + high * 64 + low
      years.push(year)
    }
    groups.push(years)
  }
  groups
}

///|
fn reference_lunar_year_leap_month(
  year : Int,
  groups : Array[Array[Int]],
) -> Int {
  if year == -1 {
    return 11
  }
  for month_index = 0; month_index < groups.length(); month_index = month_index + 1 {
    let years = groups[month_index]
    for candidate in years {
      if candidate == year {
        return month_index + 1
      }
      if candidate > year {
        break
      }
    }
  }
  0
}

///|
test "lunar_year leap month matches grouped reference for full range" {
  let groups = reference_lunar_year_leap_groups()
  for year = -1; year <= 9999; year = year + 1 {
    let actual = LunarYear::from_year(year).unwrap().get_leap_month()
    let expected = reference_lunar_year_leap_month(year, groups)
    expect_eq(actual, expected, "leap month for year \{year}")
  }
}
```

This test deliberately reconstructs the old grouped representation instead of calling the production builder. It therefore remains a behavioral oracle after the production data layout changes.

- [ ] **Step 4: Run the characterization test and verify it passes before implementation**

Run:

```bash
moon test tyme/core/lunar_year_index_wbtest.mbt --target all
```

Expected: PASS on `wasm-gc`, `wasm`, `js`, and `native`. A failure here means the reference decoder does not reproduce current behavior and must be corrected before continuing.

- [ ] **Step 5: Add the public-path benchmark**

Create `tyme/core/lunar_year_bench_wbtest.mbt`:

```moonbit
///|
test (b : @bench.T) {
  let years = Array::makei(10001, fn(index) {
    LunarYear::from_year(index - 1).unwrap()
  })
  b.bench(name="get_leap_month_-1_to_9999", fn() {
    let mut checksum = 0
    for year in years {
      checksum = checksum + year.get_leap_month()
    }
    b.keep(checksum)
  })
}
```

The benchmark constructs `LunarYear` values outside the measured closure and keeps the checksum so the compiler cannot eliminate the queries.

- [ ] **Step 6: Record three native release baseline runs**

Run:

```bash
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-before/bench-1.txt
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-before/bench-2.txt
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-before/bench-3.txt
```

Expected: all three runs complete and report `get_leap_month_-1_to_9999`. Preserve the raw files; do not turn timing into a brittle automated threshold.

- [ ] **Step 7: Commit the behavioral and performance harness**

Run:

```bash
git add tyme/core/moon.pkg tyme/core/lunar_year_index_wbtest.mbt tyme/core/lunar_year_bench_wbtest.mbt
git commit -m "test: characterize lunar year leap month lookup"
```

Expected: the commit contains exactly the three named files.

### Task 2: Replace the Grouped Production Index with a Direct Year Index

**Files:**
- Modify: `tyme/core/lunar_year.mbt:47-85`
- Modify: `tyme/core/lunar_year.mbt:123-137`
- Test: `tyme/core/lunar_year_index_wbtest.mbt`

**Interfaces:**
- Consumes: `lunar_year_leap_chars : String`, `lunar_year_leap_data : Array[String]`, and private `chars_index(String, Int) -> Int`.
- Produces: private `build_lunar_year_leap_index() -> Array[Int]` and `lunar_year_leap_index : Array[Int]`; preserves `pub fn LunarYear::get_leap_month(Self) -> Int` exactly.

- [ ] **Step 1: Add a failing structural test for the planned direct index**

Append to `tyme/core/lunar_year_index_wbtest.mbt`:

```moonbit
///|
test "lunar_year direct leap index covers every valid year" {
  let groups = reference_lunar_year_leap_groups()
  let index = build_lunar_year_leap_index()
  expect_eq(index.length(), 10001, "direct index length")
  for year = -1; year <= 9999; year = year + 1 {
    expect_eq(
      index[year + 1],
      reference_lunar_year_leap_month(year, groups),
      "direct index for year \{year}",
    )
  }
}
```

- [ ] **Step 2: Run the new test and verify the expected failure**

Run:

```bash
moon test tyme/core/lunar_year_index_wbtest.mbt --target wasm-gc
```

Expected: FAIL at compile time because `build_lunar_year_leap_index` is not defined. Any different failure must be fixed before implementation.

- [ ] **Step 3: Implement the direct index builder**

In `tyme/core/lunar_year.mbt`, replace `build_lunar_year_leap` and `lunar_year_leap` with:

```moonbit
///|
// build_lunar_year_leap_index 构建按年份直接索引的闰月表；下标为 year + 1
fn build_lunar_year_leap_index() -> Array[Int] {
  let leap_months = Array::make(10001, 0)
  leap_months[0] = 11
  for month_index = 0; month_index < lunar_year_leap_data.length(); month_index = month_index + 1 {
    let encoded = lunar_year_leap_data[month_index]
    let mut year = 0
    for offset = 0; offset < encoded.length(); offset = offset + 2 {
      let high = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset).to_int(),
      )
      let low = chars_index(
        lunar_year_leap_chars,
        encoded.unsafe_get(offset + 1).to_int(),
      )
      year = year + high * 64 + low
      if year <= 9999 {
        leap_months[year + 1] = month_index + 1
      }
    }
  }
  leap_months
}

///|
let lunar_year_leap_index : Array[Int] = build_lunar_year_leap_index()
```

Keep `chars_index` private and otherwise unchanged. Do not retain the old `Array[Array[Int]]` production builder or value.

- [ ] **Step 4: Replace the nested query scan with one indexed read**

Replace `LunarYear::get_leap_month` with:

```moonbit
///|
// get_leap_month 闰月数字，1代表闰1月，0代表无闰月
pub fn LunarYear::get_leap_month(self : LunarYear) -> Int {
  lunar_year_leap_index[self.get_year() + 1]
}
```

The existing public construction path validates `-1..9999`, so the index expression covers every constructible `LunarYear` without adding a new public error branch.

- [ ] **Step 5: Format only the modified source and tests**

Run:

```bash
moon fmt tyme/core/lunar_year.mbt tyme/core/lunar_year_index_wbtest.mbt tyme/core/lunar_year_bench_wbtest.mbt
```

Expected: no unrelated file changes.

- [ ] **Step 6: Run the exhaustive tests on all targets**

Run:

```bash
moon test tyme/core/lunar_year_index_wbtest.mbt --target all
moon test tyme/core/lunar_year_wbtest.mbt --target all
moon test api_test/test_lunar.mbt --target all
```

Expected: every command passes on all four supported targets.

- [ ] **Step 7: Commit the implementation**

Run:

```bash
git add tyme/core/lunar_year.mbt tyme/core/lunar_year_index_wbtest.mbt
git commit -m "perf: index lunar leap months by year"
```

Expected: the commit contains the production refactor and its direct-index test only.

### Task 3: Prove Performance, Interface Stability, and Full Regression Safety

**Files:**
- Verify: `tyme/core/lunar_year_bench_wbtest.mbt`
- Verify: `tyme/core/pkg.generated.mbti`
- Verify: `tyme/pkg.generated.mbti`
- Output: `/private/tmp/tyme-leap-index-after/bench-*.txt`
- Output: `/private/tmp/tyme-leap-index-all-tests.log`

**Interfaces:**
- Consumes: the Task 1 benchmark and interface snapshots plus the Task 2 direct index.
- Produces: repeatable performance evidence, unchanged public interface files, and a clean regression result.

- [ ] **Step 1: Record three optimized native release benchmark runs**

Run:

```bash
mkdir -p /private/tmp/tyme-leap-index-after
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-after/bench-1.txt
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-after/bench-2.txt
moon bench tyme/core/lunar_year_bench_wbtest.mbt --target native --release | tee /private/tmp/tyme-leap-index-after/bench-3.txt
```

Expected: the optimized mean is lower than the baseline mean in at least two of the three paired runs. If not, stop and investigate instead of claiming a performance improvement.

- [ ] **Step 2: Regenerate interfaces and compare them byte-for-byte**

Run:

```bash
moon info --target all
diff -u /private/tmp/tyme-leap-index-before/tyme.mbti tyme/pkg.generated.mbti
diff -u /private/tmp/tyme-leap-index-before/core.mbti tyme/core/pkg.generated.mbti
```

Expected: both `diff` commands produce no output and exit successfully. If formatting or target annotations cause a non-semantic difference, inspect it explicitly; do not accept a changed signature or export.

- [ ] **Step 3: Run compile and focused regression checks**

Run:

```bash
moon check --target all
moon test tyme/core/lunar_year_index_wbtest.mbt --target all
moon test tyme/core/lunar_year_wbtest.mbt --target all
moon test api_test/test_lunar.mbt --target all
```

Expected: all commands exit successfully.

- [ ] **Step 4: Run the full suite quietly while preserving complete output**

Run:

```bash
moon test --target all > /private/tmp/tyme-leap-index-all-tests.log 2>&1
```

Expected: exit code `0`. If it fails, inspect and report the complete log rather than rerunning with truncated output.

- [ ] **Step 5: Verify repository hygiene and exact scope**

Run:

```bash
git diff --check
git status --short
git show --stat --oneline HEAD~1..HEAD
```

Expected: no whitespace errors; generated interface files are unchanged; unrelated pre-existing working-tree changes remain untouched.

- [ ] **Step 6: Commit any benchmark-only formatting or metadata change if present**

If Task 3 produced no tracked changes, do not create an empty commit. If it produced an intentional change limited to the benchmark harness, run:

```bash
git add tyme/core/lunar_year_bench_wbtest.mbt tyme/core/moon.pkg
git commit -m "bench: cover lunar leap month lookup"
```

Expected: no production file or generated interface file is included in this optional commit.

## Completion Criteria

- Exhaustive old-versus-new comparison passes for all 10,001 valid years on every supported target.
- `LunarYear::get_leap_month` performs a single indexed read and has no nested scan.
- Native release benchmarks show a lower mean in at least two of three paired runs.
- `tyme/pkg.generated.mbti` and `tyme/core/pkg.generated.mbti` match their pre-change snapshots exactly.
- Focused and full test suites pass.
- Only the files listed in the File Map are changed by this optimization.
