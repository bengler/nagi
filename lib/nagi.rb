require 'open3'
require 'optparse'

require 'nagi/dsl'
require 'nagi/plugin'
require 'nagi/status'
require 'nagi/version'

module Nagi
end

def Nagi(&block)
  Nagi::DSL.new(&block).plugin.run!
end
