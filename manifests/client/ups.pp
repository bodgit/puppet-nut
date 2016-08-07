#
define nut::client::ups (
  $user,
  $password,
  $powervalue = 1,
  $type       = $name ? {
    /@localhost(:\d+)?$/ => 'master',
    default              => 'slave',
  },
) {

  if ! defined(Class['::nut::client']) {
    fail('You must include the nut::client base class before using any nut::client defined resources') # lint:ignore:80chars
  }

  # ups@host(:port)
  validate_re($name, '^[^@]+@[^$:]+(:\d+)?$')
  validate_string($user)
  validate_string($password)
  validate_integer($powervalue)
  validate_re($type, '^(?:master|slave)$')

  ::concat::fragment { "nut upsmon ${name}":
    content => "MONITOR ${name} ${powervalue} ${user} ${password} ${type}\n",
    target  => "${::nut::client::conf_dir}/upsmon.conf",
  }
}
