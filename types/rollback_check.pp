type Fluffy::Rollback_check = Struct[{
  Optional[interpreter] => String,
  Optional[script] => Optional[String],
  Optional[ensure] => Enum["present", "absent"]
}]
