require 'spec_helper'
describe 'bits_upload' do

  context 'with defaults for all parameters' do
    it { should contain_class('bits_upload') }
  end
end
