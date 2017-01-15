# @!visibility private
class nut::client::config {

  $certident   = $::nut::client::certident
  $certpath    = $::nut::client::certpath
  $certverify  = $::nut::client::certverify
  $cmdscript   = $::nut::client::cmdscript
  $conf_dir    = $::nut::client::conf_dir
  $forcessl    = $::nut::client::forcessl
  $group       = $::nut::client::group
  $minsupplies = $::nut::client::minsupplies
  $notifycmd   = $::nut::client::notifycmd
  $notifyflag  = $::nut::client::notifyflag
  $notifymsg   = $::nut::client::notifymsg
  $shutdowncmd = $::nut::client::shutdowncmd
  $state_dir   = $::nut::client::state_dir
  $user        = $::nut::client::user

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

  ensure_resource('file', $state_dir, {
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  })

  if $::nut::client::use_upssched {

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
    }

    file { "${conf_dir}/upssched.conf":
      ensure => absent,
    }
  }
}
