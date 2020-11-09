require 'spec_helper'

describe 'Nut::Device' do
  it { is_expected.to allow_value('ups@localhost') }
  it { is_expected.to allow_value('ups@localhost:12345') }
  it { is_expected.not_to allow_value('ups') }
  it { is_expected.not_to allow_value('ups@') }
  it { is_expected.not_to allow_value('@localhost') }
  it { is_expected.not_to allow_value('@localhost:12345') }
  it { is_expected.not_to allow_value(':12345') }
end
