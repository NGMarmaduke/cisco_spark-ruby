require "cisco_spark/model"

module CiscoSpark
  class Person
    include Model
    resource 'people'

    attributes(
      id: DataCaster::String,
      emails: DataCaster::Array,
      display_name: DataCaster::String,
      avatar: DataCaster::String,
      created: DataCaster::DateTime,
    )

    def self.all_by_email(email, options={})
      options[:email] = email
      self.fetch_all(options)
    end

    def self.all_by_name(name, options={})
      options[:display_name] = name
      self.fetch_all(options)
    end

    def memberships(options={})
      options[person_id] = id
      CiscoSpark::Membership.fetch_all(options)
    end
  end
end