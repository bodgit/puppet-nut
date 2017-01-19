require 'spec_helper'

describe 'nut::ups' do

  let(:pre_condition) do
    'include ::nut'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      context 'with a USB UPS', :compile do
        let(:title) do
          'sua1000i'
        end

        let(:params) do
          {
            'driver' => 'usbhid-ups',
            'port'   => 'auto',
          }
        end

        it { should contain_concat__fragment('nut ups sua1000i') }
        it { should contain_nut__ups('sua1000i') }
      end

      context 'with an SNMP UPS', :compile do
        let(:title) do
          'snmp-ups'
        end

        let(:params) do
          {
            'driver' => 'snmp-ups',
            'port'   => '192.0.2.1',
          }
        end

        it { should contain_concat__fragment('nut ups snmp-ups') }
        it { should contain_nut__ups('snmp-ups') }

        case facts[:osfamily]
        when 'OpenBSD'
          it { should contain_package('nut-snmp') }
        when 'Debian'
          it { should contain_package('nut-snmp') }
        end
      end
    end
  end
end
