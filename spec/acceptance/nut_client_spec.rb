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
    state_dir = '/var/run/nut'
    user      = 'nut'
    service = case fact('operatingsystemmajrelease')
              when '6'
                'ups'
              else
                'nut-monitor'
              end
  when 'Debian'
    conf_dir  = '/etc/nut'
    group     = 'nut'
    state_dir = '/var/run/nut'
    user      = 'nut'
    service = case fact('operatingsystem')
              when 'Ubuntu'
                'nut-client'
              else
                case fact('operatingsystemmajrelease')
                when '7'
                  'nut-client'
                else
                  'nut-monitor'
                end
              end
  end

  it 'works with no errors' do
    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          # $::architecture fact has gone missing on facter 3.x package currently installed
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/amd64/",
          default   => undef,
        },
      }

      class { '::nut::client':
        use_upssched => true,
      }

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::nut::client']
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
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes:  true)
  end

  describe file("#{conf_dir}/upsmon.conf") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
    its(:content) { is_expected.to match %r{^MONITOR dummy@localhost 1 test password master$} }
  end

  describe file("#{conf_dir}/upssched.conf") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
    its(:content) { is_expected.to match %r{^PIPEFN #{state_dir}\/upssched\/upssched\.pipe$} }
    its(:content) { is_expected.to match %r{^LOCKFN #{state_dir}\/upssched\/upssched\.lock$} }
    its(:content) { is_expected.to match %r{^AT COMMBAD \* START-TIMER upsgone 10$} }
    its(:content) { is_expected.to match %r{^AT COMMOK dummy@localhost CANCEL-TIMER upsgone$} }
  end

  describe file("#{state_dir}/upssched") do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 750 }
    it { is_expected.to be_owned_by user }
    it { is_expected.to be_grouped_into group }
  end

  describe service(service) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
