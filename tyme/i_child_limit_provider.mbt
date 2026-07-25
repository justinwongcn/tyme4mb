///|
// IChildLimitProvider 童限计算接口
pub trait IChildLimitProvider {
  // get_info 根据出生公历时刻和节令计算童限信息
  get_info(Self, SolarTime, SolarTerm) -> ChildLimitInfo
}
