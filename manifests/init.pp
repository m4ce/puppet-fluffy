class fluffy (
  Fluffy::Options $opts,
  Hash $logging_opts,
  Fluffy::Addressbook $addressbook,
  Fluffy::Interfaces $interfaces,
  Fluffy::Services $services,
  Fluffy::Chains $chains,
  Fluffy::Rules $rules,
  String $data_dir,
  String $config_dir,
  String $config_file,
  Boolean $config_file_manage,
  String $logging_file,
  Boolean $logging_file_manage,
  Fluffy::Rollback_checks $rollback_checks,
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

  $addressbook.each |String $name, Fluffy::Address $address| {
    fluffy_address {$name:
      * => $address
    }
  }

  $interfaces.each |String $name, Fluffy::Interface $interface| {
    fluffy_interface {$name:
      * => $interface
    }
  }

  $services.each |String $name, Fluffy::Service $service| {
    fluffy_service {$name:
      * => $service
    }
  }

  $chains.each |String $name, Fluffy::Chain $chain| {
    fluffy_chain {$name:
      * => $chain
    }
  }

  # Puppet will preserve the order of the hash as described in the Hiera configuration
  $prev_rule = undef
  $rules.each |String $name, Fluffy::Rule $rule| {
    fluffy_rule {$name:
      * => $rule
    }

    if $prev_rule {
      Fluffy_rule[$name] {
        after_rule => $prev_rule
      }
    }

    $prev_rule = $name
  }

  $rollback_checks.each |String $rollback_name, Fluffy::Rollback_check $rollback| {
    fluffy::rollback_script {$rollback_name:
      * => $rollback
    }
  }

  # These will only kick off when refreshed.
  fluffy_test {"puppet": }
  fluffy_commit {"puppet": }
}
