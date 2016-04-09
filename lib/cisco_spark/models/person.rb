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

  end
end