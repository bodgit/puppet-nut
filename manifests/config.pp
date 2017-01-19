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

  group { $group:
    ensure => present,
    system => true,
  }

  user { $user:
    ensure => present,
    gid    => $group,
    system => true,
  }

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { $statepath:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

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

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '6': {
          $server = true

          file { '/etc/sysconfig/ups':
            ensure  => file,
            owner   => 0,
            group   => 0,
            mode    => '0644',
            content => template("${module_name}/sysconfig.erb"),
          }
        }
        default: {
          # noop
        }
      }
    }
    'Debian': {
      $content = @(EOS/L)
        # !!! Managed by Puppet !!!

        MODE=netserver
        | EOS

      file { "${conf_dir}/nut.conf":
        ensure  => file,
        owner   => 0,
        group   => $group,
        mode    => '0640',
        content => $content,
      }
    }
    default: {
      # noop
    }
  }
}
