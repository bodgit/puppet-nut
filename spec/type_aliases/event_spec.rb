require 'spec_helper'

describe 'Nut::Event' do
  it { is_expected.to allow_values('online', 'onbatt', 'lowbatt', 'fsd', 'commok', 'commbad', 'shutdown', 'replbatt', 'nocomm') }
  it { is_expected.not_to allow_values('nope', 'invalid') }
end
