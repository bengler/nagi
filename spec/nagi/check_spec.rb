require 'spec_helper'

describe Nagi::Check do
  before(:each) do
    @check = Nagi::Check.new('name', '0.1')
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

    it 'raises exception on non-zero status in pipelines' do
      lambda { @check.execute('false | true') }.should raise_error Exception
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

  describe '.run' do
    it 'returns check status' do
      class << @check
        def check
          return $s = Nagi::OK.new('message')
        end
      end
      @check.run.should equal $s
    end

    it 'returns Unknown on exception' do
      class << @check
        def check
          raise 'Fail'
        end
      end
      status = @check.run
      status.class.should eq Nagi::Unknown
      status.message.should eq 'Fail'
    end

    it 'returns Unknown if check doesn\'t return a Status' do
      class << @check
        def check
          return "ok"
        end
      end
      status = @check.run
      status.class.should eq Nagi::Unknown
    end
  end

  describe '.version' do
    it 'contains version' do
      @check.version.should eq '0.1'
    end
  end
end
