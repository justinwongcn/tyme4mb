// 测试套件：Animal（对应 Go test/Animal_test.go，一比一翻译）

///|
test "animal_1" {
  let animal = Animal::from_index(0)
  expect_eq(animal.to_string(), "蛟", "Animal.FromIndex(0).String()")
}

///|
test "animal_2" {
  let animal = Animal::from_name("蛟").unwrap()
  expect_eq(
    animal.next(1).to_string(),
    "龙",
    "Animal.FromName(蛟).Next(1).String()",
  )
}
