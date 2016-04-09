require "cisco_spark/model"

module CiscoSpark
  class Membership
    include Model
    resource 'memberships'

    attributes(
      id: DataCaster::String,
      person_id: DataCaster::String,
      person_email: DataCaster::String,
      person_display_name: DataCaster::String,
      room_id: DataCaster::String,
      is_moderator: DataCaster::Boolean,
      is_monitor: DataCaster::Boolean,
      created: DataCaster::DateTime,
    )

    def person
      CiscoSpark::Person.fetch(person_id)
    end

    def room
      CiscoSpark::Room.fetch(room_id)
    end
  end
end