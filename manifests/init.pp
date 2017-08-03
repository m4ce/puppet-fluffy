class fluffy (
  Fluffy::Options $opts,
  Hash $logging_opts,
  Fluffy::Addressbook $addressbook,
  Fluffy::Interfaces $interfaces,
  Fluffy::Services $services,
  Fluffy::Chains $chains,
  Fluffy::Rules $rules,
  Boolean $purge_rules,
  String $data_dir,
  String $config_dir,
  String $config_file,
  Boolean $config_file_manage,
  String $logging_file,
  Boolean $logging_file_manage,
  Fluffy::Checks $checks,
  Hash $gem_dependencies,
  Hash $packages,
  Enum["default", "docker"] $service_provider,
  Hash $service_opts,
  String $service_image,
  String $service_name,
  Boolean $service_manage,
  Enum["present", "absent", "stopped", "running"] $service_ensure,
  Boolean $service_enable
) {
  include fluffy::install
  include fluffy::config
  include fluffy::service

  $addressbook.each |String $address_name, Fluffy::Address $address| {
    fluffy_address {$address_name:
      * => $address
    }
  }

  $interfaces.each |String $interface_name, Fluffy::Interface $interface| {
    fluffy_interface {$interface_name:
      * => $interface
    }
  }

  $services.each |String $service_name, Fluffy::Service $service| {
    fluffy_service {$service_name:
      * => $service
    }
  }

  $chains.each |String $chain_name, Fluffy::Chain $chain| {
    fluffy_chain {$chain_name:
      * => $chain
    }
  }

  resources {'fluffy_rule':
    purge => $purge_rules
  }

  fluffy_build_rules($rules).each |String $rule_name, Fluffy::Rule $rule| {
    fluffy_rule {$rule_name:
      * => $rule
    }
  }

  $checks.each |String $check_name, Fluffy::Check $check| {
    fluffy_check {$check_name:
      * => $check
    }
  }

  # These will only kick off when refreshed.
  fluffy_test {"puppet": }
  fluffy_commit {"puppet": }
}
