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
      markdown: DataCaster::String,
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

    def file_content
      return unless files

      response = Api.new.get(files.first.split('/')[-2..-1].join('/'))
      response.header['content-disposition'][/filename="(.+)"/]

      {
        data: "data:application/octet-stream;base64,#{Base64.encode64(response.body)}",
        filename: Regexp.last_match(1)
      }
    end

  end
end
