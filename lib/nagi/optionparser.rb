module Nagi
  class OptionParser < ::OptionParser

    def on_arg(name, &block)
      @args = [] unless @args
      @args.push([name, block])
      self.banner += " <#{name}>"
    end

    def parse!(argv = ARGV)
      begin
        super(argv)
        @args.each do |arg, block|
          value = argv.shift or raise ArgumentError.new("Argument '#{arg}' not given")
          block.call(value)
        end
        raise ArgumentError.new("Too many arguments") if argv.length > 0
      rescue OptionParser::ParseError => e
        raise ArgumentError.new(e.message)
      end
      return argv
    end
  end
end
