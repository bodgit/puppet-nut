require 'spec_helper'

describe 'Nut::Listen' do
  it { is_expected.to allow_value('address' => '127.0.0.1') }
  it { is_expected.to allow_value('address' => '::1') }
  it { is_expected.to allow_value('address' => '127.0.0.1', 'port' => 12_345) }
  it { is_expected.to allow_value('address' => '::1', 'port' => 12_345) }
  it { is_expected.not_to allow_value('127.0.0.1') }
  it { is_expected.not_to allow_value('::1') }
  it { is_expected.not_to allow_value(12_345) }
  it { is_expected.not_to allow_value('address' => 'invalid') }
  it { is_expected.not_to allow_value('port' => 12_345) }
  it { is_expected.not_to allow_value('address' => '127.0.0.1', 'port' => 65_536) }
  it { is_expected.not_to allow_value('address' => '127.0.0.1', 'port' => '12345') }
end
