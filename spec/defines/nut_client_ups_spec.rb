require 'spec_helper'

describe 'nut::client::ups' do

  let(:pre_condition) do
    'include ::nut::client'
  end

  let(:title) do
    'sua1000i@localhost'
  end

  let(:params) do
    {
      'user'     => 'test',
      'password' => 'password',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { is_expected.to contain_class('nut::client') }
      it { is_expected.to contain_concat__fragment('nut upsmon sua1000i@localhost') }
      it { is_expected.to contain_nut__client__ups('sua1000i@localhost') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { is_expected.to contain_file('/etc/nut/upssched.conf') }
      when 'RedHat'
        it { is_expected.to contain_file('/etc/ups/upssched.conf') }
      end
    end
  end
end
