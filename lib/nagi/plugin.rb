module Nagi
  class Plugin
    attr_accessor :check, :name, :optionparser, :options, :version

    def initialize
      @options = {}
      @optionparser = Nagi::OptionParser.new do |o|
        o.banner = "Usage: #{$0} [options]"

        o.on_tail("-V", "--version", "Display version") do
          puts "#{@name} #{@version}"
          exit 0
        end

        o.on_tail("-h", "--help", "Display this help message") do
          puts o
          exit 0
        end
      end
    end

    def run(args)
      begin
        @optionparser.parse!(args)
        status = catch(:status) do
          @check.call(@options)
        end
        raise 'Check did not provide a status' unless status.is_a? Nagi::Status::Status
      rescue ArgumentError => e
        STDERR.puts("Error: #{e.message}")
        puts ""
        puts @optionparser
        exit 3
      rescue StandardError => e
        status = Nagi::Status::Unknown.new(e.message)
      end
      return status
    end

    def run!
      status = run(ARGV)
      puts "#{@name.upcase if @name} #{status}".strip
      exit status.code
    end
  end
end
