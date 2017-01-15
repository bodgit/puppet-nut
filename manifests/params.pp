# @!visibility private
class nut::params {

  $server_package_name = 'nut'
  $shutdown_command    = '/sbin/shutdown -h +0'

  case $::osfamily {
    'RedHat': {
      $cgi_conf_dir        = '/etc/ups'
      $cgi_package_name    = 'nut-cgi'
      $client_package_name = 'nut-client'
      $client_service_name = 'nut-monitor'
      $conf_dir            = '/etc/ups'
      $driver_packages     = {
        'netxml-ups' => 'nut-xml',
      }
      $group               = 'nut'
      $http_server         = 'apache'
      $manage_vhost        = true
      $server_service_name = 'nut-server'
      $state_dir           = '/var/run/nut'
      $upssched            = '/usr/sbin/upssched'
      $user                = 'nut'
    }
    'OpenBSD': {
      $cgi_conf_dir        = '/var/www/conf/nut'
      $cgi_package_name    = 'nut-cgi'
      $client_package_name = 'nut'
      $client_service_name = 'upsmon'
      $conf_dir            = '/etc/nut'
      $driver_packages     = {
        'snmp-ups'   => 'nut-snmp',
        'netxml-ups' => 'nut-xml',
      }
      $group               = '_ups'
      $http_server         = 'httpd'
      $manage_vhost        = false
      $server_service_name = 'upsd'
      $state_dir           = '/var/db/nut'
      $upssched            = '/usr/local/sbin/upssched'
      $user                = '_ups'
    }
    default: {
      fail("The ${module_name} module is not supported on ${::osfamily} based system.")
    }
  }

  $apache_resources = {
    '::apache::vhost' => {
      'nut' => {
        'servername'  => "nut.${::domain}",
        'port'        => 80,
        'docroot'     => '/var/www/html',
        'scriptalias' => '/var/www/nut-cgi-bin',
      },
    },
  }
}
