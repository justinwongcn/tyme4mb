// 测试套件：DogDay（对应 Go test/DogDay_test.go，一比一翻译）

///|
test "dog_day_0" {
  let d = SolarDay::from_ymd(2011, 7, 14).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "初伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "初伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "初伏第1天", "DogDay.String()")
}

///|
test "dog_day_1" {
  let d = SolarDay::from_ymd(2011, 7, 23).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "初伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "初伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "初伏第10天", "DogDay.String()")
}

///|
test "dog_day_2" {
  let d = SolarDay::from_ymd(2011, 7, 24).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "中伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "中伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "中伏第1天", "DogDay.String()")
}

///|
test "dog_day_3" {
  let d = SolarDay::from_ymd(2011, 8, 12).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "中伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "中伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "中伏第20天", "DogDay.String()")
}

///|
test "dog_day_4" {
  let d = SolarDay::from_ymd(2011, 8, 13).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "末伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "末伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "末伏第1天", "DogDay.String()")
}

///|
test "dog_day_5" {
  let d = SolarDay::from_ymd(2011, 8, 22).unwrap()
  let dog_day = d.get_dog_day().unwrap()
  expect_eq(dog_day.get_name(), "末伏", "DogDay.GetName()")
  expect_eq(
    dog_day.get_dog().to_string(),
    "末伏",
    "DogDay.GetDog().String()",
  )
  expect_eq(dog_day.to_string(), "末伏第10天", "DogDay.String()")
}
