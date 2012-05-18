module Nagi
  class Plugin
    attr_accessor :check, :name, :options, :prefix, :version

    def initialize
      @options = Nagi::Options.new
    end

    def name=(value)
      @name = value
      @options.name = value
    end

    def run(args)
      begin
        status = @check.call(@options.parse(args))
        raise 'Check did not provide a status' unless status.is_a? Nagi::Status::Status
      rescue ArgumentError => e
        STDERR.puts("Error: #{e.message}")
        puts ""
        puts @options
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
      @options.version = value
    end
  end
end
