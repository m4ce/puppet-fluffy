# Puppet types and providers for Fluffy

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with the fluffy module](#setup)
4. [Reference - Types reference and additional functionalities](#reference)
5. [Hiera integration](#hiera)
6. [Contact](#contact)

<a name="overview"/>
## Overview
This module implements native types and providers to manage Fluffy. The providers are *fully idempotent*.

<a name="module-description"/>
## Module Description
The fliffy module allows to automate the configuration and deployment of Fluffy interfaces, chains, services, addressbook and rules.

<a name="setup"/>
## Setup
The module requires the [fluffy-ruby](https://rubygems.org/gems/fluffy-ruby) rubygem. It also requires Puppet >= 4.0.0.

If you are using Puppet AIO, you may want to include the gem as part of the base installation. If not, you can install it as follows:

```
/opt/puppetlabs/puppet/bin/gem install fluffy-ruby
```

The include the main class as follows:

```
include fluffy
```

<a name="reference"/>
## Reference
### Classes
#### fluffy
`fluffy`

```
include fluffy
```

##### `opts` (optional)
Fluffy options in the form of {'option' => 'value'}.

Defaults to:
```yaml
fluffy::opts:
  max_sessions: 10
```

##### `logging_opts` (optional)
Fluffy logging options in the form of {'option' => 'value'}.

Defaults to:
```yaml
fluffy::logging_opts:
  version: 1
  disable_existing_loggers: false
  formatters:
    standard:
      format: "%{literal('%')}(asctime)s [%{literal('%')}(levelname)s] %{literal('%')}(name)s: %{literal('%')}(message)s"
  handlers:
    console:
      formatter: "standard"
      class: "logging.StreamHandler"
      stream: "ext://sys.stdout"
  loggers:
    "fluffy":
      handlers:
        - "console"
      level: "INFO"
      propagate: true
    "werkzeug":
      handlers:
        - "console"
      level: "ERROR"
```

##### `interfaces` (optional)
Fluffy interfaces in the form of {'interface_name' => { .. }}

Defaults to:
```yaml
fluffy::interfaces:
  loopback:
    interface: 'lo'
```

##### `addressbook` (optional)
Fluffy addressbook in the form of {'address_name' => { .. }}

Defaults to:
```yaml
fluffy::addressbook:
  admins:
    address: '0.0.0.0/0'
  loopback_net:
    address: '127.0.0.0/8'
```

##### `services` (optional)
Fluffy services in the form of {'service_name' => { .. }}

Defaults to:
```yaml
fluffy::services:
  dhcp:
    src_port:
      - '67:68'
    dst_port:
      - '67:68'
    protocol: 'udp'
  fluffy_api:
    dst_port:
      - 8676
    protocol: 'tcp'
  smtp:
    dst_port:
      - 25
    protocol: 'tcp'
  ssh:
    dst_port:
      - 22
    protocol: 'tcp'
```

##### `chains` (optional)
Fluffy chains in the form of {'chain_name' => { .. }}

Defaults to:
```yaml
fluffy::chains:
  "filter:FORWARD":
    policy: 'DROP'
  "filter:FORWARD_LOGGING":
    policy: 'ACCEPT'
  "filter:INPUT":
    policy: 'DROP'
  "filter:INPUT_LOGGING":
    policy: 'ACCEPT'
  "filter:OUTPUT":
    policy: 'ACCEPT'
```

##### `rules` (optional)
Fluffy rules in the form of {'rule_name' => { .. }}

Defaults to:
```yaml
fluffy::rules:
  "filter:FORWARD:invalid_state":
    ctstate:
      - 'INVALID'
    in_interface: 'any'
    jump: 'FORWARD_LOGGING'
    out_interface: 'any'
  "filter:INPUT:invalid_state":
    chain: 'INPUT'
    ctstate:
      - 'INVALID'
    in_interface: 'any'
    jump: 'INPUT_LOGGING'
  "filter:INPUT:input_established":
    action: 'ACCEPT'
    ctstate:
      - 'ESTABLISHED'
      - 'RELATED'
    in_interface: 'any'
  "filter:INPUT:antispoof":
    action: 'DROP'
    in_interface: 'lo'
    negate_src_address: true
    src_address:
      - 'loopback_net'
  "filter:INPUT:loopback":
    action: 'ACCEPT'
    in_interface: 'lo'
  "filter:INPUT:ssh_admins":
    action: 'ACCEPT'
    comment: 'Allow SSH in'
    dst_service:
      - 'ssh'
    in_interface: 'any'
    src_address:
      - 'admins'
  "filter:INPUT:fluffy_api":
    action: 'ACCEPT'
    comment: 'Allow access to Fluffy REST API'
    dst_service:
      - 'fluffy_api'
    in_interface: 'any'
    src_address:
      - 'admins'
  "filter:FORWARD:logging":
    in_interface: 'any'
    jump: 'FORWARD_LOGGING'
    out_interface: 'any'
  "filter:INPUT:logging":
    in_interface: 'any'
    jump: 'INPUT_LOGGING'
  "filter:FORWARD_LOGGING:logging_log":
    action: 'LOG'
    in_interface: 'any'
    limit: '2/min'
    log_level: 'warning'
    log_prefix: 'Fluffy CHAIN=FORWARD '
    out_interface: 'any'
  "filter:INPUT_LOGGING:logging_log":
    action: 'LOG'
    in_interface: 'any'
    limit: '2/min'
    log_level: 'warning'
    log_prefix: 'Fluffy CHAIN=INPUT '
```

##### `data_dir` (optional)
Path to the Fluffy data directory. Defaults to `/var/lib/fluffy`.

##### `config_dir` (optional)
Path to the Fluffy configuration directory. Defaults to `/etc/fluffy`.

##### `config_file` (optional)
Path to the Fluffy configuration file. Defaults to `$config_dir/fluffy.yaml`.

##### `config_file_manage` (optional)
Whether we should manage Fluffy's configuration file or not. Defaults to `true`.

##### `logging_file` (optional)
Path to the Fluffy logging file. Defaults to `$config_dir/logging.yaml`.

##### `logging_file_manage` (optional)
Whether we should manage Fluffy's logging file or not. Defaults to `true`.

##### `gem_dependencies` (optional)
Rubygems dependencies for Fluffy

Defaults to:
```yaml
fluffy::gem_dependencies:
  "fluffy-ruby": {}
```

##### `packages` (optional)
Installation packages for Fluffy

Defaults to:
```yaml
fluffy::packages:
  "fluffy": {}
```

##### `service_provider` (optional)
Fluffy service provider. Can be either `default` or `docker`. Defaults to `default`.

##### `service_opts` (optional)
Fluffy service options when using `docker` as a provider.

##### `service_name` (optional)
Fluffy service name. Defaults to `fluffy`.

##### `service_manage` (optional)
Whether we should manage the service runtime or not. Defaults to `true`.

##### `service_ensure` (optional)
Whether the resource is running or not. Valid values are `running`, `stopped`. Defaults to `running`.

##### `service_enable` (optional)
Whether the service is onboot enabled or not. Defaults to `true`.

### Types

#### fluffy_chain
`fluffy_chain` manages Fluffy chains

```
fluffy_chain {"<table>:<chain_name>": }
```

##### `name` (required)
Chain name

##### `table` (required)
Packet filtering table. Valid values are: `filter`, `nat`, `mangle`, `raw`, `security`.

##### `policy` (optional_
Default policy. Valid values are: `ACCEPT`, `DROP`, `RETURN`. Defaults to `ACCEPT`.

##### `ensure` (optional)
Whether the resource is present or not. Valid values are 'present', 'absent'. Defaults to `present`.

#### fluffy_interface
`fluffy_interface` manages Fluffy interfaces

```
fluffy_interface {"interface_name": }
```

##### `name` (required)
Interface name

##### `interface` (optional)
The actual network interface

##### `ensure` (optional)
Whether the resource is present or not. Valid values are 'present', 'absent'. Defaults to `present`.

#### fluffy_address
`fluffy_address` manages the Fluffy addressbook

```
fluffy_address {"address_name": }
```

##### `name` (required)
Address name

##### `address` (optional)
List of one or more addresses. It can be a reference to another address in the addressbook, a valid CIDR or an IP range.

##### `ensure` (optional)
Whether the resource is present or not. Valid values are 'present', 'absent'. Defaults to `present`.

#### fluffy_service
`fluffy_service` manages the Fluffy services

```
fluffy_service {"service_name": }
```

##### `name` (required)
Service name

##### `src_port` (optional)
Source port(s). Ports must be between 1-65535 or a valid port range.

##### `dst_port` (optional)
Destination port(s). Ports must be between 1-65535 or a valid port range.

##### `protocol` (optional)
Network protocol. Valid values are: `ip`, `tcp`, `udp`, `icmp`, `ipv6-icmp`, `esp`, `ah`, `vrrp`, `igmp`, `ipencap`, `ipv4`, `ipv6`, `ospf`, `gre`, `cbt`, `sctp`, `pim`, `all`. Defaults to `all`.

##### `ensure` (optional)
Whether the resource is present or not. Valid values are 'present', 'absent'. Defaults to `present`.

```
fluffy_rule {"<table>:<chain>:<rule_name>": }
```

##### `name` (required)
Rule name

##### `table` (required)
Rule packet filtering table

##### `chain` (required)
Rule chain name

##### `before_rule` (optional)
Add the new rule before the specified rule name

##### `after_rule` (optional)
Add the new rule after the specified rule name

##### `action` (optional)
Rule action. Valid values are: `absent`, `ACCEPT`, `DROP`, `REJECT`, `QUEUE`, `RETURN`, `DNAT`, `SNAT`, `LOG`, `MASQUERADE`, `REDIRECT`, `MARK`, `TCPMSS`. Defaults to `absent`.

##### `jump` (optional)
Rule jump target. Defaults to `absent`.

##### `negate_protocol` (optional)
Negate protocol. Defaults to `false`.

##### `protocol` (optional)
Network protocol. Valid values are: `absent`, `ip`, `tcp`, `udp`, `icmp`, `ipv6-icmp`, `esp`, `ah`, `vrrp`, `igmp`, `ipencap`, `ipv4`, `ipv6`, `ospf`, `gre`, `cbt`, `sctp`, `pim`, `all`. Defaults to `absent`.

##### `negate_icmp_type` (optional)
Negate ICMP type. Defaults to `false`.

##### `icmp_type` (optional)
ICMP type. Valid values are: `absent`, `any`, `echo-reply`, `echo-request`. Defaults to `absent`.

##### `negate_tcp_flags` (optional)
Negate TCP flags. Defaults to `false`.

##### `tcp_flags` (optional)
TCP flags. Defaults to `absent`.

##### `negate_ctstate` (optional)
Negate conntrack state(s). Defaults to `false`.

##### `ctstate` (optional)
Conntrack state(s). Defaults to `[]`.

##### `negate_state` (optional)
Negate connection state(s). Defaults to `false`.

##### `state` (optional)
Connection state(s). Defaults to `[]`.

##### `negate_src_address_range` (optional)
Negate source range address(es). Defaults to `false`.

##### `src_address_range` (optional)
Source range address(es). Addresses must be valid IP ranges. Defaults to `[]`.

##### `negate_dst_address_range` (optional)
Negate destination range address(es). Defaults to `false`.

##### `dst_address_range` (optional)
Destination range address(es). Addresses must be valid IP ranges. Defaults to `[]`.

##### `negate_in_interface` (optional)
Negate input interface. Defaults to `false`.

##### `in_interface` (optional)
Input interface. Defaults to `absent`.

##### `negate_out_interface` (optional)
Negate output interface. Defaults to `false`.

##### `out_interface` (optional)
Input interface. Defaults to `absent`.

##### `negate_src_address` (optional)
Negate source address(es). Defaults to `false`.

##### `src_address` (optional)
Source address(es). Address must be valid addressbook entries. Defaults to `[]`.

##### `negate_dst_address` (optional)
Negate destination range address(es). Defaults to `false`.

##### `dst_address` (optional)
Destination address(es). Addresses must be valid addressbook entries. Defaults to `[]`.

##### `negate_src_service` (optional)
Negate source service(es). Defaults to `false`.

##### `src_service` (optional)
Source service(es). Defaults to `[]`.

##### `negate_dst_service` (optional)
Negate destination service(es). Defaults to `false`.

##### `dst_service` (optional)
Destination service(es). Defaults to `[]`.

##### `reject_with` (optional)
Reject with. Valid values are: `absent`, `icmp-net-unreachable`, `icmp-host-unreachable`, `icmp-port-unreachable`, `icmp-proto-unreachable`, `icmp-net-prohibited`, `icmp-host-prohibited`, `icmp-admin-prohibited`. Defaults to `absent`.

##### `set_mss` (optional)
Set maximum segment size (MSS). Defaults to `absent`.

##### `clamp_mss_to_pmtu` (optional)
Clamp MSS to path MTU. Defaults to `false`.

##### `to_src` (optional)
Source NAT. Defaults to `absent`.

##### `to_dst` (optional)
Destination NAT. Defaults to `absent`.

##### `limit` (optional)
Limit rate. Defaults to `absent`.

##### `limit_burst` (optional)
Limit burst. Defaults to `absent`.

##### `log_level` (optional)
Log level. Valid values are: `absent`, `emerg`, `alert`, `crit`, `err`, `warning`, `notice`, `info`, `debug`. Defaults to `absent`.

##### `comment` (optional)
Comment. Defaults to `absent`.

##### `ensure` (optional)
Whether the resource is present or not. Valid values are 'present', 'absent'. Defaults to `present`.

<a name="hiera"/>
## Hiera integration
The entire module data is driven via Hiera.

<a name="contact"/>
## Contact
Matteo Cerutti - matteo.cerutti@hotmail.co.uk
