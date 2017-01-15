require 'spec_helper'

describe 'nut::client::upssched' do

  let(:pre_condition) do
    'class { "::nut::client": use_upssched => true }'
  end

  let(:title) do
    'test upssched event'
  end

  let(:params) do
    {
      'args'       => [
        'upsgone',
        10,
      ],
      'command'    => 'start-timer',
      'notifytype' => 'commbad',
      'ups'        => 'test@localhost',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_class('nut::client') }
      it { should contain_concat__fragment('nut upssched test upssched event') }
      it { should contain_nut__client__upssched('test upssched event') }
    end
  end
end
