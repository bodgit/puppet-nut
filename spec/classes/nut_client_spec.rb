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

      it { should contain_class('nut::client') }
      it { should contain_class('nut::client::config') }
      it { should contain_class('nut::common') }
      it { should contain_class('nut::common::config') }
      it { should contain_class('nut::common::install') }
      it { should contain_class('nut::common::service') }
      it { should contain_class('nut::params') }
      it { should contain_concat__fragment('nut upssched header') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { should contain_concat('/etc/nut/upsmon.conf') }
        it { should contain_concat('/etc/nut/upssched.conf') }
        it {
          should contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(/^ {12}/, ''))
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
        it { should contain_file('/etc/nut') }
        it { should_not contain_file('/etc/nut/upssched.conf') }
        it { should contain_file('/var/db/nut') }
        it { should contain_file('/var/db/nut/upssched') }
        it { should contain_group('_ups') }
        it { should contain_package('nut') }
        it { should contain_service('upsmon') }
        it { should contain_user('_ups') }
      when 'RedHat'
        it { should contain_concat('/etc/ups/upsmon.conf') }
        it { should contain_concat('/etc/ups/upssched.conf') }
        it {
          should contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(/^ {12}/, ''))
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
        it { should contain_file('/etc/ups') }
        it { should_not contain_file('/etc/ups/upssched.conf') }
        it { should contain_file('/var/run/nut') }
        it { should contain_file('/var/run/nut/upssched') }
        it { should contain_group('nut') }
        it { should contain_package('nut-client') }
        it { should contain_user('nut') }

        case facts[:operatingsystemmajrelease]
        when '6'
          it {
            should contain_file('/etc/sysconfig/ups').with_content(<<-EOS.gsub(/^ {14}/, ''))
              # !!! Managed by Puppet !!!

              SERVER=no
              UPSD_OPTIONS=
              POWERDOWNFLAG=/etc/ups/killpower
            EOS
          }
          it { should contain_service('ups') }
        else
          it { should_not contain_file('/etc/sysconfig/ups') }
          it { should contain_service('nut-monitor') }
        end
      when 'Debian'
        it { should contain_concat('/etc/nut/upsmon.conf') }
        it { should contain_concat('/etc/nut/upssched.conf') }
        it {
          should contain_concat__fragment('nut upsmon header').with_content(<<-EOS.gsub(/^ {12}/, ''))
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
        it { should contain_file('/etc/nut') }
        it {
          should contain_file('/etc/nut/nut.conf').with_content(<<-EOS.gsub(/^ {12}/, ''))
            # !!! Managed by Puppet !!!

            MODE=netclient
          EOS
        }
        it { should_not contain_file('/etc/nut/upssched.conf') }
        it { should contain_file('/var/run/nut') }
        it { should contain_file('/var/run/nut/upssched') }
        it { should contain_group('nut') }
        it { should contain_package('nut-client') }
        it { should contain_service('nut-client') }
        it { should contain_user('nut') }
      end
    end
  end
end
