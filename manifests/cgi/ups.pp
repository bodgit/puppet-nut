#
define nut::cgi::ups (
  $description,
) {

  if ! defined(Class['::nut::cgi']) {
    fail('You must include the nut::cgi base class before using any nut::cgi defined resources') # lint:ignore:80chars
  }

  # ups@host(:port)
  validate_re($name, '^[^@]+@[^$:]+(:\d+)?$')
  validate_string($description)

  ::concat::fragment { "nut hosts ${name}":
    content => "MONITOR ${name} \"${description}\"\n",
    target  => "${::nut::cgi::conf_dir}/hosts.conf",
  }
}
