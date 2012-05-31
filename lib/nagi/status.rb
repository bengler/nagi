module Nagi
  module Status
    class Status
      include Comparable
      attr_accessor :message
      attr_reader :code, :name

      def <=>(other)
        if not other.is_a? Nagi::Status::Status
          raise ArgumentError.new("comparison of Nagi::Status::Status with #{other.class} failed.")
        end

        # Make Unknown the least severe status
        c = @code >= 3 ? -1 : @code
        o = other.code >= 3 ? -1 : other.code
        return c <=> o
      end

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
end
