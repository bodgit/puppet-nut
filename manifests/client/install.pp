#
class nut::client::install {

  ensure_packages([$::nut::client::package_name])

  case $::osfamily { # lint:ignore:case_without_default
    'RedHat': {
      include ::epel

      Class['::epel'] -> Package[$::nut::client::package_name]
    }
  }
}
