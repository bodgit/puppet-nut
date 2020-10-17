require 'spec_helper'

describe 'nut::user' do

  let(:pre_condition) do
    'include ::nut'
  end

  let(:title) do
    'test'
  end

  let(:params) do
    {
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

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_concat__fragment('nut user test') }
      it { is_expected.to contain_nut__user('test') }
    end
  end
end
