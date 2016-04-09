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

    def messages
      CiscoSpark::Message.fetch_all(room_id: id)
    end
  end
end