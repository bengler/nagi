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
      raise "Command failed: #{command}".strip if status.exitstatus != 0
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
