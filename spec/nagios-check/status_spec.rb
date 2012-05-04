require 'spec_helper'

describe NagiosCheck::Status do
  before(:each) do
    @status = NagiosCheck::Status.new(0, 'name', 'message')
  end

  describe '.code' do
    it 'contains status code' do
      @status.code.should eq 0
    end

    it 'is read-only' do
      lambda { @status.code = 1 }.should raise_error NoMethodError
    end
  end

  describe '.message' do
    it 'contains message' do
      @status.message.should eq 'message'
    end

    it 'is writable' do
      @status.message = 'test'
      @status.message.should eq 'test'
    end
  end

  describe '.name' do
    it 'contains name' do
      @status.name.should eq 'name'
    end

    it 'is read-only' do
      lambda { @status.name = 'test' }.should raise_error NoMethodError
    end
  end

  describe '.to_s' do
    it 'formats the status' do
      @status.to_s.should eq 'NAME: message'
    end
  end
end

describe NagiosCheck::Critical do
  before(:each) do
    @status = NagiosCheck::Critical.new('message')
  end

  describe '.code' do
    it 'is 2' do
      @status.code.should eq 2
    end
  end

  describe '.message' do
    it 'contains message' do
      @status.message.should eq 'message'
    end
  end

  describe '.name' do
    it 'is Critical' do
      @status.name.should eq 'Critical'
    end
  end
end

describe NagiosCheck::OK do
  before(:each) do
    @status = NagiosCheck::OK.new('message')
  end

  describe '.code' do
    it 'is 0' do
      @status.code.should eq 0
    end
  end

  describe '.message' do
    it 'contains message' do
      @status.message.should eq 'message'
    end
  end

  describe '.name' do
    it 'is OK' do
      @status.name.should eq 'OK'
    end
  end
end

describe NagiosCheck::Unknown do
  before(:each) do
    @status = NagiosCheck::Unknown.new('message')
  end

  describe '.code' do
    it 'is 3' do
      @status.code.should eq 3
    end
  end

  describe '.message' do
    it 'contains message' do
      @status.message.should eq 'message'
    end
  end

  describe '.name' do
    it 'is Unknown' do
      @status.name.should eq 'Unknown'
    end
  end
end

describe NagiosCheck::Warning do
  before(:each) do
    @status = NagiosCheck::Warning.new('message')
  end

  describe '.code' do
    it 'is 1' do
      @status.code.should eq 1
    end
  end

  describe '.message' do
    it 'contains message' do
      @status.message.should eq 'message'
    end
  end

  describe '.name' do
    it 'is Warning' do
      @status.name.should eq 'Warning'
    end
  end
end
