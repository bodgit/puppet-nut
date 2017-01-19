# @!visibility private
class nut::install {

  package { $::nut::package_name:
    ensure => present,
  }
}
