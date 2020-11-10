require 'spec_helper'

describe 'nut::ups' do
  let(:pre_condition) do
    'include ::nut'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with a USB UPS' do
        let(:title) do
          'sua1000i'
        end

        let(:params) do
          {
            'driver' => 'usbhid-ups',
            'port'   => 'auto',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_concat__fragment('nut ups sua1000i') }
        it { is_expected.to contain_nut__ups('sua1000i') }
      end

      context 'with an SNMP UPS' do
        let(:title) do
          'snmp-ups'
        end

        let(:params) do
          {
            'driver' => 'snmp-ups',
            'port'   => '192.0.2.1',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_concat__fragment('nut ups snmp-ups') }
        it { is_expected.to contain_nut__ups('snmp-ups') }

        # rubocop:disable RepeatedExample

        case facts[:osfamily]
        when 'OpenBSD'
          it { is_expected.to contain_package('nut-snmp') }
        when 'Debian'
          it { is_expected.to contain_package('nut-snmp') }
        end
      end
    end
  end
end
