# @!visibility private
class nut::common::service {

  if $::nut::common::manage_service {
    service { $::nut::common::service_name:
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }
  }
}
