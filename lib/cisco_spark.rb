require "cisco_spark/configuration"
require "cisco_spark/errors"
require "cisco_spark/version"

module CiscoSpark
  extend SingleForwardable
  def_delegators :configuration, *Configuration.params

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.clear_configuration!
    @configuration = Configuration.new
  end
end
