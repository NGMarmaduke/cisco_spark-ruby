require "cisco_spark/model"

module CiscoSpark
  class Room
    include Model
    resource 'rooms'

    attributes(
      id: DataCaster::String,
      title: DataCaster::String,
      type: DataCaster::String,
      owner_id: DataCaster::String,
      created: DataCaster::DateTime,
      last_activity: DataCaster::DateTime,
      is_locked: DataCaster::Boolean,
      sip_address: DataCaster::String
    )
    mutable_attributes :title

    def messages(options={})
      options[:room_id] = id
      CiscoSpark::Message.fetch_all(options)
    end

    def messages_before_message(message, options={})
      message_id = message.is_a?(CiscoSpark::Message) ? message.id : message
      options[:before_message] = message_id
      options[:room_id] = id
      CiscoSpark::Message.fetch_all(options)
    end

    def messages_before(date, options={})
      if date.is_a?(DateTime)
        date = date.to_time.iso8601
      end
      options[:room_id] = id
      options[:before] = date
      CiscoSpark::Message.fetch_all(options)
    end

    def memberships(options={})
      options[:room_id] = id
      CiscoSpark::Membership.fetch_all(options)
    end

    def send_message(message)
      message.room_id = id
      message.persist
    end

    def add_person(person, options={})
      CiscoSpark::Membership.new(
        room_id: id,
        person_id: person.id,
        is_moderator: options.fetch(:is_moderator, false),
        is_monitor: options.fetch(:is_monitor, false),
      ).persist
    end
  end
end
