type Fluffy::Address = Struct[{
  Optional[address] => Variant[String, Array[String]],
  Optional[ensure] => Enum["present", "absent"]
}]
