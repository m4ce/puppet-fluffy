type Fluffy::Service = Struct[{
  Optional[src_port] => Array[Variant[Pattern[/^\d+:\d+$/], Integer[1, 65535]]],
  Optional[dst_port] => Array[Variant[Pattern[/^\d+:\d+$/], Integer[1, 65535]]],
  Optional[protocol] => Enum['ip', 'tcp', 'udp', 'icmp', 'ipv6-icmp', 'esp', 'ah', 'vrrp', 'igmp', 'ipencap', 'ipv4', 'ipv6', 'ospf', 'gre', 'cbt', 'sctp', 'pim', 'all'],
  Optional[ensure] => Enum["present", "absent"]
}]
