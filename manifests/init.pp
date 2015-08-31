#
class nut (
  $conf_dir        = $::nut::params::conf_dir,
  $driver_packages = $::nut::params::driver_packages,
  $group           = $::nut::params::group,
  $package_name    = $::nut::params::server_package_name,
  $service_name    = $::nut::params::server_service_name,
  $user            = $::nut::params::user,
) inherits ::nut::params {

  validate_absolute_path($conf_dir)
  validate_hash($driver_packages)
  validate_string($group)
  validate_string($package_name)
  validate_string($service_name)
  validate_string($user)

  include ::nut::install
  include ::nut::config
  include ::nut::service

  anchor { 'nut::begin': }
  anchor { 'nut::end': }

  Anchor['nut::begin'] -> Class['::nut::install'] ~> Class['::nut::config']
    ~> Class['::nut::service'] -> Anchor['nut::end']
}
