# Installs the Network UPS Tools (NUT) CGI scripts.
#
# @example Declaring the class
#   include ::nut::cgi
#
# @example Managing the virtual host configuration elsewhere
#   class { '::nut::cgi':
#     manage_vhost => false,
#   }
#
# @param apache_resources Hash of Apache resources to create that configures
#   the virtual host serving the CGI scripts.
# @param conf_dir Top-level configuration directory, usually
#   `/var/www/conf/nut` or `/etc/ups`.
# @param group The unprivileged group used to drop root privileges.
# @param http_server Which HTTP server to configure a virtual host for.
# @param manage_vhost Whether to create a virtual host for the CGI scripts or
#   not.
# @param package_name The name of the package.
# @param user The unprivileged user used to drop root privileges.
#
# @see puppet_classes::nut ::nut
# @see puppet_defined_types::nut::cgi::ups ::nut::cgi::ups
class nut::cgi (
  Hash                    $apache_resources = $::nut::params::apache_resources,
  Stdlib::Absolutepath    $conf_dir         = $::nut::params::cgi_conf_dir,
  String                  $group            = $::nut::params::group,
  Enum['apache', 'httpd'] $http_server      = $::nut::params::http_server,
  Boolean                 $manage_vhost     = $::nut::params::manage_vhost,
  String                  $package_name     = $::nut::params::cgi_package_name,
  String                  $user             = $::nut::params::user,
) inherits ::nut::params {

  contain ::nut::cgi::install
  contain ::nut::cgi::config

  Class['::nut::cgi::install'] -> Class['::nut::cgi::config']
}
