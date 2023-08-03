# Adds and configures a UPS.
#
# @example Adding a USB-connected Smart-UPS 1000i
#   include ::nut
#   ::nut::ups { 'sua1000i':
#     driver => 'usbhid-ups',
#     port   => 'auto',
#   }
#
# @param driver The driver to use for this UPS.
# @param port The port or device name where the UPS is attached.
# @param extra Any additional driver-specific options can be passed here.
# @param ups The name of the UPS.
#
# @see puppet_classes::nut ::nut
# @see puppet_defined_types::nut::user ::nut::user
define nut::ups (
  String                             $driver,
  Variant[Integer[0, 65535], String] $port,
  Hash[String, Any]                  $extra = {},
  String                             $ups   = $title,
) {

  if ! defined(Class['nut']) {
    fail('You must include the nut base class before using any nut defined resources')
  }

  ::concat::fragment { "nut ups ${ups}":
    content => template("${module_name}/ups.conf.erb"),
    target  => "${::nut::conf_dir}/ups.conf",
  }

  # Handle SNMP or XML UPS drivers
  if $driver in $::nut::driver_packages {
    ensure_packages([$::nut::driver_packages[$driver]])

    Package[$::nut::driver_packages[$driver]]
      -> ::Concat::Fragment["nut ups ${ups}"]
  }
}
