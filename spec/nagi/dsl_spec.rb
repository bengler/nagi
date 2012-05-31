require 'spec_helper'

describe Nagi::DSL do
  before(:each) do
    @dsl = Nagi::DSL.new do
    end
  end

  describe '#plugin' do
    it 'contains a Nagi::Plugin' do
      @dsl.plugin.class.should eq Nagi::Plugin
    end
    
    it 'is read-only' do
      lambda { @sdl.plugin = nil }.should raise_error NoMethodError
    end
  end

  describe '.argument' do
    it 'sends argument to parser.optionparser' do
      @dsl.argument(:name)
      @dsl.plugin.optionparser.help.should match /<name>/
    end
  end

  describe '.check' do
    it 'sets the code block on plugin.check' do
      @dsl.check do |options|
        $nagi = options
      end
      @dsl.plugin.check({'a' => 1})
      $nagi.should eq Hash['a' => 1]
    end

    it 'catches throwns :status and returns payload' do
      @dsl.check do |options|
        throw :status, 'status'
      end
      @dsl.plugin.check({}).should eq 'status'
    end

    it 'catches throwns :status and returns payload, even when collect is set' do
      @dsl.collect(:all)
      @dsl.check do |options|
        throw :status, 'status'
      end
      @dsl.plugin.check({}).should eq 'status'
    end

    it 'returns first, most severe status for collect :severe' do
      @dsl.collect(:severe)
      @dsl.check do |o|
        @dsl.warning 'w1'
        @dsl.critical 'c1'
        @dsl.ok 'o1'
        @dsl.critical 'c2'
        @dsl.ok 'o2'
      end

      status = @dsl.plugin.check({})
      status.class.should eq Nagi::Status::Critical
      status.message.should eq 'c2'
    end

    it 'returns most severe status with all messages joined for collect :all' do
      @dsl.collect(:all)
      @dsl.check do |o|
        @dsl.warning 'w1'
        @dsl.critical 'c1'
        @dsl.ok 'o1'
        @dsl.critical 'c2'
        @dsl.ok 'o2'
      end

      status = @dsl.plugin.check({})
      status.class.should eq Nagi::Status::Critical
      status.message.should eq 'w1, c1, o1, c2, o2'
    end
  end

  describe '.collect' do
    it 'accepts :all' do
      @dsl.collect(:all)
    end

    it 'accepts :severe' do
      @dsl.collect(:severe)
    end

    it 'raises exception on other value' do
      lambda { @dsl.collect(:dummy) }.should raise_error
    end
  end

  describe '.critical' do
    it 'throws :status with critical status' do
      catch(:status) do
        @dsl.critical('message')
      end.class.should eq Nagi::Status::Critical
    end

    it 'returns status if collection is enabled' do
      @dsl.collect(:all)
      @dsl.critical('message').class.should eq Nagi::Status::Critical
    end
  end

  describe '.execute' do
    it 'executes a command with Nagi::Utility.execute' do
      @dsl.execute('echo test >&2').should eq 'test'
    end
  end

  describe '.name' do
    it 'sets plugin name' do
      @dsl.name('name')
      @dsl.plugin.name.should eq 'name'
    end
  end

  describe '.ok' do
    it 'throws :status with ok status' do
      catch(:status) do
        @dsl.ok('message')
      end.class.should eq Nagi::Status::OK
    end

    it 'returns status if collection is enabled' do
      @dsl.collect(:all)
      @dsl.ok('message').class.should eq Nagi::Status::OK
    end
  end

  describe '.prefix' do
    it 'sets plugin prefix' do
      @dsl.prefix('prefix')
      @dsl.plugin.prefix.should eq 'prefix'
    end
  end

  describe '.switch' do
    it 'adds optionparser switch' do
      @dsl.switch(:switch, '-s', '--switch', 'Test switch')
      @dsl.plugin.optionparser.top.list[-1].short[0].should eq '-s'
      @dsl.plugin.optionparser.top.list[-1].long[0].should eq '--switch'
    end
  end

  describe '.unknown' do
    it 'throws :status with unknown status' do
      catch(:status) do
        @dsl.unknown('message')
      end.class.should eq Nagi::Status::Unknown
    end

    it 'returns status if collection is enabled' do
      @dsl.collect(:all)
      @dsl.unknown('message').class.should eq Nagi::Status::Unknown
    end
  end

  describe '.version' do
    it 'sets plugin version' do
      @dsl.version('version')
      @dsl.plugin.version.should eq 'version'
    end
  end

  describe '.warning' do
    it 'throws :status with warning status' do
      catch(:status) do
        @dsl.warning('message')
      end.class.should eq Nagi::Status::Warning
    end

    it 'returns status if collection is enabled' do
      @dsl.collect(:all)
      @dsl.warning('message').class.should eq Nagi::Status::Warning
    end
  end
end
