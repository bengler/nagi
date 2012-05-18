require 'spec_helper'

describe Nagi::Plugin do
  before(:each) do
    @plugin = Nagi::Plugin.new
  end

  describe '#optionparser' do
    it 'contains OptionParser' do
      @plugin.optionparser.class.should eq Nagi::OptionParser
    end
  end

  describe '#name' do
    it 'sets name' do
      @plugin.name = 'name'
      @plugin.name.should eq 'name'
    end

    it 'sets optionparser.program_name' do
      @plugin.name = 'name'
      @plugin.optionparser.program_name.should eq 'name'
    end
  end

  describe '#prefix' do
    it 'sets prefix' do
      @plugin.prefix = 'prefix'
      @plugin.prefix.should eq 'prefix'
    end
  end

  describe '#version' do
    it 'sets version' do
      @plugin.version = 'version'
      @plugin.version.should eq 'version'
    end

    it 'sets optionparser.version' do
      @plugin.version = 'version'
      @plugin.optionparser.version.should eq 'version'
    end
  end

  describe '.check' do
    it 'raises NotImplementedError' do
      lambda { @plugin.check({}) }.should raise_error NotImplementedError
    end
  end

  describe '.run' do
    it 'passes parsed options to check' do
      class << @plugin
        def check(options)
          $nagi = options
        end
      end
      @plugin.optionparser.argument(:arg)
      @plugin.optionparser.switch(:switch, '-s', '--switch VALUE', 'Test switch')
      @plugin.run(['-s', 'value', 'argument'])
      $nagi.should eq Hash[:arg => 'argument', :switch => 'value']
    end

    it 'returns check status' do
      class << @plugin
        def check(options)
          return Nagi::Status::OK.new('ok')
        end
      end
      @plugin.run([]).class.should eq Nagi::Status::OK
    end

    it 'returns unknown status on check exception' do
      class << @plugin
        def check(options)
          raise StandardError.new('error')
        end
      end
      @plugin.run([]).class.should eq Nagi::Status::Unknown
    end

    it 'doesnt catch errors from optionparser' do
      lambda { @plugin.run(['--invalid']) }.should raise_error ArgumentError
    end
  end
end
