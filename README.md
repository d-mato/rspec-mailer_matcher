# rspec-mailer_matcher

[![Gem Version](https://img.shields.io/gem/v/rspec-mailer_matcher)](https://rubygems.org/gems/rspec-mailer_matcher)
[![Test](https://github.com/d-mato/rspec-mailer_matcher/actions/workflows/test.yml/badge.svg)](https://github.com/d-mato/rspec-mailer_matcher/actions/workflows/test.yml)

An RSpec matcher that asserts a block delivers an ActionMailer message.

## Installation

```console
$ bundle add rspec-mailer_matcher --group test
```

## Usage

Require the gem from `spec_helper.rb` or `rails_helper.rb`:

```ruby
require 'rspec-mailer_matcher'
```

`deliver` then matches against the mail a block sends:

```ruby
it 'emails the new user' do
  expect { SignUp.call(email: 'user@example.org') }
    .to deliver to: 'user@example.org', subject: 'Welcome'
end
```

It works with a `subject` block too:

```ruby
subject { proc { SignUp.call(email: 'user@example.org') } }

it { is_expected.to deliver to: 'user@example.org' }
```

### Keys

`to`, `from` and `subject`. `to` and `from` match when the address is among the
recipients or the senders; `subject` has to be equal. Any other key raises
`ArgumentError` rather than failing to match, so a typo cannot turn a `not_to`
expectation green.

Every key given has to match the same mail, and the expectation passes when the
block delivered at least one such mail.

When it fails, the matcher reports what the block delivered instead:

```
expected the block to deliver a mail with to: "carol@example.org", but the block delivered:
  to: ["alice@example.org"], from: ["app@example.org"], subject: "Welcome"
```

Delivery is read from `ActionMailer::Base.deliveries`, so the block has to
deliver during the example. Mail enqueued with `deliver_later` is not seen
unless the job runs inline.

## Requirements

Ruby 3.3 or newer, ActionMailer 8.0 or newer. The combinations covered by CI
are listed in
[test.yml](https://github.com/d-mato/rspec-mailer_matcher/blob/master/.github/workflows/test.yml).

## Development

```console
$ bin/setup            # install dependencies
$ bundle exec rake     # specs and RuboCop
$ bin/console          # IRB with the gem loaded
```

To run against one ActionMailer series:

```console
$ BUNDLE_GEMFILE=gemfiles/actionmailer_8.0.gemfile bundle exec rake
```

## Releasing

Run the
[Release workflow](https://github.com/d-mato/rspec-mailer_matcher/actions/workflows/release.yml)
and choose a bump. It updates `version.rb`, tags and pushes, publishes a GitHub
release, and pushes the gem to RubyGems.org through trusted publishing.

## Contributing

Bug reports and pull requests are welcome at
https://github.com/d-mato/rspec-mailer_matcher.

## License

Available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
