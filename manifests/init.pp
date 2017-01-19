# Installs Network UPS Tools (NUT).
#
# @example Declaring the class
#   include ::nut
#
# @example Listening on local subnet
#   class { '::nut':
#     listen => [
#       {
#         'address' => $::ipaddress_eth0,
#       },
#       {
#         'address' => $::ipaddress6_eth0,
#       },
#     ],
#   }
#
# @param certfile Path to OpenSSL TLS certificate and key.
# @param certident Tuple of certificate name and NSS database password.
# @param certpath Path to NSS certificate database.
# @param certrequest Client certificate authentication options for NSS.
# @param client_certident
# @param client_certpath
# @param client_certverify
# @param client_cmdscript
# @param client_deadtime
# @param client_finaldelay
# @param client_forcessl
# @param client_hostsync
# @param client_manage_package If the client is installed with the same
#   package then set this to `false`.
# @param client_manage_service If the client is started as part of the same
#   service as the server then set this to `false`.
# @param client_minsupplies
# @param client_nocommwarntime
# @param client_use_upssched
# @param client_notifycmd
# @param client_notifyflag
# @param client_notifymsg
# @param client_package_name
# @param client_pollfreq
# @param client_pollfreqalert
# @param client_rbwarntime
# @param client_service_name
# @param client_shutdowncmd
# @param conf_dir Top-level configuration directory, usually `/etc/nut` or
#   `/etc/ups`.
# @param driver_packages Hash of driver types to the package that provides it.
# @param group The unprivileged group used to drop root privileges.
# @param listen An array of hashes of interface addresses to listen on,
#   optionally with a port.
# @param maxage Timeout for UPS drivers.
# @param maxconn Maximum number of connections.
# @param package_name The name of the package.
# @param service_name Name of the service.
# @param statepath Top-level state directory, usually `/var/run/nut` or
#   `/var/db/nut`.
# @param user The unprivileged user used to drop root privileges.
#
# @see puppet_classes::nut::client ::nut::client
# @see puppet_defined_types::nut::ups ::nut::ups
# @see puppet_defined_types::nut::user ::nut::user
# @see puppet_defined_types::nut::client::ups ::nut::client::ups
# @see puppet_defined_types::nut::client::upssched ::nut::client::upssched
class nut (
  Optional[Stdlib::Absolutepath]                   $certfile              = undef,
  Optional[Tuple[String, String]]                  $certident             = undef,
  Optional[Stdlib::Absolutepath]                   $certpath              = undef,
  Optional[Enum['no', 'request', 'require']]       $certrequest           = undef,
  Optional[Tuple[String, String]]                  $client_certident      = undef,
  Optional[Stdlib::Absolutepath]                   $client_certpath       = undef,
  Optional[Boolean]                                $client_certverify     = undef,
  Optional[Stdlib::Absolutepath]                   $client_cmdscript      = undef,
  Optional[Integer[0]]                             $client_deadtime       = undef,
  Optional[Integer[0]]                             $client_finaldelay     = undef,
  Optional[Boolean]                                $client_forcessl       = undef,
  Optional[Integer[0]]                             $client_hostsync       = undef,
  Boolean                                          $client_manage_package = $::nut::params::client_manage_package,
  Boolean                                          $client_manage_service = $::nut::params::client_manage_service,
  Integer[1]                                       $client_minsupplies    = 1,
  Optional[Integer[0]]                             $client_nocommwarntime = undef,
  Boolean                                          $client_use_upssched   = false,
  Optional[Stdlib::Absolutepath]                   $client_notifycmd      = $client_use_upssched ? {
    true    => $::nut::params::upssched, # lint:ignore:parameter_order
    default => undef,
  },
  Optional[Hash[Nut::Event, Tuple[Boolean, 3, 3]]] $client_notifyflag     = undef,
  Optional[Hash[Nut::Event, String]]               $client_notifymsg      = undef,
  String                                           $client_package_name   = $::nut::params::client_package_name,
  Optional[Integer[0]]                             $client_pollfreq       = undef,
  Optional[Integer[0]]                             $client_pollfreqalert  = undef,
  Optional[Integer[0]]                             $client_rbwarntime     = undef,
  String                                           $client_service_name   = $::nut::params::client_service_name,
  String                                           $client_shutdowncmd    = $::nut::params::shutdown_command,
  Stdlib::Absolutepath                             $conf_dir              = $::nut::params::conf_dir,
  Hash[String, String]                             $driver_packages       = $::nut::params::driver_packages,
  String                                           $group                 = $::nut::params::group,
  Optional[Array[Nut::Listen, 1]]                  $listen                = undef,
  Optional[Integer[1]]                             $maxage                = undef,
  Optional[Integer[1]]                             $maxconn               = undef,
  String                                           $package_name          = $::nut::params::server_package_name,
  String                                           $service_name          = $::nut::params::server_service_name,
  Stdlib::Absolutepath                             $statepath             = $::nut::params::state_dir,
  String                                           $user                  = $::nut::params::user,
) inherits ::nut::params {

  contain ::nut::install
  contain ::nut::config
  contain ::nut::service

  class { '::nut::common':
    certident      => $client_certident,
    certpath       => $client_certpath,
    certverify     => $client_certverify,
    cmdscript      => $client_cmdscript,
    conf_dir       => $conf_dir,
    deadtime       => $client_deadtime,
    finaldelay     => $client_finaldelay,
    forcessl       => $client_forcessl,
    group          => $group,
    hostsync       => $client_hostsync,
    manage_package => $client_manage_package,
    manage_service => $client_manage_service,
    minsupplies    => $client_minsupplies,
    nocommwarntime => $client_nocommwarntime,
    notifycmd      => $client_notifycmd,
    notifyflag     => $client_notifyflag,
    notifymsg      => $client_notifymsg,
    package_name   => $client_package_name,
    pollfreq       => $client_pollfreq,
    pollfreqalert  => $client_pollfreqalert,
    rbwarntime     => $client_rbwarntime,
    service_name   => $client_service_name,
    shutdowncmd    => $client_shutdowncmd,
    state_dir      => $statepath,
    use_upssched   => $client_use_upssched,
    user           => $user,
  }

  Class['::nut::install'] -> Class['::nut::config'] ~> Class['::nut::service']

  if $client_manage_service {
    # If the client manages its own service then the client should depend on
    # the server being up
    Class['::nut::service'] -> Class['::nut::common']
  } else {
    # If the server service starts everything up then we need to have the
    # client configured before the service starts
    Class['::nut::config'] -> Class['::nut::common'] ~> Class['::nut::service']
  }
}
