# @!visibility private
class nut::common::config {

  $certident   = $::nut::common::certident
  $certpath    = $::nut::common::certpath
  $certverify  = $::nut::common::certverify
  $cmdscript   = $::nut::common::cmdscript
  $conf_dir    = $::nut::common::conf_dir
  $forcessl    = $::nut::common::forcessl
  $group       = $::nut::common::group
  $minsupplies = $::nut::common::minsupplies
  $notifycmd   = $::nut::common::notifycmd
  $notifyflag  = $::nut::common::notifyflag
  $notifymsg   = $::nut::common::notifymsg
  $shutdowncmd = $::nut::common::shutdowncmd
  $state_dir   = $::nut::common::state_dir
  $user        = $::nut::common::user

  ::concat { "${conf_dir}/upsmon.conf":
    owner => 0,
    group => $group,
    mode  => '0640',
    warn  => "# !!! Managed by Puppet !!!\n\n",
  }

  ::concat::fragment { 'nut upsmon header':
    content => template("${module_name}/upsmon.conf.erb"),
    order   => '01',
    target  => "${conf_dir}/upsmon.conf",
  }

  if $::nut::common::use_upssched {

    file { "${state_dir}/upssched":
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0640',
    }

    ::concat { "${conf_dir}/upssched.conf":
      owner => 0,
      group => $group,
      mode  => '0640',
      warn  => "# !!! Managed by Puppet !!!\n\n",
    }

    ::concat::fragment { 'nut upssched header':
      content => template("${module_name}/upssched.conf.erb"),
      order   => '01',
      target  => "${conf_dir}/upssched.conf",
    }
  } else {

    file { "${state_dir}/upssched":
      ensure => absent,
      force  => true,
    }

    file { "${conf_dir}/upssched.conf":
      ensure => absent,
    }
  }
}
