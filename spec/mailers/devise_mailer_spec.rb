require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  describe 'email changed notification email' do
    let(:user) { create(:user) }
    let(:mail) { Devise::Mailer.email_changed(user) }

    it "sends a notification email to theuser's email address" do
      expect(mail.to).to eq [user.email]
    end

    it "sends from the email address for transmission" do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.email_changed.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.email_changed.greeting', recipient: user.email)
    end

    it 'has appropriate body text' do
      expect(mail.body).to have_text t('users.mailer.email_changed.message', email: user.email)
    end
  end

  describe 'password change instruction email'
end
