module CiscoSpark
  class Configuration
    def self.params
      [:api_key, :api_version, :api_domain]
    end
    attr_accessor *self.params

    def initialize
      @api_version = 'v1'
      @api_domain  = 'api.ciscospark.com'
    end

    def api_key
      raise NoApiKeyError unless @api_key
      @api_key
    end
  end
end