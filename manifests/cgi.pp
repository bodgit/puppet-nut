#
class nut::cgi (
  $package_name = $::nut::params::cgi_package_name,
) inherits ::nut::params {

  validate_string($package_name)

  include ::nut::cgi::install

  anchor { 'nut::cgi::begin': }
  anchor { 'nut::cgi::end': }

  Anchor['nut::cgi::begin'] -> Class['::nut::cgi::install']
    -> Anchor['nut::cgi::end']
}
