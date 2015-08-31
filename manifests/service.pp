#
class nut::service {

  service { $::nut::service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
