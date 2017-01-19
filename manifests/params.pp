# @!visibility private
class nut::params {

  $shutdown_command    = '/sbin/shutdown -h +0'

  case $::osfamily {
    'RedHat': {
      $apache_resources    = {
        '::apache::vhost' => {
          'nut' => {
            'servername'  => "nut.${::domain}",
            'port'        => 80,
            'docroot'     => '/var/www/html',
            'scriptalias' => '/var/www/nut-cgi-bin',
          },
        },
      }
      $cgi_conf_dir        = '/etc/ups'
      $cgi_package_name    = 'nut-cgi'
      $client_package_name = 'nut-client'
      $conf_dir            = '/etc/ups'
      $driver_packages     = {
        'netxml-ups' => 'nut-xml',
      }
      $group               = 'nut'
      $http_server         = 'apache'
      $manage_vhost        = true
      $server_package_name = 'nut'
      $state_dir           = '/var/run/nut'
      $upssched            = '/usr/sbin/upssched'
      $user                = 'nut'

      case $::operatingsystemmajrelease {
        '6': {
          $client_manage_package = true
          $client_manage_service = false
          $client_service_name   = 'ups'
          $server_service_name   = 'ups'
        }
        default: {
          $client_manage_package = true
          $client_manage_service = true
          $client_service_name   = 'nut-monitor'
          $server_service_name   = 'nut-server'
        }
      }
    }
    'OpenBSD': {
      $apache_resources      = {}
      $cgi_conf_dir          = '/var/www/conf/nut'
      $cgi_package_name      = 'nut-cgi'
      $client_manage_package = false
      $client_manage_service = true
      $client_package_name   = 'nut'
      $client_service_name   = 'upsmon'
      $conf_dir              = '/etc/nut'
      $driver_packages       = {
        'snmp-ups'   => 'nut-snmp',
        'netxml-ups' => 'nut-xml',
      }
      $group                 = '_ups'
      $http_server           = 'httpd'
      $manage_vhost          = false
      $server_package_name   = 'nut'
      $server_service_name   = 'upsd'
      $state_dir             = '/var/db/nut'
      $upssched              = '/usr/local/sbin/upssched'
      $user                  = '_ups'
    }
    'Debian': {
      $apache_resources      = {
        '::apache::vhost' => {
          'nut' => {
            'servername'  => "nut.${::domain}",
            'port'        => 80,
            'docroot'     => '/usr/share/nut/www',
            'scriptalias' => '/usr/lib/cgi-bin',
          },
        },
      }
      $cgi_conf_dir          = '/etc/nut'
      $cgi_package_name      = 'nut-cgi'
      $client_manage_package = true
      $client_manage_service = true
      $client_package_name   = 'nut-client'
      $client_service_name   = 'nut-client'
      $conf_dir              = '/etc/nut'
      $driver_packages       = {
        'snmp-ups'    => 'nut-snmp',
        'netxml-ups'  => 'nut-xml',
        'nut-ipmipsu' => 'nut-ipmi',
      }
      $group                 = 'nut'
      $http_server           = 'apache'
      $manage_vhost          = true
      $server_package_name   = 'nut-server'
      $server_service_name   = 'nut-server'
      $state_dir             = '/var/run/nut'
      $upssched              = '/sbin/upssched'
      $user                  = 'nut'
    }
    default: {
      fail("The ${module_name} module is not supported on ${::osfamily} based system.")
    }
  }
}
