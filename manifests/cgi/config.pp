# @!visibility private
class nut::cgi::config {

  $conf_dir = $::nut::cgi::conf_dir
  $group    = $::nut::cgi::group
  $user     = $::nut::cgi::user

  ensure_resource('group', $group, {
    ensure => present,
    system => true,
  })

  ensure_resource('user', $user, {
    ensure => present,
    gid    => $group,
    system => true,
  })

  ensure_resource('file', $conf_dir, {
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  })

  ::concat { "${conf_dir}/hosts.conf":
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => "# !!! Managed by Puppet !!!\n\n",
  }

  file { "${conf_dir}/upsset.conf":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => file('nut/upsset.conf'),
  }

  if $::nut::cgi::manage_vhost {
    case $::nut::cgi::http_server {
      'apache': {
        $::nut::cgi::apache_resources.each |$type,$resources| {
          $resources.each |$instance,$attributes| { # lint:ignore:variable_scope
            Resource[$type] { # lint:ignore:variable_scope
              $instance: * => $attributes;
            }
          }
        }
      }
      'httpd': {
        # TODO
      }
      default: {
        # noop
      }
    }
  }
}
