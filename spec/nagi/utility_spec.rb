require 'spec_helper'

describe 'Nagi::Utility::execute' do
  it 'raises exception on non-zero status' do
    lambda { Nagi::Utility.execute('exit 1') }.should raise_error StandardError
  end

  it 'raises exception on non-zero status in pipelines' do
    lambda { Nagi::Utility.execute('false | true') }.should raise_error StandardError
  end

  it 'returns command stdout' do
    Nagi::Utility.execute('echo test').should eq 'test'
  end

  it 'returns command stderr' do
    Nagi::Utility.execute('echo test >&2').should eq 'test'
  end
end
