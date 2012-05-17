module Nagi
  class Plugin
    attr_accessor :check, :name, :version

    def run(args)
      begin
        status = catch(:status) do
          @check.call
        end
        raise 'Check did not provide a status' unless status.is_a? Nagi::Status::Status
      rescue StandardError => e
        status = Nagi::Status::Unknown.new(e.message)
      end
      return status
    end

    def run!
      status = run
      puts "#{@name.upcase if @name} #{status}".strip
      exit status.code
    end
  end
end
