#
class nut::client (
  $conf_dir         = $::nut::params::conf_dir,
  $group            = $::nut::params::group,
  $minimum_supplies = 1,
  $package_name     = $::nut::params::client_package_name,
  $service_name     = $::nut::params::client_service_name,
  $shutdown_command = $::nut::params::shutdown_command,
  $user             = $::nut::params::user,
) inherits ::nut::params {

  validate_absolute_path($conf_dir)
  validate_string($package_name)
  validate_string($service_name)

  include ::nut::client::install
  include ::nut::client::config
  include ::nut::client::service

  anchor { 'nut::client::begin': }
  anchor { 'nut::client::end': }

  Anchor['nut::client::begin'] -> Class['::nut::client::install']
    ~> Class['::nut::client::config'] ~> Class['::nut::client::service']
    -> Anchor['nut::client::end']
}
