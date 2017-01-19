# @!visibility private
class nut::common::install {

  if $::nut::common::manage_package {
    package { $::nut::common::package_name:
      ensure => present,
    }
  }
}
