# @!visibility private
class nut::config {

  $certfile    = $::nut::certfile
  $certident   = $::nut::certident
  $certpath    = $::nut::certpath
  $certrequest = $::nut::certrequest
  $conf_dir    = $::nut::conf_dir
  $group       = $::nut::group
  $listen      = $::nut::listen
  $maxage      = $::nut::maxage
  $maxconn     = $::nut::maxconn
  $statepath   = $::nut::statepath
  $user        = $::nut::user

  case $::osfamily {
    'RedHat': {

      # So udev rules take effect
      ensure_resource('exec', 'udevadm trigger', {
        path        => $::path,
        refreshonly => true,
      })
    }
    default: {
      # noop
    }
  }

  ensure_resource('group', $group, {
    ensure => present,
    system => true,
  })

  ensure_resource('user', $user, {
    ensure => present,
    gid    => $group,
    system => true,
  })

  ensure_resource('file', $conf_dir, {
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  })

  ensure_resource('file', $statepath, {
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  })

  ::concat { "${conf_dir}/ups.conf":
    owner => 0,
    group => $group,
    mode  => '0640',
    warn  => "# !!! Managed by Puppet !!!\n\n",
  }

  ::concat { "${conf_dir}/upsd.users":
    owner => 0,
    group => $group,
    mode  => '0640',
    warn  => "# !!! Managed by Puppet !!!\n\n",
  }

  file { "${conf_dir}/upsd.conf":
    ensure  => file,
    owner   => 0,
    group   => $group,
    mode    => '0640',
    content => template("${module_name}/upsd.conf.erb"),
  }
}
