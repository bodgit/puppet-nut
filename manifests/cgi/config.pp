#
class nut::cgi::config {

  $conf_dir = $::nut::cgi::conf_dir

  case $::osfamily { # lint:ignore:case_without_default
    'OpenBSD': {
      #$owner = $::nut::user
      #$group = 0
      #$mode  = '0600'
    }
    'RedHat': {
    }
  }

  ::concat { "${conf_dir}/hosts.conf":
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => '# !!! Managed by Puppet !!!',
  }

  file { "${conf_dir}/upsset.conf":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => file('nut/upsset.conf'),
  }

  if $::nut::cgi::manage_vhost {
    case $::osfamily { # lint:ignore:case_without_default
      'OpenBSD': {
      }
      'RedHat': {
        ::apache::vhost { 'nut':
          servername  => "nut.${::domain}",
          port        => 80,
          docroot     => '/var/www/html',
          scriptalias => '/var/www/nut-cgi-bin',
        }
      }
    }
  }
}
