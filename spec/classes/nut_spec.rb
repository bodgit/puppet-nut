require 'spec_helper'

describe 'nut' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_class('nut') }
      it { should contain_class('nut::common') }
      it { should contain_class('nut::common::config') }
      it { should contain_class('nut::common::install') }
      it { should contain_class('nut::common::service') }
      it { should contain_class('nut::config') }
      it { should contain_class('nut::install') }
      it { should contain_class('nut::params') }
      it { should contain_class('nut::service') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { should contain_concat('/etc/nut/ups.conf') }
        it { should contain_concat('/etc/nut/upsd.users') }
        it { should contain_file('/etc/nut') }
        it { should contain_file('/etc/nut/upsd.conf') }
        it { should contain_file('/etc/nut/upssched.conf') }
        it { should contain_file('/var/db/nut') }
        it { should contain_group('_ups') }
        it { should contain_package('nut') }
        it { should contain_service('upsd') }
        it { should contain_user('_ups') }
      when 'RedHat'
        it { should contain_concat('/etc/ups/ups.conf') }
        it { should contain_concat('/etc/ups/upsd.users') }
        it { should contain_exec('udevadm trigger') }
        it { should contain_file('/etc/ups') }
        it { should contain_file('/etc/ups/upsd.conf') }
        it { should contain_file('/etc/ups/upssched.conf') }
        it { should contain_file('/var/run/nut') }
        it { should contain_group('nut') }
        it { should contain_package('nut') }
        it { should contain_user('nut') }

        case facts[:operatingsystemmajrelease]
        when '6'
          it {
            should contain_file('/etc/sysconfig/ups').with_content(<<-EOS.gsub(/^ {14}/, ''))
              # !!! Managed by Puppet !!!

              SERVER=yes
              UPSD_OPTIONS=
              POWERDOWNFLAG=/etc/ups/killpower
            EOS
          }
          it { should contain_service('ups') }
        else
          it { should_not contain_file('/etc/sysconfig/ups') }
          it { should contain_service('nut-server') }
        end
      when 'Debian'
        it { should contain_concat('/etc/nut/ups.conf') }
        it { should contain_concat('/etc/nut/upsd.users') }
        it { should contain_file('/etc/nut') }
        it {
          should contain_file('/etc/nut/nut.conf').with_content(<<-EOS.gsub(/^ {12}/, ''))
            # !!! Managed by Puppet !!!

            MODE=netserver
          EOS
        }
        it { should contain_file('/etc/nut/upsd.conf') }
        it { should contain_file('/etc/nut/upssched.conf') }
        it { should contain_file('/var/run/nut') }
        it { should contain_group('nut') }
        it { should contain_package('nut-server') }
        it { should contain_service('nut-server') }
        it { should contain_user('nut') }
      end
    end
  end
end
