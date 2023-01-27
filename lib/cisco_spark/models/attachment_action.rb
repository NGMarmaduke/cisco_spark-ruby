require "cisco_spark/model"

module CiscoSpark
  class AttachmentAction
    include Model
    resource 'attachment/actions'

    attributes(
      id: DataCaster::String,
      type: DataCaster::String,
      messageId: DataCaster::String,
      inputs: DataCaster::Hash,
      personId: DataCaster::String,
      roomId: DataCaster::String,
      created: DataCaster::DateTime
    )

    def person
      CiscoSpark::Person.fetch(person_id)
    end
  end
end
