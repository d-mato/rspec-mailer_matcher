# MailerMatcher


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-mailer_matcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-mailer_matcher

## Usage

First of all, add the following line to your `spec_helper.rb` or `rails_helper.rb`:

```ruby
require 'rspec-mailer_matcher'
```

Then, you can use `deliver` matcher:

```ruby
it {
  expect { _any_action_ }.to deliver to: 'to@example.org', from: 'from@example.org', subject: 'Hello world'
}
```

or using `subject` block:

```ruby
subject {
  proc { _any_action_ }
}

it {
  is_expected.to deliver to: 'to@example.org', from: 'from@example.org', subject: 'Hello world'
}
```

## Development
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/d-mato/rspec-mailer_matcher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
