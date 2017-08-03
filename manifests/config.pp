class fluffy::config {
  file {[$fluffy::data_dir, $fluffy::config_dir]:
    owner => "root",
    group => "root",
    mode => "0755",
    ensure => "directory"
  }

  if $fluffy::config_file_manage {
    file {$fluffy::config_file:
      owner => "root",
      group => "root",
      mode => "0644",
      content => epp("fluffy/fluffy.yaml.epp", {'config' => generate_yaml(deep_merge({'data_dir' => $fluffy::data_dir}, $fluffy::opts))})
    }

    if $fluffy::service_manage {
      case $fluffy::service_provider {
        default: {
          File[$fluffy::config_file] {
            notify => Service[$fluffy::service_name]
          }
        }
        "docker": {
          File[$fluffy::config_file] {
            notify => Docker_container[$fluffy::service_name]
          }
        }
      }
    }
  }

  if $fluffy::logging_file_manage {
    file {$fluffy::logging_file:
      owner => "root",
      group => "root",
      mode => "0644",
      content => epp("fluffy/logging.yaml.epp", {'config' => generate_yaml($fluffy::logging_opts)})
    }

    if $fluffy::service_manage {
      case $fluffy::service_provider {
        default: {
          File[$fluffy::logging_file] {
            notify => Service[$fluffy::service_name]
          }
        }
        "docker": {
          File[$fluffy::logging_file] {
            notify => Docker_container[$fluffy::service_name]
          }
        }
      }
    }
  }
}
