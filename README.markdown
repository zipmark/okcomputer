[![Code Climate](https://codeclimate.com/github/sportngin/okcomputer.png)](https://codeclimate.com/github/sportngin/okcomputer)
[![Build Status](https://travis-ci.org/sportngin/okcomputer.png)](https://travis-ci.org/sportngin/okcomputer)
[![Coverage Status](https://coveralls.io/repos/sportngin/okcomputer/badge.png?branch=master)](https://coveralls.io/r/sportngin/okcomputer)

# OK Computer

Inspired by the ease of installing and setting up [fitter-happier] as a Rails
application's health check, but frustrated by its lack of flexibility, OK
Computer was born. It provides a robust endpoint to perform server health
checks with a set of built-in plugins, as well as a simple interface to add
your own custom checks.

For more insight into why we built this, check out [our blog post introducing
OK Computer][blog].

[blog]:http://pulse.sportngin.com/news_article/show/267646?referrer_id=543230

## Installation

Add this line to your application's Gemfile:

    gem 'okcomputer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install okcomputer

## Usage

To perform the default checks (application running and ActiveRecord database
connection), do nothing other than adding to your application's Gemfile.

### If Not Using ActiveRecord

We also include a MongoidCheck, but do not register it. If you use Mongoid,
replace the default ActiveRecord check like so:

```ruby
OkComputer::Registry.register "database", OkComputer::MongoidCheck.new
```

If you use another database adapter, see Registering Custom Checks below to
build your own database check and register it with the name "database" to
replace the built-in check, or use `OkComputer::Registry.deregister "database"`
to stop checking your database altogether.

### Requiring Authentication

Optionally require HTTP Basic authentication to view the results of checks in an initializer, like so:

```ruby
# config/initializers/okcomputer.rb
OkComputer.require_authentication("username", "password")
```

To allow access to specific checks without a password, optionally specify the names of the checks:

```ruby
# config/initializers/okcomputer.rb
OkComputer.require_authentication("username", "password", except: %w(default nonsecret))
```

### Changing the OkComputer Route

By default, OkComputer routes are mounted at `/okcomputer`. If you'd like to use an alternate route,
you can configure it with:

```ruby
# config/initializers/okcomputer.rb
OkComputer.mount_at = 'health_checks'    # mounts at /health_checks
```

For more control of adding OkComputer to your routes, set `OkComputer.mount_at
= false` to disable automatic mounting, and you can manually mount the engine
in your `routes.rb`.

```ruby
# config/initializers/okcomputer.rb
OkComputer.mount_at = false

# config/routes.rb, at any priority that suits you
mount OkComputer::Engine, at: "/custom_path"
```

### Registering Additional Checks

Register additional checks in an initializer, like so:

```ruby
# config/initializers/okcomputer.rb
OkComputer::Registry.register "resque_down", OkComputer::ResqueDownCheck.new
OkComputer::Registry.register "resque_backed_up", OkComputer::ResqueBackedUpCheck.new("critical", 100)
```

### Registering Custom Checks

The simplest way to register a check unique to your application is to subclass
OkComputer::Check and implement your own `#check` method, which sets the
display message with `mark_message`, and calls `mark_failure` if anything is
wrong.

```ruby
# config/initializers/okcomputer.rb
class MyCustomCheck < OkComputer::Check
  def check
    if rand(10).even?
      mark_message "Even is great!"
    else
      mark_failure
      mark_message "We don't like odd numbers"
    end
  end
end

OkComputer::Registry.register "check_for_odds", MyCustomCheck.new
```

## Performing Checks

* Perform a simple up check: http://example.com/okcomputer
* Perform all installed checks: http://example.com/okcomputer/all
* Perform a specific installed check: http://example.com/okcomputer/database

Checks are available as plain text (by default) or JSON by appending .json, e.g.:
* http://example.com/okcomputer.json
* http://example.com/okcomputer/all.json

## OkComputer NewRelic Ignore

If NewRelic is installed, OkComputer automatically disables NewRelic monitoring for uptime checks,
as it will start to artificially bring your request time down.

If you'd like to intentionally count OkComputer requests in your NewRelic analytics, set:

```
# config/initializers/okcomputer.rb
OkComputer.analytics_ignore = false
```

## Deprecations and Breaking Changes

#### Namespace change from `OKComputer` to `OkComputer`

OkComputer has changed its namespace from `OKComputer` (uppercase K) to `OkComputer` (lowercase k)
as of version 0.7.0. Please update your configuration accordingly.

#### Breaking Changes of JSON Output

Versions before 0.6.0 did not include whether a given check succeeded.

**before 0.6.0**
```json
{"check": "result"}
```

**after 0.6.0**
```json
{"check": {"message": "result", "success": true}
```

Versions before 0.3.0, when performing multiple checks, returned an Array of
the check results, each being a JSON object. Starting with 0.3.0, these are
combined into a single JSON object with each check having its own key. For
example:

**before 0.3.0**
```json
[{"check": "result"}, {"other": "result"}]
```

**0.3.0 and above**
```json
{"check": "result", "other": "result"}
```

#### Deprecation of Check#call

Versions before 0.2.0 implemented a "#call" method which returned the message.
This was deprecated at the time and removed in 1.0.0. Please define a #check
method which calls `mark_failure` and `mark_message` as appropriate.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[fitter-happier]:https://rubygems.org/gems/fitter-happier

