require 'spec_helper'

describe 'nut::cgi' do

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

      it { should contain_class('nut::cgi') }
      it { should contain_class('nut::cgi::config') }
      it { should contain_class('nut::cgi::install') }
      it { should contain_class('nut::params') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { should contain_concat('/var/www/conf/nut/hosts.conf') }
        it { should contain_file('/var/www/conf/nut/upsset.conf') }
        it { should contain_group('_ups') }
        it { should contain_package('nut-cgi') }
        it { should contain_user('_ups') }
      when 'RedHat'
        let(:pre_condition) do
          'include ::apache'
        end

        it { should contain_apache__vhost('nut') }
        it { should contain_concat('/etc/ups/hosts.conf') }
        it { should contain_file('/etc/ups/upsset.conf') }
        it { should contain_group('nut') }
        it { should contain_package('nut-cgi') }
        it { should contain_user('nut') }
      end
    end
  end
end
