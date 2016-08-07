#
define nut::user (
  $password,
  $actions  = [],
  $instcmds = [],
  $upsmon   = undef,
) {

  if ! defined(Class['::nut']) {
    fail('You must include the nut base class before using any nut defined resources') # lint:ignore:80chars
  }

  validate_array($actions)
  validate_array($instcmds)
  if $upsmon {
    validate_re($upsmon, '^(?:master|slave)$')
  }
  validate_string($password)

  ::concat::fragment { "nut user ${name}":
    content => template('nut/upsd.users.erb'),
    target  => "${::nut::conf_dir}/upsd.users",
  }
}
