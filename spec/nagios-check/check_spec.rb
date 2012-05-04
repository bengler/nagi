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

  describe '.format' do
    it 'formats a Status' do
      @check.format(
        NagiosCheck::Status::Warning.new('message')
      ).should eq 'NAME WARNING: message'
    end
  end

  describe '.name' do
    it 'contains name' do
      @check.name.should eq 'name'
    end
  end
end
