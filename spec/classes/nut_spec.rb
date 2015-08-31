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

      it { should contain_anchor('nut::begin') }
      it { should contain_anchor('nut::end') }
      it { should contain_class('nut') }
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
        it { should contain_package('nut') }
        it { should contain_service('upsd') }
      when 'RedHat'
        it { should contain_concat('/etc/ups/ups.conf') }
        it { should contain_concat('/etc/ups/upsd.users') }
        it { should contain_exec('udevadm trigger') }
        it { should contain_file('/etc/ups') }
        it { should contain_file('/etc/ups/upsd.conf') }
        it { should contain_package('nut') }
        it { should contain_service('nut-server') }
      end
    end
  end
end
