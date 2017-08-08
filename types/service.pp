type Fluffy::Service = Struct[{
  Optional[src_port] => Variant[Fluffy::Service::Port, Array[Fluffy::Service::Port]],
  Optional[dst_port] => Variant[Fluffy::Service::Port, Array[Fluffy::Service::Port]],
  Optional[protocol] => Fluffy::Protocols,
  Optional[ensure] => Enum["present", "absent"]
}]
