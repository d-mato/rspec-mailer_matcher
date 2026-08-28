# frozen_string_literal: true

require 'mailer_matcher/version'
require 'action_mailer'
require 'rspec/expectations'

RSpec::Matchers.define :deliver do
  supports_block_expectations

  match do |block|
    raise ArgumentError, "expected a block, got #{block.inspect}" unless block.respond_to?(:call)

    unless expected.is_a?(Hash) && !expected.empty?
      raise ArgumentError, "expected keywords, for example deliver(to: 'user@example.org')"
    end

    unknown = expected.keys - supported_keys
    unless unknown.empty?
      raise ArgumentError, "unknown #{unknown.size > 1 ? 'keys' : 'key'} " \
                           "#{unknown.map(&:inspect).join(', ')}, " \
                           "expected any of #{supported_keys.map(&:inspect).join(', ')}"
    end

    @delivered = capture_deliveries(&block)
    @delivered.any? { |mail| delivered_as_expected?(mail) }
  end

  failure_message do
    "expected the block to deliver a mail with #{criteria}, but #{delivered_summary}"
  end

  failure_message_when_negated do
    "expected the block not to deliver a mail with #{criteria}, but #{delivered_summary}"
  end

  description do
    "deliver a mail with #{criteria}"
  end

  def supported_keys
    %i[to from subject]
  end

  def capture_deliveries
    already_delivered = ActionMailer::Base.deliveries.dup
    yield
    ActionMailer::Base.deliveries - already_delivered
  end

  def delivered_as_expected?(mail)
    expected.all? do |key, value|
      key == :subject ? mail.subject == value : Array(mail.public_send(key)).include?(value)
    end
  end

  def criteria
    expected.map { |key, value| "#{key}: #{value.inspect}" }.join(', ')
  end

  def delivered_summary
    return 'nothing was delivered' if @delivered.empty?

    lines = @delivered.map do |mail|
      "  to: #{mail.to.inspect}, from: #{mail.from.inspect}, subject: #{mail.subject.inspect}"
    end
    "the block delivered:\n#{lines.join("\n")}"
  end
end
