module Railmate
  class Error < StandardError; end
  class InvalidConfigError < Error; end
end

require "railmate/cli"
require "railmate/environment"
require "railmate/logs"
require "railmate/scplog"
require "railmate/version"
