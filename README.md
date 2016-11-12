# CiscoSpark
[![Build Status](https://travis-ci.org/NGMarmaduke/cisco_spark-ruby.svg?branch=master)](https://travis-ci.org/NGMarmaduke/cisco_spark-ruby)
[![Coverage Status](https://coveralls.io/repos/github/NGMarmaduke/cisco_spark-ruby/badge.svg?branch=master)](https://coveralls.io/github/NGMarmaduke/cisco_spark-ruby?branch=master)

Ruby client for [Cisco Spark](https://developer.ciscospark.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cisco_spark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cisco_spark

## Usage

### Configuration
Configuration can be done in an initializer on app boot.
An API key or users OAuth token is required to make any API requests.

API key example:
```ruby
CiscoSpark.configure do |config|
  config.api_key = 'YOUR KEY'
end
```

If you are using OAuth token you can wrap API operaions in a block, all API calls within the block will then use that token.

OAuth token example:
```ruby
CiscoSpark.with_token('OAuth token') do
  users_rooms = CiscoSpark::Room.fetch_all
end
```

### Models
All models have methods to interact with the API and parse response data.

Inlcuded models:
- `CiscoSpark::Person`
- `CiscoSpark::Room`
- `CiscoSpark::Membership`
- `CiscoSpark::Message`
- `CiscoSpark::Team`
- `CiscoSpark::TeamMembership`
- `CiscoSpark::Webhook`

You can call all the following methods on any of these models

###### `class.fetch_all`
Fetches all records for a given model, returns a `CiscoSpark::Collection`
Accepts any parameters that the API allows.

```ruby
rooms = CiscoSpark::Room.fetch_all(max: 5)
=> #<CiscoSpark::Collection>
```

###### `class.fetch`
Fetches a single record for the given resource ID, returns an instance
Accepts any parameters that the API allows.

```ruby
room = CiscoSpark::Room.fetch('Y2lzY...', show_sip_address: true)
=> #<CiscoSpark::Room>
```

###### `class.create`
Creates a resource with given attribues, returns an instance
Accepts any parameters that the API allows.

```ruby
room = CiscoSpark::Room.create(title: 'Ruby Room')
=> #<CiscoSpark::Room>
```

###### `class.update`
Updates a resource with given attribues, returns an instance
Accepts any parameters that the API allows.

```ruby
room = CiscoSpark::Room.update('Y2lzY...', title: 'Groovey Ruby Room')
=> #<CiscoSpark::Room>
```

###### `class.destroy`
Destroys a resource with the given ID, returns an boolean to indicate success
Accepts any parameters that the API allows.

```ruby
room = CiscoSpark::Room.destroy('Y2lzY...')
=> true
```

###### `class.parse_collection`
Parses a valid JSON string or a ruby hash/array into a collection of models.
This is useful for processing data recieved from a webhook etc.

```ruby
json_string = '{"items": [{ "id": "Y2lzY...", "key": "value" }]}'
rooms = CiscoSpark::Room.parse_collection(json_string)
=> #<CiscoSpark::Collection>
```

###### `class.parse`
Parses a valid JSON string or a ruby hash/array into a model.
This is useful for processing data recieved from a webhook etc.

```ruby
json_string = '{ "id": "Y2lzY...", "key": "value" }'
room = CiscoSpark::Room.parse(json_string)
=> #<CiscoSpark::Room>
```

###### `class.new`
Creates a new instance of the model with given attributes

```ruby
room = CiscoSpark::Room.new(title: 'New room')
=> #<CiscoSpark::Room>
```

###### `instance.persist`
You can call persist on an instance to create or update it through the API.
If the instance already has an ID a `PUT` will be made to update the mutable attributes

```ruby
room = CiscoSpark::Room.new(title: 'New room')
room.persist
=> #<CiscoSpark::Room>
```

###### `instance.fetch`
You can call fetch on an instance fetch or refresh an instance

```ruby
room = CiscoSpark::Room.new(id: 'Y2lzY...')
room.fetch
=> #<CiscoSpark::Room>
```

###### `instance.destroy`
You can call destroy on an instance to destroy it through the API

```ruby
room = CiscoSpark::Room.new(id: 'Y2lzY...')
room.destroy
=> true
```

###### `instance.to_h`
Convert a model instance into a hash

```ruby
room = CiscoSpark::Room.fetch('Y2lzY...')
room.to_h
=> Hash
```

##### `CiscoSpark::Person`
[API reference](https://developer.ciscospark.com/resource-people.html)

###### `CiscoSpark::Person.all_by_email`
Search all people by email,

```ruby
people = CiscoSpark::Person.all_by_email('nickpmaher@gmail.com', max: 5)
=> #<CiscoSpark::Collection>
```

###### `CiscoSpark::Person.all_by_name`
Search all people by display name

```ruby
people = CiscoSpark::Person.all_by_name('Nick', max: 5)
=> #<CiscoSpark::Collection>
```

###### `#memberships`
Get all memberships for person

```ruby
person = CiscoSpark::Person.new(id: 'Y2lz...')
person.memberships(max: 5)
=> #<CiscoSpark::Collection>
```

##### `CiscoSpark::Room`
[API reference](https://developer.ciscospark.com/resource-rooms.html)

###### `#memberships`
Get all memberships for room

```ruby
room = CiscoSpark::Room.new(id: 'Y3de...')
room.memberships(max: 5)
=> #<CiscoSpark::Collection>
```

###### `#messages`
Get all messages for room

```ruby
room = CiscoSpark::Room.new(id: 'Y3de...')
room.messages(max: 5)
=> #<CiscoSpark::Collection>
```

###### `#messages_before_message`
Get all message before a given message, accepts a `CiscoSpark::Message` or a message ID

```ruby
room.all_before_message('Y3de...', max: 5)
=> #<CiscoSpark::Collection>
```

###### `#messages_before`
Get all message before a given time, accepts a `DateTime` or a string

```ruby
room.messages_before(DateTime.now, max: 5)
=> #<CiscoSpark::Collection>
```

###### `#send_message`
Send a message to the room

```ruby
message = CiscoSpark::Message.new(text: 'Hello Spark')

room = CiscoSpark::Room.new(id: 'Y3de...')
room.send_message(message)
=> #<CiscoSpark::Message>
```

###### `#add_person`
Creates a new membership to the room for a given person

```ruby
person = CiscoSpark::Person.fetch('Y2lz')

room = CiscoSpark::Room.new(id: 'Y3de...')
room.add_person(person)
=> #<CiscoSpark::Membership>
```

##### `CiscoSpark::Membership`
[API reference](https://developer.ciscospark.com/resource-memberships.html)

###### `#person`
Returns the person for this membership

###### `#room`
Returns the room this membership belongs to

##### `CiscoSpark::Message`
[API reference](https://developer.ciscospark.com/resource-messages.html)

###### `#person`
Returns the person that sent this message

###### `#person_to`
Returns the person that the message was sent to

##### `CiscoSpark::Team`
[API reference](https://developer.ciscospark.com/resource-teams.html)

###### `#memberships`
Get all memberships for team

```ruby
team = CiscoSpark::Team.new(id: 'Y3de...')
team.memberships(max: 5)
=> #<CiscoSpark::Collection>
```

###### `#add_person`
Creates a new membership to the team for a given person

```ruby
person = CiscoSpark::Person.fetch('Y2lz')

team = CiscoSpark::Team.new(id: 'Y3de...')
team.add_person(person)
=> #<CiscoSpark::TeamMembership>
```

##### `CiscoSpark::TeamMembership`
[API reference](https://developer.ciscospark.com/resource-team-memberships.html)

###### `#person`
Returns the person for this membership

###### `#team`
Returns the team this membership belongs to

##### `CiscoSpark::Webhook`
[API reference](https://developer.ciscospark.com/resource-webhooks.html)

### `CiscoSpark::Collection`
Wraps a collection of models. Responds to all enumerable methods e.g. `first`, `map`, `each` etc...

Call `next` on a collection to load the next page of data

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NGMarmaduke/cisco_spark-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
