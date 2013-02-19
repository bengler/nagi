module Nagi
  class Plugin
    attr_accessor :fallback, :name, :optionparser, :prefix, :version

    def initialize
      @optionparser = Nagi::OptionParser.new
    end

    def check(options)
      raise NotImplementedError.new('No check defined')
    end

    def name=(value)
      @name = value
      @optionparser.program_name = value
    end

    def run(args)
      options = @optionparser.parse(args)
      begin
        status = self.check(options)
      rescue StandardError => e
        status = Nagi::Status::Unknown.new(e.message)
      end
      unless status.is_a?Nagi::Status::Status
      status = @fallback || Nagi::Status::Unknown.new('Check did not provide a status')
      end
      return status
    end

    def run!
      begin
        status = run(ARGV)
        puts "#{@prefix.upcase if @prefix} #{status}".strip
        exit status.code
      rescue ArgumentError => e
        STDERR.puts("Error: #{e.message}")
        puts ""
        puts @optionparser
        exit 4
      end
    end

    def version=(value)
      @version = value
      @optionparser.version = value
    end
  end
end
