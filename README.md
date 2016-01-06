# SideloadSerializer

This is an adapter for [Active Model Serializers](https://github.com/rails-api/active_model_serializers) >= 0.10 intended to give a sideload JSON style similar to AMS 0.8.* embed approach with some alterations to conform to the [Rocketmade](http://rocketmade.com) API Standard.

It includes two forms of the adapter, the first serializes to the sideloaded format and the second alters all hash keys to camelCase.

Sideloaded json is extremely useful for offline sync situations where data is being loaded into coredata or other local storage. It helps reduce reparsing and transfer size by ensuring that each object is represented exactly once.

An authentication response from [Rockauth](https://github.com/rocketmade/rockauth) is used for the following examples.

Underscore Example:

```json
{
  "authentications": [
    {
      "id": 4,
      "token": "<jwt>",
      "token_id": "<jwt_id>",
      "expiration": 1483647326,
      "client_version": null,
      "device_identifier": null,
      "device_os": null,
      "device_os_version": null,
      "device_description": null,
      "user_id": 3,
      "provider_authentication_id": 1
    }
  ],
  "users": [
    {
      "id": 3,
      "email": null,
      "first_name": null,
      "last_name": null
    }
  ],
  "provider_authentications": [
    {
      "id": 1,
      "provider": "facebook",
      "provider_user_id": "avis"
    }
  ],
  "meta": {
    "primary_resource_collection": "authentications",
    "primary_resource_id": 4
  }
}
```

Camelized Example:

```json
{
  "authentications": [
    {
      "id": 8,
      "token": "<jwt>",
      "expiration": 1483647222,
      "tokenId": "<jwt_id>",
      "clientVersion": null,
      "deviceIdentifier": null,
      "deviceOs": null,
      "deviceOsVersion": null,
      "deviceDescription": null,
      "userId": 5,
      "providerAuthenticationId": 1
    }
  ],
  "users": [
    {
      "id": 5,
      "email": null,
      "firstName": null,
      "lastName": null
    }
  ],
  "providerAuthentications": [
    {
      "id": 1,
      "provider": "facebook",
      "providerUserId": "kendall_okuneva"
    }
  ],
  "meta": {
    "primaryResourceCollection": "authentications",
    "primaryResourceId": 8
  }
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sideload_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sideload_serializer

## Usage

Add the following line to `$RAILS_ROOT/config/initializers/active_model_serializers`

```
ActiveModelSerializers.config.adapter = "sideload_serializer/adapter"
```

Or, to use the camelized keys form of the adapter:

```
ActiveModelSerializers.config.adapter = "sideload_serializer/camelized_adapter"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rocketmade/sideload_serializer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
