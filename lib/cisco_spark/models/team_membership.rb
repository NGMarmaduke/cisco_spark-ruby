require "cisco_spark/model"

module CiscoSpark
  class TeamMembership
    include Model
    resource 'team/memberships'

    attributes(
      id: DataCaster::String,
      team_id: DataCaster::String,
      person_id: DataCaster::String,
      person_email: DataCaster::String,
      is_moderator: DataCaster::Boolean,
      created: DataCaster::DateTime,
    )
    mutable_attributes :is_moderator

    def person
      CiscoSpark::Person.fetch(person_id)
    end

    def team
      CiscoSpark::Team.fetch(team_id)
    end
  end
end
