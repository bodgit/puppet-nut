require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

hosts.each do |host|
  # Just assume the OpenBSD box has Puppet installed already
  if host['platform'] !~ /^openbsd-/i
    run_puppet_install_helper_on(host)
  end
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      puppet_module_install(:source => proj_root, :module_name => 'nut')
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'thrnio-ip'),         { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apache'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'stahnma-epel'),      { :acceptable_exit_codes => [0,1] }
      scp_to(host, File.join(proj_root, 'spec/fixtures/files/sua1000i.dev'), '/root/sua1000i.dev')
    end
  end
end
