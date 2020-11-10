require 'spec_helper'

describe 'nut::client' do
  let(:params) do
    {
      'notifyflag'   => {
        'online'   => [false, false, false],
        'onbatt'   => [true,  false, false],
        'lowbatt'  => [false, true,  false],
        'fsd'      => [true,  true,  false],
        'commok'   => [false, false, true],
        'commbad'  => [true,  false, true],
        'shutdown' => [false, true,  true],
        'replbatt' => [true,  true,  true],
      },
      'use_upssched' => true,
    }
  end

  context 'on unsupported distributions' do
    let(:facts) do
      {
        os: {
          family: 'Unsupported',
        },
      }
    end

    it { is_expected.to compile.and_raise_error(%r{not supported on Unsupported}) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('nut::client') }
      it { is_expected.to contain_class('nut::client::config') }
      it { is_expected.to contain_class('nut::common') }
      it { is_expected.to contain_class('nut::common::config') }
      it { is_expected.to contain_class('nut::common::install') }
      it { is_expected.to contain_class('nut::common::service') }
      it { is_expected.to contain_class('nut::params') }
      it { is_expected.to contain_concat__fragment('nut upssched header') }

      # rubocop:disable RepeatedExample

      case facts[:osfamily]
      when 'OpenBSD'
        it { is_expected.to contain_concat('/etc/nut/upsmon.conf') }
        it { is_expected.to contain_concat('/etc/nut/upssched.conf') }
        it {
          is_expected.to contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(%r{^ {12}}, ''))
            RUN_AS_USER _ups
            MINSUPPLIES 1
            SHUTDOWNCMD "/sbin/shutdown -h +0"
            POWERDOWNFLAG /etc/nut/killpower
            NOTIFYCMD "/usr/local/sbin/upssched"
            NOTIFYFLAG ONLINE IGNORE
            NOTIFYFLAG ONBATT SYSLOG
            NOTIFYFLAG LOWBATT WALL
            NOTIFYFLAG FSD SYSLOG+WALL
            NOTIFYFLAG COMMOK EXEC
            NOTIFYFLAG COMMBAD SYSLOG+EXEC
            NOTIFYFLAG SHUTDOWN WALL+EXEC
            NOTIFYFLAG REPLBATT SYSLOG+WALL+EXEC
          EOS
        }
        it { is_expected.to contain_file('/etc/nut') }
        it { is_expected.not_to contain_file('/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/db/nut') }
        it { is_expected.to contain_file('/var/db/nut/upssched') }
        it { is_expected.to contain_group('_ups') }
        it { is_expected.to contain_package('nut') }
        it { is_expected.to contain_service('upsmon') }
        it { is_expected.to contain_user('_ups') }
      when 'RedHat'
        it { is_expected.to contain_concat('/etc/ups/upsmon.conf') }
        it { is_expected.to contain_concat('/etc/ups/upssched.conf') }
        it {
          is_expected.to contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(%r{^ {12}}, ''))
            RUN_AS_USER nut
            MINSUPPLIES 1
            SHUTDOWNCMD "/sbin/shutdown -h +0"
            POWERDOWNFLAG /etc/ups/killpower
            NOTIFYCMD "/usr/sbin/upssched"
            NOTIFYFLAG ONLINE IGNORE
            NOTIFYFLAG ONBATT SYSLOG
            NOTIFYFLAG LOWBATT WALL
            NOTIFYFLAG FSD SYSLOG+WALL
            NOTIFYFLAG COMMOK EXEC
            NOTIFYFLAG COMMBAD SYSLOG+EXEC
            NOTIFYFLAG SHUTDOWN WALL+EXEC
            NOTIFYFLAG REPLBATT SYSLOG+WALL+EXEC
          EOS
        }
        it { is_expected.to contain_file('/etc/ups') }
        it { is_expected.not_to contain_file('/etc/ups/upssched.conf') }
        it { is_expected.to contain_file('/var/run/nut') }
        it { is_expected.to contain_file('/var/run/nut/upssched') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut-client') }
        it { is_expected.to contain_user('nut') }

        case facts[:operatingsystemmajrelease]
        when '6'
          it {
            is_expected.to contain_file('/etc/sysconfig/ups').with_content(<<-EOS.gsub(%r{^ {14}}, ''))
              # !!! Managed by Puppet !!!

              SERVER=no
              UPSD_OPTIONS=
              POWERDOWNFLAG=/etc/ups/killpower
            EOS
          }
          it { is_expected.to contain_service('ups') }
        else
          it { is_expected.not_to contain_file('/etc/sysconfig/ups') }
          it { is_expected.to contain_service('nut-monitor') }
        end
      when 'Debian'
        it { is_expected.to contain_concat('/etc/nut/upsmon.conf') }
        it { is_expected.to contain_concat('/etc/nut/upssched.conf') }
        it {
          is_expected.to contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(%r{^ {12}}, ''))
            RUN_AS_USER nut
            MINSUPPLIES 1
            SHUTDOWNCMD "/sbin/shutdown -h +0"
            POWERDOWNFLAG /etc/nut/killpower
            NOTIFYCMD "/sbin/upssched"
            NOTIFYFLAG ONLINE IGNORE
            NOTIFYFLAG ONBATT SYSLOG
            NOTIFYFLAG LOWBATT WALL
            NOTIFYFLAG FSD SYSLOG+WALL
            NOTIFYFLAG COMMOK EXEC
            NOTIFYFLAG COMMBAD SYSLOG+EXEC
            NOTIFYFLAG SHUTDOWN WALL+EXEC
            NOTIFYFLAG REPLBATT SYSLOG+WALL+EXEC
          EOS
        }
        it { is_expected.to contain_file('/etc/nut') }
        it {
          is_expected.to contain_file('/etc/nut/nut.conf').with_content(<<-EOS.gsub(%r{^ {12}}, ''))
            # !!! Managed by Puppet !!!

            MODE=netclient
          EOS
        }
        it { is_expected.not_to contain_file('/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/run/nut') }
        it { is_expected.to contain_file('/var/run/nut/upssched') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut-client') }
        it { is_expected.to contain_user('nut') }
        case facts[:operatingsystem]
        when 'Ubuntu'
          it { is_expected.to contain_service('nut-client') }
        else
          case facts[:operatingsystemmajrelease]
          when '7'
            it { is_expected.to contain_service('nut-client') }
          else
            it { is_expected.to contain_service('nut-monitor') }
          end
        end
      when 'FreeBSD'
        it { is_expected.to contain_concat('/usr/local/etc/nut/upsmon.conf') }
        it { is_expected.to contain_concat('/usr/local/etc/nut/upssched.conf') }
        it {
          is_expected.to contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(%r{^ {12}}, ''))
            RUN_AS_USER uucp
            MINSUPPLIES 1
            SHUTDOWNCMD "/sbin/shutdown -h +0"
            POWERDOWNFLAG /usr/local/etc/nut/killpower
            NOTIFYCMD "/usr/local/sbin/upssched"
            NOTIFYFLAG ONLINE IGNORE
            NOTIFYFLAG ONBATT SYSLOG
            NOTIFYFLAG LOWBATT WALL
            NOTIFYFLAG FSD SYSLOG+WALL
            NOTIFYFLAG COMMOK EXEC
            NOTIFYFLAG COMMBAD SYSLOG+EXEC
            NOTIFYFLAG SHUTDOWN WALL+EXEC
            NOTIFYFLAG REPLBATT SYSLOG+WALL+EXEC
          EOS
        }
        it { is_expected.to contain_file('/usr/local/etc/nut') }
        it { is_expected.not_to contain_file('/usr/local/etc/nut/upssched.conf') }
        it { is_expected.to contain_file('/var/db/nut') }
        it { is_expected.to contain_file('/var/db/nut/upssched') }
        it { is_expected.to contain_group('uucp') }
        it { is_expected.to contain_package('nut') }
        it { is_expected.to contain_service('nut_upsmon') }
        it { is_expected.to contain_user('uucp') }
      end
    end
  end
end
