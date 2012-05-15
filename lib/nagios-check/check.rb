module NagiosCheck
  class Check
    attr_accessor :name, :version

    def initialize(name, version)
      @name = name
      @version = version
      @optionparser = OptionParser.new do |o|
        o.banner = "Usage: #{$0} [options]"

        o.on_tail("-V", "--version", "Display version") do
          puts "#{@name} #{@version}"
          exit
        end

        o.on_tail("-h", "--help", "Display this help message") do
          puts o
          exit
        end
      end
    end

    def check
      raise NotImplementedError.new('You must override this method with your own check.')
    end

    def execute(command)
      output, status = Open3.capture2e("/bin/bash -o pipefail -c '#{command}'")
      raise "Shell failure, '#{output.gsub(/^\/bin\/bash: /, '').strip}'" if status.exitstatus != 0
      return output.strip
    end

    def run(args=[])
      @optionparser.parse!(args)
      begin
        status = self.check(*args)
        raise 'Check did not return a status' unless status.is_a? NagiosCheck::Status
      rescue ArgumentError
        puts "Error: required arguments not given"
        puts
        puts @optionparser
        exit 3
      rescue StandardError => e
        status = Unknown.new(e.message)
      end
      return status
    end

    def run!
      status = self.run(ARGV)
      puts "#{@name.upcase} #{status}"
      exit status.code
    end
  end
end
