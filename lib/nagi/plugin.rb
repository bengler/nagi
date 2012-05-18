module Nagi
  class Plugin
    attr_accessor :check, :name, :optionparser, :prefix, :version

    def initialize
      @optionparser = Nagi::OptionParser.new
    end

    def name=(value)
      @name = value
      @optionparser.program_name = value
    end

    def run(args)
      begin
        status = @check.call(@optionparser.parse(args))
        raise 'Check did not provide a status' unless status.is_a? Nagi::Status::Status
      rescue ArgumentError => e
        STDERR.puts("Error: #{e.message}")
        puts ""
        puts @optionparser
        exit 4
      rescue StandardError => e
        status = Nagi::Status::Unknown.new(e.message)
      end
      return status
    end

    def run!
      status = run(ARGV)
      puts "#{@prefix.upcase if @prefix} #{status}".strip
      exit status.code
    end

    def version=(value)
      @version = value
      @optionparser.version = value
    end
  end
end
