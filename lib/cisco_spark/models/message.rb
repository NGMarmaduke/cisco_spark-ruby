require "cisco_spark/model"

module CiscoSpark
  class Message
    include Model
    resource 'messages'

    attributes(
      id: DataCaster::String,
      person_id: DataCaster::String,
      person_email: DataCaster::String,
      room_id: DataCaster::String,
      text: DataCaster::Boolean,
      files: DataCaster::Array,
      to_person_id: DataCaster::String,
      to_person_email: DataCaster::String,
      created: DataCaster::DateTime,
    )

    def person
      CiscoSpark::Person.fetch(person_id)
    end

    def person_to
      CiscoSpark::Person.fetch(to_person_id)
    end
  end
end