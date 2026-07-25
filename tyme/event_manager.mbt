///|
// event_manager_chars 事件数据字符集（63 字符：0-9/A-U/V-Z/a-z/_）
pub fn event_manager_chars() -> String {
  "0123456789ABCDEFGHIJKLMNOPQRSTU_VWXYZabcdefghijklmnopqrstuvwxyz"
}

///|
// EventManager 事件管理器（值类型，持有 事件名 -> 事件数据 的映射）
//
// 设计：本结构体即「方案 C 形态」——所有逻辑都在 self 上、返回新实例，
// 不依赖任何全局态。调用方显式持有并传递 EventManager 实例
// （注册：mgr.update(name, event)；查询：mgr.from_name(name) /
// mgr.all() / mgr.from_solar_day(d)）。已从「方案 A Ref 全局单例」迁移至纯方案 C，
// 无任何全局可变状态。
//
// 内部用 Map[name, data] 而非 Go 的「@+8字符+name」拼接字符串：行为完全等价
// （name -> event 的增删查改 / 枚举 / 按日枚举），但天然支持 UTF-8 事件名、
// 且避免手工字符串字节解析。每事件的 data 仍为 Go 同款的 9 字符编码串。
pub struct EventManager {
  data : Map[String, String]
}

///|
// new 空管理器
pub fn EventManager::new() -> EventManager {
  { data: Map([], capacity=8) }
}

///|
// update 新增或更新事件（返回新管理器，不可变风格）
pub fn EventManager::update(self : EventManager, name : String, event : Event) -> EventManager {
  let key = if event.get_name() == "" { name } else { event.get_name() }
  let m = self.data
  m.set(key, event.get_data())
  { data: m }
}

///|
// update_data 新增或更新事件（原始数据串，返回新管理器或错误）
pub fn EventManager::update_data(
  self : EventManager,
  name : String,
  data : String
) -> Result[EventManager, String] {
  match Event::validate(data) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  let m = self.data
  m.set(name, data)
  Ok({ data: m })
}

///|
// remove 通过事件名称移除事件（返回新管理器）
pub fn EventManager::remove(self : EventManager, name : String) -> EventManager {
  let m = self.data
  m.remove(name)
  { data: m }
}

///|
// from_name 从名称获取事件
pub fn EventManager::from_name(self : EventManager, name : String) -> Option[Event] {
  match self.data.get(name) {
    None => None
    Some(d) =>
      match Event::new(name, d) {
        Err(_) => None
        Ok(e) => Some(e)
      }
  }
}

///|
// all 所有事件
pub fn EventManager::all(self : EventManager) -> Array[Event] {
  let l : Array[Event] = []
  self.data.each(fn (k, v) {
    match Event::new(k, v) {
      Ok(e) => l.push(e)
      Err(_) => ()
    }
  })
  l
}

///|
// from_solar_day 指定公历日的事件列表
pub fn EventManager::from_solar_day(self : EventManager, d : SolarDay) -> Array[Event] {
  let l : Array[Event] = []
  let all = self.all()
  for i = 0; i < all.length(); i = i + 1 {
    let e = all[i]
    match e.get_solar_day(d.get_year()) {
      None => ()
      Some(t) => if d.equals(t) { l.push(e) } else { () }
    }
  }
  l
}

/// ===================== 方案 C：纯值类型（无全局态） =====================
// 已迁移至纯方案 C：无 global_mgr 单例、无无参壳方法。
// 公开 API 全部为显式状态传递：
//   EventManager::new/update/update_data/remove/from_name/all/from_solar_day
// 对应 Go EventManager.UpdateEvent/UpdateEventData/Remove + Event.FromName/All/FromSolarDay
// 的行为，但要求调用方显式持有 manager 实例（mgr.update / mgr.from_name …）。
