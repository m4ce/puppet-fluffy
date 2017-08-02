type Fluffy::Check = Struct[{
  Optional["type"] => Enum["tcp", "exec"],
  Optional[command] => Optional[String],
  Optional[host] => Optional[String],
  Optional[port] => Optional[Integer[1, 65535]],
  Optional[timeout] => Optional[Integer[1]],
  Optional[ensure] => Enum["present", "absent"]
}]
