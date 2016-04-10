require "cisco_spark/model"

module CiscoSpark
  class Webhook
    include Model
    resource 'webhooks'

    attributes(
      id: DataCaster::String,
      name: DataCaster::String,
      target_url: DataCaster::String,
      resource: DataCaster::String,
      event: DataCaster::String,
      filter: DataCaster::String,
      created: DataCaster::DateTime,
    )
    mutable_attributes :name, :target_url

  end
end