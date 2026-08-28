# frozen_string_literal: true

require_relative 'lib/mailer_matcher/version'

Gem::Specification.new do |spec|
  spec.name = 'rspec-mailer_matcher'
  spec.version = MailerMatcher::VERSION
  spec.authors = ['d-mato']
  spec.email = ['telnetstat@gmail.com']

  spec.summary = 'RSpec matcher for ActionMailer'
  spec.description = 'An RSpec matcher that asserts a block delivers an ' \
                     'ActionMailer message with the expected to, from or subject.'
  spec.homepage = 'https://github.com/d-mato/rspec-mailer_matcher'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).select do |f|
      f.start_with?('lib/') || %w[LICENSE.txt README.md].include?(f)
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'actionmailer', '>= 8.0'
  spec.add_dependency 'rspec-expectations', '>= 3.0'
end
