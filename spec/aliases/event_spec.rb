require 'spec_helper'

if Puppet.version.to_f >= 4.4
  describe 'test::event', type: :class do
    describe 'accepts events' do
      [
        'online',
        'onbatt',
        'lowbatt',
        'fsd',
        'commok',
        'commbad',
        'shutdown',
        'replbatt',
        'nocomm',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        'nope',
        'invalid',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
