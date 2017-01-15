require 'spec_helper_acceptance'

describe 'nut::client' do

  case fact('osfamily')
  when 'OpenBSD'
    conf_dir  = '/etc/nut'
    group     = '_ups'
    service   = 'upsmon'
    state_dir = '/var/db/nut'
    user      = '_ups'
  when 'RedHat'
    conf_dir  = '/etc/ups'
    group     = 'nut'
    service   = 'nut-monitor'
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

      class { '::nut::client':
        use_upssched => true,
      }

      ::nut::client::ups { 'dummy@localhost':
        user     => 'test',
        password => 'password',
      }

      ::nut::client::upssched { 'commbad':
        notifytype => 'commbad',
        ups        => '*',
        command    => 'start-timer',
        args       => [
          'upsgone',
          10,
        ],
      }

      ::nut::client::upssched { 'commok':
        notifytype => 'commok',
        ups        => 'dummy@localhost',
        command    => 'cancel-timer',
        args       => [
          'upsgone',
        ],
      }

      Class['::nut'] ~> Class['::nut::client']
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe file("#{conf_dir}/upsmon.conf") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
    its(:content) { should match /^MONITOR dummy@localhost 1 test password master$/ }
  end

  describe file("#{conf_dir}/upssched.conf") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
    its(:content) { should match /^PIPEFN #{state_dir}\/upssched\/upssched\.pipe$/ }
    its(:content) { should match /^LOCKFN #{state_dir}\/upssched\/upssched\.lock$/ }
    its(:content) { should match /^AT COMMBAD \* START-TIMER upsgone 10$/ }
    its(:content) { should match /^AT COMMOK dummy@localhost CANCEL-TIMER upsgone$/ }
  end

  describe file("#{state_dir}/upssched") do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by user }
    it { should be_grouped_into group }
  end

  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end
