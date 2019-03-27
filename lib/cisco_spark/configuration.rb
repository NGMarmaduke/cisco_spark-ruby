module CiscoSpark
  class Configuration
    def self.params
      [:api_key, :api_version, :api_domain, :api_protocol, :debug, :proxy]
    end
    attr_accessor *self.params

    def initialize
      @api_version  = 'v1'
      @api_domain   = 'api.ciscospark.com'
      @api_protocol = 'https'
      @debug        = false
      @proxy        = ''
    end

    def api_key
      raise NoApiKeyError unless @api_key
      @api_key
    end
  end
end
