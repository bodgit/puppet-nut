# Add a local or remote UPS to monitor.
#
# @example Monitoring a local UPS
#   include ::nut
#   ::nut::ups { 'sua1000i':
#     driver => 'usbhid-ups',
#     port   => 'auto',
#   }
#   ::nut::user { 'test':
#     password => 'password',
#     upsmon   => 'master',
#   }
#   ::nut::client::ups { 'sua1000i@localhost':
#     user     => 'test',
#     password => 'password',
#     type     => 'master',
#   }
#
# @example Monitoring a remote UPS
#   include ::nut::client
#   ::nut::client::ups { 'sua1000i@remotehost':
#     user     => 'test',
#     password => 'password',
#     type     => 'slave',
#   }
#
# @param user Username to use to connect to `upsd`.
# @param password Password to use to connect to `upsd`.
# @param certhost If using NSS and client certificate authentication specify
#   a tuple of certificate name, whether to verify and whether to force TLS
#   with the remote host.
# @param powervalue How many power supplies does this UPS feed.
# @param type Is the UPS being monitored attached to the local system or not.
# @param ups The UPS to monitor.
#
# @see puppet_classes::nut::client ::nut::client
# @see puppet_defined_types::nut::client::upssched ::nut::client::upssched
define nut::client::ups (
  String                                    $user,
  String                                    $password,
  Optional[Tuple[String, Boolean, Boolean]] $certhost   = undef,
  Integer[0]                                $powervalue = 1,
  Enum['master', 'slave']                   $type       = $title ? {
    /@localhost(:\d+)?$/ => 'master',
    default              => 'slave',
  },
  Nut::Device                               $ups        = $title,
) {

  if ! defined(Class['nut::common']) {
    fail('You must include the nut::common base class before using any nut::client defined resources')
  }

  ::concat::fragment { "nut upsmon ${ups}":
    content => template("${module_name}/upsmon.ups.erb"),
    target  => "${::nut::common::conf_dir}/upsmon.conf",
  }
}
