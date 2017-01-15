require 'spec_helper'

if Puppet.version.to_f >= 4.4
  describe 'test::device', type: :class do
    describe 'accepts devices' do
      [
        'ups@localhost',
        'ups@localhost:12345',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        'ups',
        'ups@',
        '@localhost',
        '@localhost:12345',
        ':12345',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
