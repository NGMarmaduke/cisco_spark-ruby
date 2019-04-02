module CiscoSpark
  class NoApiKeyError < StandardError; end
  class InvalidApiKeyError < StandardError; end
  class ApiClientError < StandardError; end
  class ApiServerError < StandardError; end
end
