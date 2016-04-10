require "cisco_spark/model"

module CiscoSpark
  class Room
    include Model
    resource 'rooms'

    attributes(
      id: DataCaster::String,
      title: DataCaster::String,
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

    def memberships(options={})
      options[:room_id] = id
      CiscoSpark::Membership.fetch_all(options)
    end

    def send_message(message)
      message.room_id = id
      message.persit
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