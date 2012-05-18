module Nagi
  class Options
    attr_accessor :name, :version

    def initialize
      @arguments = []
      @options = {}
      @parser = OptionParser.new do |o|
        o.banner = "Usage: #{$0} [options]"

        o.on_tail('-h', '--help', 'Display this help message') do
          puts o
          exit 0
        end

        o.on_tail('-V', '--version', 'Display version information') do
          puts "#{o.program_name} #{o.version or "(unknown version)"}".strip
          exit 0
        end
      end
    end

    def to_s
      return @parser.help
    end

    def argument(name)
      @arguments.push(name)
      @parser.banner += " <#{name}>"
    end

    def name
      return @parser.program_name
    end

    def name=(value)
      @parser.program_name = value
    end

    def parse(args)
      begin
        @options.clear
        @parser.parse!(args)
        @arguments.each do |a|
          @options[a] = args.shift or raise ArgumentError.new("Argument '#{a}' not given")
        end
        raise ArgumentError.new("Too many arguments") if args.length > 0
      rescue OptionParser::ParseError => e
        raise ArgumentError.new(e.message)
      end
      return @options
    end

    def switch(name, *args, &block)
      @parser.on(*args) do |value|
        @options[name] = value
      end
    end

    def version
      return @parser.version
    end

    def version=(value)
      @parser.version = value
    end
  end
end
