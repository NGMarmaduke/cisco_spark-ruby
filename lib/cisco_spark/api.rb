require 'net/http'
require 'json'

module CiscoSpark
  class Api
    attr_accessor :resource, :params

    def initialize(resource, params={})
      @resource = resource
      @params = params
    end

    def result
      response = http_client.request(request)
      debug(response) if CiscoSpark.debug

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      end
    end

    private

    def http_client
      client = Net::HTTP.new(request_uri.host, request_uri.port)
      client.use_ssl = (request_uri.scheme == "https")
      client
    end

    def request
      request = Net::HTTP::Get.new(request_uri)
      request['Content-type'] = "application/json; charset=utf-8"
      request['Authorization'] = "Bearer #{CiscoSpark.api_key}"
      debug(request) if CiscoSpark.debug
      request
    end

    def debug(object)
      puts "|============ Api debug ============ |"
      puts "  -> request_uri: #{request_uri.inspect}"
      puts "  -> object: #{object.inspect}"
      puts "|============ Api debug ============ |"
    end

    def request_uri
      uri = URI.join(domain, "#{CiscoSpark.api_version}/#{resource}")
      uri.query = URI.encode_www_form(params)
      uri
    end

    def params
      @params.each_with_object({}) do |(key, value), hash|
        hash[Utils.camelize(key)] = value
      end
    end

    def domain
      @domain ||= URI.join("#{CiscoSpark.api_protocol}://#{CiscoSpark.api_domain}")
    end
  end
end