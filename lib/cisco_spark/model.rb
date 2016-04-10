require "cisco_spark/api"
require "cisco_spark/collection"
require "cisco_spark/data_caster"

module CiscoSpark
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def resource(resource=nil)
        return @resource unless resource

        @resource = resource
      end

      def attributes(hash=nil)
        return @attributes unless hash

        @attributes = hash
        attr_accessor *@attributes.keys
      end

      def mutable_attributes(*attributes)
        @mutable_attributes = attributes
      end

      def fetch_all_raw(options={})
        Api.new.get(@resource, options)
      end

      def fetch_all(options={})
        response = fetch_all_raw(options)
        collection = parse_collection(response.body)
        CiscoSpark::Collection.new(self, collection, response)
      end

      def fetch(id, options={})
        response = Api.new.get("#{@resource}/#{id}", options)
        parse(response.body)
      end

      def create(attributes)
        response = Api.new.post(@resource, attributes)
        parse(response.body)
      end

      def update(id, attributes)
        attributes = attributes.select{ |name, _v| @mutable_attributes.include?(name) }
        response = Api.new.put("#{@resource}/#{id}", attributes)
        parse(response.body)
      end

      def destroy(id)
        Api.new.delete("#{@resource}/#{id}")
      end

      def parse_collection(object)
        object = JSON.parse(object) if object.is_a?(String)
        object = object.fetch('items', []) if object.is_a?(Hash)
        object.map{ |hash| parse(hash) }
      end

      def parse(hash)
        hash = JSON.parse(hash) if hash.is_a?(String)
        params = attributes.each_with_object({}) do |(attribute, caster), params|
          params[attribute] = caster.call(hash[Utils.camelize(attribute)])
        end
        new(params)
      end
    end # ClassMethods

    def initialize(attributes={})
      assign_attributes(attributes)
    end

    def fetch
      merge_attributes(self.class.fetch(id))
      self
    end

    def persist
      id ? update : create
    end

    def destroy
      self.class.destroy(id)
    end

    def to_h
      self.class.attributes.keys.each_with_object({}) { |name, hash|
        hash[name] = send(name)
      }
    end

    private

    def create
      merge_attributes(self.class.create(to_h))
      self
    end

    def update
      attrs = to_h
      id = attrs.delete(:id)
      merge_attributes(self.class.update(id, attrs))
      self
    end

    def merge_attributes(object)
      assign_attributes(object.to_h)
    end

    def assign_attributes(attributes)
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  end
end