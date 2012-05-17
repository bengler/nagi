module Nagi
  class Status
    attr_accessor :message
    attr_reader :code, :name

    def initialize(code, name, message)
      @code = code
      @name = name
      @message = message
    end

    def to_s
      return "#{@name.upcase}: #{@message}"
    end
  end

  class Critical < Status
    def initialize(message)
      super(2, 'Critical', message)
    end
  end

  class OK < Status
    def initialize(message)
      super(0, 'OK', message)
    end
  end

  class Unknown < Status
    def initialize(message)
      super(3, 'Unknown', message)
    end
  end

  class Warning < Status
    def initialize(message)
      super(1, 'Warning', message)
    end
  end
end
