# Configure a user for UPS access.
#
# @example Declaring a user
#   include ::nut
#   ::nut::user { 'test':
#     password => 'password',
#   }
#
# @example Declaring a upsmon user
#   include ::nut
#   ::nut::user { 'monmaster':
#     password => 'secret',
#     upsmon   => 'master',
#   }
#
# @param password The password for the user.
# @param actions List of actions to permit the user to do.
# @param instcmds List of instant commands the user can initiate.
# @param upsmon Set the user to be used by upsmon.
# @param user The name of the user.
#
# @see puppet_classes::nut ::nut
# @see puppet_defined_types::nut::ups ::nut::ups
define nut::user (
  String                            $password,
  Optional[Array[String, 1]]        $actions  = undef,
  Optional[Array[String, 1]]        $instcmds = undef,
  Optional[Enum['master', 'slave']] $upsmon   = undef,
  String                            $user     = $title,
) {

  if ! defined(Class['nut']) {
    fail('You must include the nut base class before using any nut defined resources')
  }

  ::concat::fragment { "nut user ${user}":
    content => template('nut/upsd.users.erb'),
    target  => "${::nut::conf_dir}/upsd.users",
  }
}
