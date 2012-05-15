module NagiosCheck
  class Check
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def check
      raise NotImplementedError.new('You must override this method with your own check.')
    end

    def execute(command)
      output, status = Open3.capture2e("/bin/bash -o pipefail -c '#{command}'")
      raise "Shell failure, '#{output.gsub(/^\/bin\/bash: /, '').strip}'" if status.exitstatus != 0
      return output.strip
    end

    def run
      begin
        status = self.check
        raise 'Check did not return a status' unless status.is_a? NagiosCheck::Status
      rescue Exception => e
        status = Unknown.new(e.message)
      end
      return status
    end

    def run!
      status = self.run
      puts status
      exit status.code
    end
  end
end
