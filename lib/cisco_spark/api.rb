require 'net/http'
require 'json'

module CiscoSpark
  class Api
    attr_accessor :resource, :params, :request_body

    def get(resource, params={})
      @resource = resource
      @params = params

      do_get
    end

    def post(resource, request_body={})
      @resource = resource
      @request_body = request_body

      do_post
    end

    def put(resource, request_body={})
      @resource = resource
      @request_body = request_body

      do_put
    end

    def delete(resource)
      @resource = resource

      do_delete
    end

    private

    def do_delete
      delete_request = request(Net::HTTP::Delete)
      response = http_client.request(delete_request)
      debug(response) if CiscoSpark.debug

      response.is_a?(Net::HTTPSuccess)
    end

    def do_get
      get_request = request(Net::HTTP::Get)
      response = http_client.request(get_request)
      debug(response) if CiscoSpark.debug

      response
    end

    def do_post
      post_request = request(Net::HTTP::Post)
      post_request.set_form_data(request_body)
      debug(post_request) if CiscoSpark.debug

      response = http_client.request(post_request)
      debug(response) if CiscoSpark.debug

      response
    end

    def do_put
      post_request = request(Net::HTTP::Put)
      post_request.set_form_data(request_body)
      debug(post_request) if CiscoSpark.debug

      response = http_client.request(post_request)
      debug(response) if CiscoSpark.debug

      response
    end

    def http_client
      client = Net::HTTP.new(request_uri.host, request_uri.port)
      client.use_ssl = (request_uri.scheme == "https")
      client
    end

    def request(request_class)
      request = request_class.new(request_uri)
      request['Content-type'] = "application/json; charset=utf-8"
      request['Authorization'] = "Bearer #{CiscoSpark.api_key}"
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
      (@params || {}).each_with_object({}) do |(key, value), hash|
        hash[Utils.camelize(key)] = value if value
      end
    end

    def request_body
      @request_body.each_with_object({}) do |(key, value), hash|
        hash[Utils.camelize(key)] = value if value
      end
    end

    def domain
      @domain ||= URI.join("#{CiscoSpark.api_protocol}://#{CiscoSpark.api_domain}")
    end
  end
end