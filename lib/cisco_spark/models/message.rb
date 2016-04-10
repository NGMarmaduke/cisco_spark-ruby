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

    def self.all_before_message(messsage, options={})
      id = message.is_a?(CiscoSpark::Message) ? message.id : message
      options[:before_message] = id
      self.fetch_all(options)
    end

    def self.all_before(date, options={})
      if date.is_a?(DateTime)
        date = date.to_time.iso8601
      end

      options[:before] = date
      self.fetch_all(before_message: id)
    end
  end
end