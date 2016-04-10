module CiscoSpark
  class Collection
    attr_accessor :collection, :model_klass

    def initialize(model_klass, collection=[], response=nil)
      @model_klass = model_klass
      @collection = collection

      parse_pagination(response)
    end



    def method_missing(name, *args, &block)
      if collection.respond_to?(name)
        collection.send(name, *args, &block)
      else
        super
      end
    end

    def next
      return false unless next_params
      response = model_klass.fetch_all_raw(next_params)
      @collection = model_klass.parse_collection(response.body)
      parse_pagination(response)
      self
    end

    private

    attr_accessor :next_params

    def parse_pagination(response)
      @next_params = nil
      return unless response && response['Link']

      matches = /<(?<next>.*)>; rel="next"/.match(response['Link'])
      next_url = matches[:next]

      if next_url
        next_uri = URI.parse(next_url)
        @next_params = Hash[URI::decode_www_form(next_uri.query)]
      end
    end

  end
end