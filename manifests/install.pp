class fluffy::install {
  $fluffy::gem_dependencies.each |String $gem_name, Hash $gem| {
    package {$gem_name:
      * => $gem,
      provider => "puppet_gem"
    }
  }

  case $fluffy::service_provider {
    "docker": {
      docker_image {$fluffy::service_image: }
    }
    default: {
      $fluffy::packages.each |String $package_name, Hash $package| {
        package {$package_name:
          * => $package
        }
      }
    }
  }
}
