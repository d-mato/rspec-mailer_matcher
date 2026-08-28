# frozen_string_literal: true

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

    describe 'invalid usage' do
      it 'rejects an unknown key' do
        expect { expect(subject).to deliver cc: 'cc@example.org' }
          .to raise_error(ArgumentError, /unknown key :cc/)
      end

      it 'rejects an unknown key when negated' do
        expect { expect(subject).not_to deliver cc: 'cc@example.org' }
          .to raise_error(ArgumentError, /unknown key :cc/)
      end

      it 'rejects a subject that is not a block' do
        expect { expect(ActionMailer::Base.deliveries).to deliver to: 'to@example.org' }
          .to raise_error(ArgumentError, /expected a block/)
      end

      it 'rejects being called without keywords' do
        expect { expect(subject).to deliver }
          .to raise_error(ArgumentError, /expected keywords/)
      end
    end

    describe 'failure messages' do
      it 'lists what was delivered instead' do
        expect { expect(subject).to deliver to: 'nobody@example.org' }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError,
                          /to: \["to@example\.org"\], from: \["from@example\.org"\], subject: "Hello world"/)
      end

      it 'says so when nothing was delivered' do
        expect { expect(proc {}).to deliver to: 'to@example.org' }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, /nothing was delivered/)
      end

      it 'names the criteria when negated' do
        expect { expect(subject).not_to deliver to: 'to@example.org' }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError,
                          /not to deliver a mail with to: "to@example\.org"/)
      end
    end
  end
end
