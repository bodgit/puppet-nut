require 'spec_helper'

describe 'nut::cgi' do
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
    # rubocop:disable EmptyExampleGroup

    context "on #{os}" do
      let(:facts) do
        facts
      end

      # rubocop:disable RepeatedExample

      case facts[:osfamily]
      when 'OpenBSD'
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('nut::cgi') }
        it { is_expected.to contain_class('nut::cgi::config') }
        it { is_expected.to contain_class('nut::cgi::install') }
        it { is_expected.to contain_class('nut::params') }
        it { is_expected.to contain_concat('/var/www/conf/nut/hosts.conf') }
        it { is_expected.to contain_file('/var/www/conf/nut') }
        it { is_expected.to contain_file('/var/www/conf/nut/upsset.conf') }
        it { is_expected.to contain_group('_ups') }
        it { is_expected.to contain_package('nut-cgi') }
        it { is_expected.to contain_user('_ups') }
      when 'RedHat'
        let(:pre_condition) do
          'include ::apache'
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_apache__vhost('nut') }
        it { is_expected.to contain_class('nut::cgi') }
        it { is_expected.to contain_class('nut::cgi::config') }
        it { is_expected.to contain_class('nut::cgi::install') }
        it { is_expected.to contain_class('nut::params') }
        it { is_expected.to contain_concat('/etc/ups/hosts.conf') }
        it { is_expected.to contain_file('/etc/ups/upsset.conf') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut-cgi') }
        it { is_expected.to contain_user('nut') }
      when 'Debian'
        let(:pre_condition) do
          'include ::apache'
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_apache__vhost('nut') }
        it { is_expected.to contain_class('nut::cgi') }
        it { is_expected.to contain_class('nut::cgi::config') }
        it { is_expected.to contain_class('nut::cgi::install') }
        it { is_expected.to contain_class('nut::params') }
        it { is_expected.to contain_concat('/etc/nut/hosts.conf') }
        it { is_expected.to contain_file('/etc/nut/upsset.conf') }
        it { is_expected.to contain_group('nut') }
        it { is_expected.to contain_package('nut-cgi') }
        it { is_expected.to contain_user('nut') }
      when 'FreeBSD'
        it { is_expected.not_to compile.with_all_deps }
      end
    end
  end
end
