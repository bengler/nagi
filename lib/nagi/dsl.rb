module Nagi
  class DSL
    attr_reader :plugin

    def initialize(&block)
      @plugin = Nagi::Plugin.new
      @collect = nil
      @collected = []
      instance_eval &block
    end

    def argument(name)
      @plugin.optionparser.argument(name)
    end

    def check(&block)
      # make data available to block
      collect = @collect
      collected = @collected

      p = class << @plugin; self; end
      p.send(:define_method, :check) do |options|
        status = catch(:status) {
          block.call(options)
          nil # to avoid returning status if not thrown
        }
        return status if status or not collect
        return nil if collected.empty?
        return collected.reverse.max if collect == :severe
        return collected.reverse.max.class.new(
          collected.map { |s| s.message }.join(', ')
        ) if collect == :all
        return nil
      end
    end

    def collect(type)
      raise "Invalid collect type #{type.to_s}" unless [:all, :severe].include?(type)
      @collect = type
    end

    def critical(message, force=false)
      status = Nagi::Status::Critical.new(message)
      throw :status, status if force or not @collect
      @collected.push(status)
      return status
    end

    def execute(command)
      return Nagi::Utility.execute(command)
    end

    def name(name)
      @plugin.name = name
    end

    def ok(message, force=false)
      status = Nagi::Status::OK.new(message)
      throw :status, status if force or not @collect
      @collected.push(status)
      return status
    end

    def prefix(prefix)
      @plugin.prefix = prefix
    end

    def switch(name, *args)
      @plugin.optionparser.switch(name, *args)
    end

    def unknown(message, force=false)
      status = Nagi::Status::Unknown.new(message)
      throw :status, status if force or not @collect
      @collected.push(status)
      return status
    end

    def version(version)
      @plugin.version = version
    end

    def warning(message, force=false)
      status = Nagi::Status::Warning.new(message)
      throw :status, status if force or not @collect
      @collected.push(status)
      return status
    end
  end
end
