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
      output, status = Open3.capture2e(command)
      puts status.exitstatus

      if status.exitstatus != 0
        raise "Command failed: #{command}".strip
      end

      return output.strip
    end

    def run
      begin
        status = self.check
      rescue Exception => e
        status = Status::Unknown(e.message)
      end

      puts "#{@name.upcase} #{status}"
      exit status.code
    end
  end
end
