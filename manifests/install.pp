#
class nut::install {

  ensure_packages([$::nut::package_name])

  case $::osfamily { # lint:ignore:case_without_default
    'RedHat': {
      include ::epel

      Class['::epel'] -> Package[$::nut::package_name]
    }
  }
}
