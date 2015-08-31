#
class nut::params {

  case $::osfamily {
    'RedHat': {
      $cgi_package_name    = 'nut-cgi'
      $client_package_name = 'nut-client'
      $client_service_name = 'nut-monitor'
      $conf_dir            = '/etc/ups'
      $driver_packages     = {
        'netxml-ups' => 'nut-xml',
      }
      $group               = 'nut'
      $server_package_name = 'nut'
      $server_service_name = 'nut-server'
      $shutdown_command    = '/sbin/shutdown -h +0'
      $user                = 'nut'
    }
    'OpenBSD': {
      $cgi_package_name    = 'nut-cgi'
      $client_package_name = 'nut'
      $client_service_name = 'upsmon'
      $conf_dir            = '/etc/nut'
      $driver_packages     = {
        'snmp-ups'   => 'nut-snmp',
        'netxml-ups' => 'nut-xml',
      }
      $group               = '_ups'
      $server_package_name = 'nut'
      $server_service_name = 'upsd'
      $shutdown_command    = '/sbin/shutdown -h +0'
      $user                = '_ups'
    }
    default: {
      fail("The ${module_name} module is not supported on ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
