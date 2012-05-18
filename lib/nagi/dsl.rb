module Nagi
  class DSL
    attr_reader :plugin

    def initialize(&block)
      @plugin = Nagi::Plugin.new
      instance_eval &block
    end

    def argument(name)
      @plugin.options.argument(name)
    end

    def check(&block)
      @plugin.check = lambda do |options|
        status = catch(:status) do
          block.call(options)
        end
        return status
      end
    end

    def critical(message)
      throw :status, Nagi::Status::Critical.new(message)
    end

    def execute(command)
      return Nagi::Utility::execute(command)
    end

    def name(name)
      @plugin.options.name = name
    end

    def ok(message)
      throw :status, Nagi::Status::OK.new(message)
    end

    def prefix(prefix)
      @plugin.prefix = prefix
    end

    def switch(name, *args)
      @plugin.options.switch(name, *args)
    end

    def unknown(message)
      throw :status, Nagi::Status::Unknown.new(message)
    end

    def version(version)
      @plugin.options.version = version
    end

    def warning(message)
      throw :status, Nagi::Status::Warning.new(message)
    end
  end
end
