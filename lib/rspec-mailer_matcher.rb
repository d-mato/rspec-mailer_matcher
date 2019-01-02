require 'mailer_matcher/version'
require 'action_mailer'

RSpec::Matchers.define :deliver do
  supports_block_expectations

  match do
    mail_keys = %i[to from subject]
    if actual.is_a?(Proc) && expected.is_a?(Hash) && (expected.keys - mail_keys).empty?
      deliveries = ActionMailer::Base.deliveries.clone
      actual.call
      new_deliveries = ActionMailer::Base.deliveries - deliveries

      expected_mail = new_deliveries.find { |mail|
        unless expected[:to].nil?
          matched = mail.to.include? expected[:to]
          next unless matched
        end
        unless expected[:subject].nil?
          matched = mail.subject == expected[:subject]
          next unless matched
        end
        unless expected[:from].nil?
          matched = mail.from.include? expected[:from]
          next unless matched
        end
        true
      }
      !expected_mail.nil?
    else
      false
    end
  end
end
