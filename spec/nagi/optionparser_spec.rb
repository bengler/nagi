require 'spec_helper'

describe Nagi::OptionParser do
  before(:each) do
    @parser = Nagi::OptionParser.new
  end

  it 'subclasses OptionParser' do
    @parser.is_a?(::OptionParser).should eq true
  end

  describe '.initialize' do
    it 'set proper banner' do
      @parser.banner.should eq "Usage: #{$0} [options]"
    end

    it 'sets up -h, --help' do
      @parser.base.list[-2].short[0].should eq '-h'
      @parser.base.list[-2].long[0].should eq '--help'
    end

    it 'sets up -V, --version' do
      @parser.base.list[-1].short[0].should eq '-V'
      @parser.base.list[-1].long[0].should eq '--version'
    end
  end

  describe '.argument' do
    it 'modifies banner' do
      @parser.argument('test')
      @parser.banner.should eq "Usage: #{$0} [options] <test>"
    end
  end

  describe '.parse!' do
    it 'parses arguments' do
      @parser.argument(:test)
      @parser.parse!(['testvalue']).should eq Hash[:test => 'testvalue']
    end

    it 'parses switches' do
      @parser.switch(:test, '-t', '--test', 'Test switch')
      @parser.parse!(['-t']).should eq Hash[:test => true]
    end

    it 'parses switches with value' do
      @parser.switch(:test, '-t', '--test VALUE', 'Test switch')
      @parser.parse!(['-t', 'testvalue']).should eq Hash[:test => 'testvalue']
    end

    it 'modifies input array' do
      args = ['-t', 'testvalue', 'argument']
      @parser.argument(:arg)
      @parser.switch(:test, '-t', '--test VALUE', 'Test switch')
      @parser.parse!(args)
      args.should eq []
    end

    it 'raises ArgumentError on invalid switch' do
      lambda { @parser.parse!(['-x']) }.should raise_error ArgumentError
    end

    it 'raises ArgumentError on too few arguments' do
      @parser.argument(:test)
      lambda { @parser.parse!([]) }.should raise_error ArgumentError
    end

    it 'raises ArgumentError on too many arguments' do
      @parser.argument(:test)
      lambda { @parser.parse!(['x', 'y']) }.should raise_error ArgumentError
    end
  end

  describe '.switch' do
    it 'adds a switch' do
      @parser.switch('name', '-t', '--test TEST') do |value|
      end

      @parser.top.list[-1].short[0].should eq '-t'
      @parser.top.list[-1].long[0].should eq '--test'
    end
  end
end
