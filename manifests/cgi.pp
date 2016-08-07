#
class nut::cgi (
  $conf_dir     = $::nut::params::cgi_conf_dir,
  $manage_vhost = $::nut::params::manage_vhost,
  $package_name = $::nut::params::cgi_package_name,
) inherits ::nut::params {

  validate_absolute_path($conf_dir)
  validate_bool($manage_vhost)
  validate_string($package_name)

  include ::nut::cgi::install
  include ::nut::cgi::config

  anchor { 'nut::cgi::begin': }
  anchor { 'nut::cgi::end': }

  Anchor['nut::cgi::begin'] -> Class['::nut::cgi::install']
    ~> Class['::nut::cgi::config'] -> Anchor['nut::cgi::end']
}
