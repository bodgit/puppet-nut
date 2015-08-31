#
class nut::client::config {

  $conf_dir         = $::nut::client::conf_dir
  $minimum_supplies = $::nut::client::minimum_supplies
  $shutdown_command = $::nut::client::shutdown_command
  $user             = $::nut::client::user

  case $::osfamily { # lint:ignore:case_without_default
    'OpenBSD': {
      $owner = $::nut::client::user
      $group = 0
      $mode  = '0600'
    }
    'RedHat': {
      $owner = 0
      $group = $::nut::client::group
      $mode  = '0640'
    }
  }

  ensure_resource('file', $conf_dir, {
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  })

  ::concat { "${conf_dir}/upsmon.conf":
    owner => $owner,
    group => $group,
    mode  => $mode,
    warn  => '# !!! Managed by Puppet !!!',
  }

  ::concat::fragment { 'nut upsmon header':
    content => template('nut/upsmon.conf.erb'),
    order   => '01',
    target  => "${conf_dir}/upsmon.conf",
  }
}
