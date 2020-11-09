require 'beaker/module_install_helper'

install_module_from_forge_on(hosts, 'puppet/epel', '>=3.0.0 <4.0.0')

hosts.each do |host|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  scp_to(host, File.join(proj_root, 'spec/fixtures/files/sua1000i.dev'), '/root/sua1000i.dev')
end
