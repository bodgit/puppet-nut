# Installs the Network UPS Tools (NUT) client.
#
# @example Declaring the class
#   include ::nut::client
#
# @example Using `upssched` for notifications
#   class { '::nut::client':
#     use_upssched => true,
#   }
#
# @param certident Tuple of certificate name and NSS database password.
# @param certpath Path to NSS certificate database.
# @param certverify Verify any TLS connections.
# @param cmdscript The script invoked by `upssched` when a timer expires.
# @param conf_dir Top-level configuration directory, usually `/etc/nut` or
#   `/etc/ups`.
# @param deadtime How long a UPS can go without reporting anything before
#   being declared dead.
# @param finaldelay How long to wait after warning users before shutting the
#   host down.
# @param forcessl Always use TLS connections.
# @param group The unprivileged group used to drop root privileges.
# @param hostsync Wait this long for slave hosts to disconnect in a shutdown
#   situation.
# @param minsupplies The number of power supplies receiving power for the host
#   to remain powered on.
# @param nocommwarntime How oftern to warn when no configured UPS is reachable.
# @param notifycmd The command to invoke for UPS events.
# @param notifyflag Hash of UPS event to tuple of three booleans representing
#   using Syslog, `wall(1)` and `$notifycmd` for notifications.
# @param notifymsg Hash of UPS event to string for overriding the message for
#   that event.
# @param package_name The name of the package.
# @param pollfreq How often to poll a UPS.
# @param pollfreqalert How often to poll a UPS running on battery.
# @param rbwarntime How often to warn a UPS needs a replacement battery.
# @param service_name The name of the service.
# @param shutdowncmd The command used to power the host off.
# @param state_dir Top-level state directory, usually `/var/run/nut` or
#   `/var/db/nut`.
# @param use_upssched Whether to use `upssched` for notifications or not.
# @param user The unprivileged user used to drop root privileges.
#
# @see puppet_classes::nut ::nut
# @see puppet_defined_types::nut::client::ups ::nut::client::ups
# @see puppet_defined_types::nut::client::upssched ::nut::client::upssched
class nut::client (
  Optional[Tuple[String, String]]                  $certident      = undef,
  Optional[Stdlib::Absolutepath]                   $certpath       = undef,
  Optional[Boolean]                                $certverify     = undef,
  Optional[Stdlib::Absolutepath]                   $cmdscript      = undef,
  Stdlib::Absolutepath                             $conf_dir       = $::nut::params::conf_dir,
  Optional[Integer[0]]                             $deadtime       = undef,
  Optional[Integer[0]]                             $finaldelay     = undef,
  Optional[Boolean]                                $forcessl       = undef,
  String                                           $group          = $::nut::params::group,
  Optional[Integer[0]]                             $hostsync       = undef,
  Integer[1]                                       $minsupplies    = 1,
  Optional[Integer[0]]                             $nocommwarntime = undef,
  Boolean                                          $use_upssched   = false,
  Optional[Stdlib::Absolutepath]                   $notifycmd      = $use_upssched ? {
    true    => $::nut::params::upssched, # lint:ignore:parameter_order
    default => undef,
  },
  Optional[Hash[Nut::Event, Tuple[Boolean, 3, 3]]] $notifyflag     = undef,
  Optional[Hash[Nut::Event, String]]               $notifymsg      = undef,
  String                                           $package_name   = $::nut::params::client_package_name,
  Optional[Integer[0]]                             $pollfreq       = undef,
  Optional[Integer[0]]                             $pollfreqalert  = undef,
  Optional[Integer[0]]                             $rbwarntime     = undef,
  String                                           $service_name   = $::nut::params::client_service_name,
  String                                           $shutdowncmd    = $::nut::params::shutdown_command,
  Stdlib::Absolutepath                             $state_dir      = $::nut::params::state_dir,
  String                                           $user           = $::nut::params::user,
) inherits ::nut::params {

  contain ::nut::client::install
  contain ::nut::client::config
  contain ::nut::client::service

  Class['::nut::client::install'] -> Class['::nut::client::config']
    ~> Class['::nut::client::service']
}
