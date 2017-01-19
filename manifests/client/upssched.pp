# Define actions for `upssched`.
#
# @example Configure an action when local UPS has disconnected
#   class { '::nut::client':
#     use_upssched => true,
#   }
#   ::nut::client::upssched { 'local ups has disconnected':
#     args       => [
#       'upsgone',
#       10,
#     ],
#     command    => 'start-timer',
#     notifytype => 'commbad',
#     ups        => 'test@localhost',
#   }
#
# @param args Additional arguments to pass to the command.
# @param command The command to run.
# @param notifytype The event notification to apply the action to.
# @param ups The UPS to apply the action to, or "*" to apply to all.
#
# @see puppet_classes::nut::client ::nut::client
# @see puppet_defined_types::nut::client::ups ::nut::client::ups
define nut::client::upssched (
  Array[Variant[String, Integer], 1]             $args,
  Enum['start-timer', 'cancel-timer', 'execute'] $command,
  Nut::Event                                     $notifytype,
  Variant[Nut::Device, Enum['*']]                $ups,
) {

  if ! defined(Class['::nut::common']) {
    fail('You must include the nut::common base class before using any nut::client defined resources')
  }

  if $::nut::client::use_upssched {
    ::concat::fragment { "nut upssched ${title}":
      content => template("${module_name}/upssched.at.erb"),
      target  => "${::nut::common::conf_dir}/upssched.conf",
    }
  }
}
