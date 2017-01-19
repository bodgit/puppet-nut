# @!visibility private
class nut::client::config {

  $conf_dir  = $::nut::client::conf_dir
  $group     = $::nut::client::group
  $state_dir = $::nut::client::state_dir
  $user      = $::nut::client::user

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

  file { $state_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '6': {
          $server = false

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

        MODE=netclient
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
