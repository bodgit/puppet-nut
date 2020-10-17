require 'spec_helper'

describe 'nut' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { is_expected.to compile.and_raise_error(%r{not supported on Unsupported}) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('nut') }
      it { is_expected.to contain_class('nut::common') }
      it { is_expected.to contain_class('nut::common::config') }
      it { is_expected.to contain_class('nut::common::install') }
      it { is_expected.to contain_class('nut::common::service') }
      it { is_expected.to contain_class('nut::config') }
      it { is_expected.to contain_class('nut::install') }
      it { is_expected.to contain_class('nut::params') }
      it { is_expected.to contain_class('nut::service') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { is_expected.to contain_concat('/etc/nut/ups.conf') }
        it { is_expected.to contain_concat('/etc/nut/upsd.users') }
        it { is_expected.to contain_file('/etc/nut') }
        it { is_expected.to contain_file('/etc/nut/upsd.conf') }
        it { is_expected.to contain_file('/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/db/nut') }
        it { is_expected.to contain_group('_ups') }
        it { is_expected.to contain_package('nut') }
        it { is_expected.to contain_service('upsd') }
        it { is_expected.to contain_user('_ups') }
      when 'RedHat'
        it { is_expected.to contain_concat('/etc/ups/ups.conf') }
        it { is_expected.to contain_concat('/etc/ups/upsd.users') }
        it { is_expected.to contain_exec('udevadm trigger') }
        it { is_expected.to contain_file('/etc/ups') }
        it { is_expected.to contain_file('/etc/ups/upsd.conf') }
        it { is_expected.to contain_file('/etc/ups/upssched.conf') }
        it { is_expected.to contain_file('/var/run/nut') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut') }
        it { is_expected.to contain_user('nut') }

        case facts[:operatingsystemmajrelease]
        when '6'
          it {
            is_expected.to contain_file('/etc/sysconfig/ups').with_content(<<-EOS.gsub(/^ {14}/, ''))
              # !!! Managed by Puppet !!!

              SERVER=yes
              UPSD_OPTIONS=
              POWERDOWNFLAG=/etc/ups/killpower
            EOS
          }
          it { is_expected.to contain_service('ups') }
        else
          it { is_expected.not_to contain_file('/etc/sysconfig/ups') }
          it { is_expected.to contain_service('nut-server') }
        end
      when 'Debian'
        it { is_expected.to contain_concat('/etc/nut/ups.conf') }
        it { is_expected.to contain_concat('/etc/nut/upsd.users') }
        it { is_expected.to contain_file('/etc/nut') }
        it {
          is_expected.to contain_file('/etc/nut/nut.conf').with_content(<<-EOS.gsub(/^ {12}/, ''))
            # !!! Managed by Puppet !!!

            MODE=netserver
          EOS
        }
        it { is_expected.to contain_file('/etc/nut/upsd.conf') }
        it { is_expected.to contain_file('/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/run/nut') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut-server') }
        it { is_expected.to contain_service('nut-server') }
        it { is_expected.to contain_user('nut') }
      when 'FreeBSD'
        it { is_expected.to contain_concat('/usr/local/etc/nut/ups.conf') }
        it { is_expected.to contain_concat('/usr/local/etc/nut/upsd.users') }
        it { is_expected.to contain_file('/usr/local/etc/nut') }
        it { is_expected.to contain_file('/usr/local/etc/nut/upsd.conf') }
        it { is_expected.to contain_file('/usr/local/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/db/nut') }
        it { is_expected.to contain_group('uucp') }
        it { is_expected.to contain_package('nut') }
        it { is_expected.to contain_service('nut') }
        it { is_expected.to contain_user('uucp') }
      end
    end
  end
end
