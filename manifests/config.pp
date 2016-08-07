#
class nut::config {

  $conf_dir = $::nut::conf_dir

  case $::osfamily { # lint:ignore:case_without_default
    'OpenBSD': {
      $owner = $::nut::user
      $group = 0
      $mode  = '0600'
    }
    'RedHat': {
      $owner = 0
      $group = $::nut::group
      $mode  = '0640'

      # So udev rules take effect
      exec { 'udevadm trigger':
        path        => [
          '/sbin',
          '/usr/sbin',
          '/bin',
          '/usr/bin',
        ],
        refreshonly => true,
      }
    }
  }

  ensure_resource('file', $::nut::conf_dir, {
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  })

  ::concat { "${conf_dir}/ups.conf":
    owner => $owner,
    group => $group,
    mode  => $mode,
    warn  => '# !!! Managed by Puppet !!!',
  }

  ::concat { "${conf_dir}/upsd.users":
    owner => $owner,
    group => $group,
    mode  => $mode,
    warn  => '# !!! Managed by Puppet !!!',
  }

  # FIXME
  file { "${conf_dir}/upsd.conf":
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
