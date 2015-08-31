require 'spec_helper'

describe 'nut::client' do

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

      it { should contain_anchor('nut::client::begin') }
      it { should contain_anchor('nut::client::end') }
      it { should contain_class('nut::client') }
      it { should contain_class('nut::client::config') }
      it { should contain_class('nut::client::install') }
      it { should contain_class('nut::client::service') }
      it { should contain_class('nut::params') }
      it { should contain_concat__fragment('nut upsmon header') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { should contain_concat('/etc/nut/upsmon.conf') }
        it { should contain_file('/etc/nut') }
        it { should contain_package('nut') }
        it { should contain_service('upsmon') }
      when 'RedHat'
        it { should contain_concat('/etc/ups/upsmon.conf') }
        it { should contain_file('/etc/ups') }
        it { should contain_package('nut-client') }
        it { should contain_service('nut-monitor') }
      end
    end
  end
end
