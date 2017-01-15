# Add a UPS to visualise with the CGI scripts.
#
# @example Visualise a UPS
#   include ::nut::cgi
#   ::nut::cgi::ups { 'sua1000i@remotehost':
#     description => 'A remote UPS',
#   }
#
# @param description Description of the UPS.
# @param ups The UPS to visualise.
#
# @see puppet_classes::nut::cgi ::nut::cgi
define nut::cgi::ups (
  String      $description,
  Nut::Device $ups         = $title,
) {

  if ! defined(Class['::nut::cgi']) {
    fail('You must include the nut::cgi base class before using any nut::cgi defined resources')
  }

  ::concat::fragment { "nut hosts ${ups}":
    content => "MONITOR ${ups} \"${description}\"\n",
    target  => "${::nut::cgi::conf_dir}/hosts.conf",
  }
}
