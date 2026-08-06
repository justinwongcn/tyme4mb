///|
// event_manager_chars 事件数据字符集（63 字符：0-9/A-U/V-Z/a-z/_）
pub fn event_manager_chars() -> String {
  "0123456789ABCDEFGHIJKLMNOPQRSTU_VWXYZabcdefghijklmnopqrstuvwxyz"
}

///|
// EventManager 事件管理器（全局静态操作，通过 event_manager_data 管理事件数据）
#warnings("-struct_never_constructed")
pub struct EventManager {} // 空结构体，仅作为方法命名空间

///|
// event_manager_data 事件管理器全局数据（事件名 -> 事件数据）
// 通过 Ref 实现全局可变状态，所有 EventManager 静态方法操作此状态。
pub let event_manager_data : Ref[Map[String, String]] = Ref::{
  val: Map([], capacity=8),
}

///|
fn validate_event_name(name : String) -> Result[Unit, String] {
  if name == "" {
    Err("illegal event name: empty")
  } else {
    Ok(())
  }
}

///|
fn parse_event_manager_data(
  data : String,
) -> Result[Map[String, String], String] {
  let events : Map[String, String] = Map([], capacity=8)
  let size = data.length()
  let mut offset = 0
  while offset < size {
    if size - offset < 10 || data.unsafe_get(offset).to_int() != '@'.to_int() {
      return Err("illegal event manager data at offset: \{offset}")
    }
    let event_data = data[offset:offset + 9].to_owned()
    match Event::validate(event_data) {
      Err(e) => return Err(e)
      Ok(_) => ()
    }
    let mut end = offset + 9
    while end < size && data.unsafe_get(end).to_int() != '@'.to_int() {
      end = end + 1
    }
    let name = data[offset + 9:end].to_owned()
    match validate_event_name(name) {
      Err(e) => return Err(e)
      Ok(_) => ()
    }
    events.set(name, event_data)
    offset = end
  }
  Ok(events)
}

///|
// update 新增、更新或重命名事件
pub fn EventManager::update(
  old_name : String,
  event : Event,
) -> Result[Unit, String] {
  match validate_event_name(old_name) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match Event::validate(event.get_data()) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  let new_name = if event.get_name() == "" {
    old_name
  } else {
    event.get_name()
  }
  match validate_event_name(new_name) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  if old_name != new_name {
    event_manager_data.val.remove(old_name)
  }
  event_manager_data.val.set(new_name, event.get_data())
  Ok(())
}

///|
// update_data 新增或更新事件（原始数据串）
pub fn EventManager::update_data(
  name : String,
  data : String,
) -> Result[Unit, String] {
  match validate_event_name(name) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match Event::validate(data) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  event_manager_data.val.set(name, data)
  Ok(())
}

///|
// remove 通过完整事件名称移除事件
pub fn EventManager::remove(name : String) -> Result[Unit, String] {
  match validate_event_name(name) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  event_manager_data.val.remove(name)
  Ok(())
}

///|
// set_data 验证后一次性替换所有事件数据
pub fn EventManager::set_data(data : String) -> Result[Unit, String] {
  match parse_event_manager_data(data) {
    Err(e) => Err(e)
    Ok(events) => {
      event_manager_data.val = events
      Ok(())
    }
  }
}
