type Fluffy::Chain = Struct[{
  Optional[table] => Enum['filter', 'nat', 'mangle', 'raw', 'security'],
  Optional[policy] => Enum['ACCEPT', 'DROP', 'RETURN'],
  Optional[ensure] => Enum["present", "absent"]
}]
