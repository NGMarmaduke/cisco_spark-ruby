require "cisco_spark/configuration"
require "cisco_spark/errors"
require "cisco_spark/utils"
require "cisco_spark/version"

require "cisco_spark/models/membership"
require "cisco_spark/models/message"
require "cisco_spark/models/person"
require "cisco_spark/models/room"


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

  def self.with_token(token, &block)
    old_token = configuration.api_key rescue nil
    configuration.api_key = token

    begin
      block.call
    ensure
      configuration.api_key = old_token
    end
  end
end
