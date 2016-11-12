require "cisco_spark/model"

module CiscoSpark
  class Team
    include Model
    resource 'teams'

    attributes(
      id: DataCaster::String,
      name: DataCaster::String,
      created: DataCaster::DateTime
    )
    mutable_attributes :name
  end
end
