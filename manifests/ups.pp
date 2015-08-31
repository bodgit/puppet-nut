#
define nut::ups (
  $driver,
  $port,
  $extra = {},
) {

  if ! defined(Class['::nut']) {
    fail('You must include the nut base class before using any nut defined resources') # lint:ignore:80chars
  }

  validate_string($driver)
  validate_hash($extra)
  validate_string($port)

  ::concat::fragment { "nut ups ${name}":
    content => template('nut/ups.conf.erb'),
    target  => "${::nut::conf_dir}/ups.conf",
  }

  # Handle SNMP or XML UPS drivers
  if has_key($::nut::driver_packages, $driver) {
    ensure_packages([$::nut::driver_packages[$driver]])

    Package[$::nut::driver_packages[$driver]]
      -> ::Concat::Fragment["nut ups ${name}"]
  }
}
