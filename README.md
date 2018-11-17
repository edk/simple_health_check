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

### Create an initializer
And use the following to configure your Rails app to run health checks.
```
SimpleHealthCheck::Configuration.mount_at = 'custom_path' # instead of the default /health endpoint

SimpleHealthCheck::Configuration.configure do |config|
  config.add_check SimpleHealthCheck::VersionCheck
  config.add_check SimpleHealthCheck::GenericCheck.new(service_name: 'TESTING', check_proc: -> { Time.now && :ok } )
end
```

To register a check, Pass in a `SimpleHealthCheck::` check class (listed below) to the configuration.
The class, or in some cases, an instance can also be passed in.

### Available checks:
Simple checks:
* `SimpleHealthCheck::BasicStatusCheck` - returns "status": 1
* `SimpleHealthCheck::VersionCheck` - reads from "VERSION" file. Change filename with `SimpleHealthCheck::Configuration.version_file = Rails.root.join('VERSION')`

* `SimpleHealthCheck::JsonFile` - much like the `VersionCheck`, however it reads a static json file and injects it into the returned status.

Checking connections to services often require an operation to trigger connections, since most efficient client libraries are lazily evaluated.  These check require a proc to be passed in.
* `SimpleHealthCheck::MysqlCheck`
* `SimpleHealthCheck::RedisCheck`
* `SimpleHealthCheck::S3Check`
* `SimpleHealthCheck::GenericCheck`
When configuring the check, pass in the service_name, which is used for the key in the json response, a proc to execute, and an optional flag, `hard_fail` to cause a non-ok check to set that status for the entire response code.

The proc is used to execute your check.  Ensure it is safe and doesn't cause lockups, etc.  The return value from the
proc is used to populate the value of the service check.

You can raise an exception to fail the check, or return a symbol of the http status code.  See the `MysqlCheck` source
for an example where multiple fields and types can be set on failure.
```
  config.add_check SimpleHealthCheck::GenericCheck.new(service_name: 'TESTING', check_proc: -> { Time.now }, hard_fail: true )
```

Derive new checks from `SimpleHealthCheck::Base` and write the `call` method.

The `/health` action returns an http code (:ok, or other code as determined by a check result).  In a Rails app,
the act of being able to render the action may be good enough to return `status: '1'`.
In some cases such as in ECS, you may want additional checks to not fail the entire action, as that would
cause the container to get killed.  Whether or not you'd want this depends on your situation, and can be configured
with the `hard_fail:` option.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edk/simple_health_check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleHealthCheck project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/edk/simple_health_check/blob/master/CODE_OF_CONDUCT.md).
