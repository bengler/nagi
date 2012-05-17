module Nagi
  class DSL
    attr_reader :plugin

    def initialize(&block)
      @plugin = Nagi::Plugin.new
      instance_eval &block
    end

    def argument(name)
      @plugin.optionparser.on_arg(name) do |value|
        @plugin.options[name] = value
      end
    end

    def check(&block)
      @plugin.check = block
    end

    def critical(message)
      throw :status, Nagi::Status::Critical.new(message)
    end

    def name(name)
      @plugin.name = name
    end

    def ok(message)
      throw :status, Nagi::Status::OK.new(message)
    end

    def switch(name, *args)
      @plugin.optionparser.on(*args) do |value|
        @plugin.options[name] = value or true
      end
    end

    def unknown(message)
      throw :status, Nagi::Status::Unknown.new(message)
    end

    def version(version)
      @plugin.version = version
    end

    def warning(message)
      throw :status, Nagi::Status::Warning.new(message)
    end
  end
end
