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
# @see puppet_defined_types::nut::ups ::nut::ups
# @see puppet_defined_types::nut::user ::nut::user
class nut (
  Optional[Stdlib::Absolutepath]             $certfile        = undef,
  Optional[Tuple[String, String]]            $certident       = undef,
  Optional[Stdlib::Absolutepath]             $certpath        = undef,
  Optional[Enum['no', 'request', 'require']] $certrequest     = undef,
  Stdlib::Absolutepath                       $conf_dir        = $::nut::params::conf_dir,
  Hash[String, String]                       $driver_packages = $::nut::params::driver_packages,
  String                                     $group           = $::nut::params::group,
  Optional[Array[Nut::Listen, 1]]            $listen          = undef,
  Optional[Integer[1]]                       $maxage          = undef,
  Optional[Integer[1]]                       $maxconn         = undef,
  String                                     $package_name    = $::nut::params::server_package_name,
  String                                     $service_name    = $::nut::params::server_service_name,
  Stdlib::Absolutepath                       $statepath       = $::nut::params::state_dir,
  String                                     $user            = $::nut::params::user,
) inherits ::nut::params {

  contain ::nut::install
  contain ::nut::config
  contain ::nut::service

  Class['::nut::install'] -> Class['::nut::config'] ~> Class['::nut::service']
}
