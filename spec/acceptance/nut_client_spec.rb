require 'spec_helper_acceptance'

describe 'nut::client' do

  case fact('osfamily')
  when 'OpenBSD'
    conf_dir = '/etc/nut'
    group    = 'wheel'
    mode     = 600
    owner    = '_ups'
    service  = 'upsmon'
  when 'RedHat'
    conf_dir = '/etc/ups'
    group    = 'nut'
    mode     = 640
    owner    = 'root'
    service  = 'nut-monitor'
  end

  it 'should work with no errors' do

    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/${::architecture}/",
          default   => undef,
        },
      }

      include ::nut

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

      include ::nut::client

      ::nut::client::ups { 'dummy@localhost':
        user     => 'test',
        password => 'password',
      }

      Class['::nut'] ~> Class['::nut::client']
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe file("#{conf_dir}/upsmon.conf") do
    it { should be_file }
    it { should be_mode mode }
    it { should be_owned_by owner }
    it { should be_grouped_into group }
    its(:content) { should match /^MONITOR dummy@localhost 1 test password master$/ }
  end

  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end
