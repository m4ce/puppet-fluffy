class fluffy::service {
  if $fluffy::service_manage {
    case $fluffy::service_provider {
      default: {
        service {$fluffy::service_name:
          ensure => $fluffy::service_ensure,
          enable => $fluffy::service_enable,
          subscribe => Package[keys($fluffy::packages)]
        }
      }
      "docker": {
        docker_container {
          $fluffy::service_name:
            * => $fluffy::service_opts;

          default:
            image => $fluffy::service_image,
            ensure => $fluffy::service_ensure
        }

        if $fluffy::service_enable {
          Docker_container[$fluffy::service_name] {
            restart_policy => "unless-stopped"
          }
        }
      }
    }
  }
}
