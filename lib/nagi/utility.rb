module Nagi
  module Utility
    module_function

    def execute(command)
      command = command.gsub(/'/, "\'")
      if defined?(Open3.capture2)
        output, status = Open3.capture2e("/bin/bash -o pipefail -c '#{command}'")
      else
        IO.popen("/bin/bash -o pipefail -c '#{command}' 2>&1") do |io|
          output = io.read
        end
        status = $?
      end
      raise "Shell failure, '#{output.gsub(/^\/bin\/bash: /, '').strip}'" if status.exitstatus != 0
      return output.strip
    end
  end
end
