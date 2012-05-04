require 'spec_helper'

describe NagiosCheck::Check do
  before(:all) do
    @check = NagiosCheck::Check.new('name')
  end

  describe '.check' do
    it 'raises NotImplementedError' do
      lambda { @check.check }.should raise_error NotImplementedError
    end
  end

  describe '.execute' do
    it 'raises exception on non-zero status' do
      lambda { @check.execute('exit 1') }.should raise_error Exception
    end

    it 'returns command stdout' do
      @check.execute('echo test').should eq 'test'
    end

    it 'returns command stderr' do
      @check.execute('echo test >&2').should eq 'test'
    end
  end

  describe '.name' do
    it 'contains name' do
      @check.name.should eq 'name'
    end
  end
end
