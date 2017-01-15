require 'spec_helper'

if Puppet.version.to_f >= 4.4
  describe 'test::listen', type: :class do
    describe 'accepts listen structs' do
      [
        {
          'address' => '127.0.0.1',
        },
        {
          'address' => '::1',
        },
        {
          'address' => '127.0.0.1',
          'port'    => 12345,
        },
        {
          'address' => '::1',
          'port'    => 12345,
        },
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        '127.0.0.1',
        '::1',
        12345,
        {
          'address' => 'invalid',
        },
        {
          'port' => 12345,
        },
        {
          'address' => '127.0.0.1',
          'port'    => 65536,
        },
        {
          'address' => '127.0.0.1',
          'port'    => '12345',
        },
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
