# @!visibility private
class nut::client::service {

  service { $::nut::client::service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
