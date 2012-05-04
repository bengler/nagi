module NagiosCheck
  class Check
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def check
      raise NotImplementedError.new('You must override this method with your own check.')
    end

    def format(status)
      return "#{@name.upcase} #{status.name.upcase}: #{status.message}"
    end

    def run
      begin
        status = self.check
      rescue Exception => e
        status = Status::Unknown(e.message)
      end

      puts self.format(status)
      exit status.code
    end
  end
end
