RSpec.describe MailerMatcher do
  it 'has a version number' do
    expect(MailerMatcher::VERSION).not_to be nil
  end

  describe 'deliver' do
    subject {
      proc {
        mailer = ActionMailer::Base.new
        mailer.mail(to: 'to@example.org', from: 'from@example.org', subject: 'Hello world', body: '').deliver
      }
    }

    it { is_expected.to deliver to: 'to@example.org' }
    it { is_expected.to deliver from: 'from@example.org' }
    it { is_expected.to deliver subject: 'Hello world' }
    it { is_expected.to deliver to: 'to@example.org', from: 'from@example.org' }
    it { is_expected.to deliver to: 'to@example.org', subject: 'Hello world' }
    it { is_expected.to deliver from: 'from@example.org', subject: 'Hello world' }
    it { is_expected.to deliver to: 'to@example.org', from: 'from@example.org', subject: 'Hello world' }

    it { is_expected.not_to deliver to: 'nosent@example.org' }
    it { is_expected.not_to deliver from: 'nosent@example.org' }
    it { is_expected.not_to deliver subject: 'nosent' }
    it { is_expected.not_to deliver to: 'nosent@example.org', from: 'from@example.org', subject: 'Hello world' }
    it { is_expected.not_to deliver to: 'to@example.org', from: 'noesent@example.org', subject: 'Hello world' }
    it { is_expected.not_to deliver to: 'to@example.org', from: 'from@example.org', subject: 'nosent' }
  end
end
