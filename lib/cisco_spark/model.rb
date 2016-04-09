require "cisco_spark/api"
require "cisco_spark/data_caster"

module CiscoSpark
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def resource(resource)
        @resource = resource
      end

      def attributes(hash=nil)
        return @attributes unless hash

        @attributes = hash
        attr_accessor *@attributes.keys
      end

      def fetch_all(options={})
        response = Api.new(@resource, options).result
        parse_collection(response['items'])
      end

      def fetch(id, options={})
        resource = "#{@resource}/#{id}"
        response = Api.new(resource, options).result
        parse(response)
      end

      def parse_collection(collection)
        collection.map{ |hash| parse(hash) }
      end

      def parse(hash)
        params = attributes.each_with_object({}) do |(attribute, caster), params|
          params[attribute] = caster.call(hash[Utils.camelize(attribute)])
        end
        new(params)
      end
    end # ClassMethods

    def initialize(attributes={})
      assign_attributes(attributes)
    end

    private

    def assign_attributes(attributes)
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

  end
end