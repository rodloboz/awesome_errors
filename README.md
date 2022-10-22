# AwesomeErrors

Easily add errors to your service objects and classes. `AwesomeErrors` is inspired by the `ActiveModel::Errors` API, but ensures that each error contains an error `code` attribute and is not concerned with translating error messages.

## Installation

Install from RubyGems by adding it to your `Gemfile`, then bundling.

```ruby
# Gemfile
gem 'awesome_errors'
```

## Usage

Include `AwesomeErrors` in your class:

```ruby
class ApplicationService
  include AwesomeErrors

  # ...
end

service = ApplicationService.new
service.errors # => []
```

or set up the errors object manually

```ruby
class ApplicationService
    def errors
      @errors ||= AwesomeErrors::Errors.new
    end
  # ...
end

service = ApplicationService.new
service.errors # => []
```

By default, errors are added with the an `:invalid` code and `"is invalid"` message:

```ruby
errors = AwesomeErrors::Errors.new
errors.add(:name)
errors.first.key # => :name
errors.first.code # => :invalid
errors.first.message # => "is invalid"
```

But you can specify a custom `code`, `message` and `metadata`

```ruby
errors = AwesomeErrors::Errors.new
errors.add(:name, code: :too_long, message: "is too long", metadata: { line: 1, column: 6 })
errors.first.key # => :name
errors.first.code # => :too_long
errors.first.message # => "is too long"
errors.first.metadata # => { line: 1, column: 6 }
```

## Example

```ruby
class SendApiRequest
    include AwesomeErrors

    def call
        if api_response.success?
          # do something
        else
            errors.add(:api, code: :failed_request, message: "failed request")
        end
    end
end
```

## Why this gem?

I have used `ActiveModel::Errors` in many service objects and Ruby classes and enjoy its API, but often I am forced to add methods related to the translation of messages that I wouldn't need. Also, `ActiveModel::Errors` allows you to add errors where the message will be used as the error `type`, and I wanted to ensure a more consistent experience of always having an error `code` that is `Symbol` or an `Integer` so that services and objects can exchange errors while being able to rely on the `code` to better construct a user-facing error message.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rodloboz/awesome_errors.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
