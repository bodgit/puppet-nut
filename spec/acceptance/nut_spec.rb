require 'spec_helper_acceptance'

describe 'nut' do

  case fact('osfamily')
  when 'OpenBSD'
    conf_dir  = '/etc/nut'
    group     = '_ups'
    service   = 'upsd'
    state_dir = '/var/db/nut'
    user      = '_ups'
  when 'RedHat'
    conf_dir  = '/etc/ups'
    group     = 'nut'
    state_dir = '/var/run/nut'
    user      = 'nut'
    case fact('operatingsystemmajrelease')
    when '6'
      service = 'ups'
    else
      service = 'nut-server'
    end
  when 'Debian'
    conf_dir  = '/etc/nut'
    group     = 'nut'
    service   = 'nut-server'
    state_dir = '/var/run/nut'
    user      = 'nut'
  end

  it 'should work with no errors' do

    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          # $::architecture fact has gone missing on facter 3.x package currently installed
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/amd64/",
          default   => undef,
        },
      }

      include ::nut

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::nut']
      }

      ::nut::ups { 'dummy':
        driver => 'dummy-ups',
        port   => 'sua1000i.dev',
      }

      file { '#{conf_dir}/sua1000i.dev':
        ensure => file,
        owner  => 0,
        group  => 0,
        mode   => '0644',
        source => '/root/sua1000i.dev',
        before => ::Nut::Ups['dummy'],
      }

      ::nut::user { 'test':
        password => 'password',
        upsmon   => 'master',
      }

      ::nut::client::ups { 'dummy@localhost':
        user     => 'test',
        password => 'password',
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe file("#{conf_dir}/ups.conf") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
    its(:content) do
      is_expected.to eq <<-EOS.gsub(/^ +/, '')
        # !!! Managed by Puppet !!!

        [dummy]
        	driver = "dummy-ups"
        	port = "sua1000i.dev"
      EOS
    end
  end

  describe file("#{conf_dir}/upsd.users") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
    its(:content) do
      is_expected.to eq <<-EOS.gsub(/^ +/, '')
        # !!! Managed by Puppet !!!

        [test]
        	password = password
        	upsmon master
      EOS
    end
  end

  describe file(state_dir) do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 750 }
    it { is_expected.to be_owned_by user }
    it { is_expected.to be_grouped_into group }
  end

  describe service(service) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command('upsc dummy') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match /^ups\.model: Smart-UPS 1000$/ }
  end
end
