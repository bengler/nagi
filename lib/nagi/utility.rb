module Nagi
  module Utility
    module_function

    def execute(command)
      output, status = Open3.capture2e("/bin/bash -o pipefail -c '#{command}'")
      raise "Shell failure, '#{output.gsub(/^\/bin\/bash: /, '').strip}'" if status.exitstatus != 0
      return output.strip
    end
  end
end
