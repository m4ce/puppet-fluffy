define fluffy::rollback_script (
  String $interpreter = "/bin/sh",
  Optional[String] $script = undef,
  Enum["present", "absent"] $ensure = "present"
) {
  unless defined(Class["fluffy"]) {
    fail("You must include the fluffy base class before using any fluffy defined resources")
  }

  file {"${fluffy::config_dir}/rollback.d/${name}.chk":
    owner => "root",
    group => "root",
    mode => "0755",
    ensure => $ensure,
    require => File["${fluffy::config_dir}/rollback.d"]
  }

  if $script {
    File["${fluffy::config_dir}/rollback.d/${name}.chk"] {
      content => epp("fluffy/rollback_check.epp", {"script" => $script, "interpreter" => $interpreter})
    }
  } else {
    File["${fluffy::config_dir}/rollback.d/${name}.chk"] {
      source => "puppet:///modules/fluffy/rollback.d/${name}.chk"
    }
  }
}
