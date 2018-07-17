# SimpleHealthCheck

A rails engine to return various checks in json format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_health_check'
```

And then execute:

    $ bundle

## Usage

### Creating an initializer
And use the following to configure.
```
# SimpleHealthCheck::Configuration.mount_at = 'custom_path'
# SimpleHealthCheck::Configuration.version_file = Rails.root.join('VERSION')
SimpleHealthCheck::Configuration.configure do |config|
  config.add_check SimpleHealthCheck::VersionCheck
end
```

### Adding new checks:
The default check:
* SimpleHealthCheck::BasicStatusCheck - returns "status": 1

Add more checks:
* SimpleHealthCheck::VersionCheck - reads from "VERSION" file or path with Configuration version_file =
* SimpleHealthCheck::MysqlCheck - wip
* SimpleHealthCheck::S3Check - wip
* SimpleHealthCheck::RedisCheck - wip

Derive new checks from `SimpleHealthCheck::Base` and write the `call` method.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edk/simple_health_check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleHealthCheck project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/edk/simple_health_check/blob/master/CODE_OF_CONDUCT.md).
