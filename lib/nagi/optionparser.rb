module Nagi
  class OptionParser < ::OptionParser

    def initialize(*args, &block)
      @arguments = []
      @options = {}

      super(*args, &block)

      self.banner = "Usage: #{$0} [options]"

      self.on_tail('-h', '--help', 'Display this help message') do
        puts help
        exit 0
      end

      self.on_tail('-V', '--version', 'Display version information') do
        puts "#{program_name} #{version or "(unknown version)"}".strip
        exit 0
      end
    end

    def argument(name)
      @arguments.push(name)
      self.banner += " <#{name}>"
    end

    def parse!(args)
      begin
        @options.clear
        super(args)
        @arguments.each do |a|
          @options[a] = args.shift or raise ArgumentError.new("Argument '#{a}' not given")
        end
        raise ArgumentError.new("Too many arguments") if args.length > 0
      rescue ::OptionParser::ParseError => e
        raise ArgumentError.new(e.message)
      end
      return @options
    end

    def switch(name, *args)
      on(*args) do |value|
        @options[name] = value
      end
    end
  end
end
