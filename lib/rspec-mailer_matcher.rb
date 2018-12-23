require 'mailer_matcher/version'

RSpec::Matchers.define :deliver do
  supports_block_expectations

  match do
    mail_keys = %i[to from subject]
    if actual.is_a?(Proc) && expected.is_a?(Hash) && (expected.keys - mail_keys).blank?
      deliveries = ActionMailer::Base.deliveries.clone
      actual.call
      new_deliveries = ActionMailer::Base.deliveries - deliveries

      expected_mail = new_deliveries.find { |mail|
        matched = true
        if expected[:to].present?
          matched = mail.to.include? expected[:to]
        end
        if expected[:subject].present?
          matched = mail.subject == expected[:subject]
        end
        if expected[:from].present?
          matched = mail.from.include? expected[:from]
        end
        matched
      }
      expected_mail.present?
    else
      false
    end
  end
end
