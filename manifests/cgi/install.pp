#
class nut::cgi::install {

  package { $::nut::cgi::package_name:
    ensure => present,
  }
}
