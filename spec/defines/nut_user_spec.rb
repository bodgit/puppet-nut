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
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_concat__fragment('nut user test') }
      it { should contain_nut__user('test') }
    end
  end
end
