require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  describe 'confirmation_instructions email' do
    let(:user) { create(:user) }
    let(:token) { Devise.friendly_token }
    let(:mail) { Devise::Mailer.confirmation_instructions(user, token) }

    it "sends a notification email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.confirmation_instructions.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.confirmation_instructions.greeting', recipient: user.email)
    end

    it 'has appropriate body text', :aggregate_failures do
      expect(mail.body).to have_text t('users.mailer.confirmation_instructions.instruction')
      expect(mail.body).to have_link href: user_confirmation_url(confirmation_token: token)
    end
  end

  describe 'reset_password_instructions email' do
    let(:user) { create(:user) }
    let(:token) { Devise.token_generator.generate(User, :reset_password_token).first }
    let(:mail) { Devise::Mailer.reset_password_instructions(user, token) }

    it "sends a notification email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.reset_password_instructions.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.reset_password_instructions.greeting', recipient: user.email)
    end

    it 'has appropriate body text', :aggregate_failures do
      expect(mail.body).to have_text t('users.mailer.reset_password_instructions.instruction')
      expect(mail.body).to have_text t('users.mailer.reset_password_instructions.instruction_2')
      expect(mail.body).to have_text t('users.mailer.reset_password_instructions.instruction_3')
      expect(mail.body).to have_link href: edit_user_password_url(reset_password_token: token)
    end
  end

  describe 'unlock_instructions email' do
    let(:user) { create(:user) }
    let(:token) { Devise.token_generator.generate(User, :unlock_token).first }
    let(:mail) { Devise::Mailer.unlock_instructions(user, token) }

    it "sends a notification email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.unlock_instructions.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.unlock_instructions.greeting', recipient: user.email)
    end

    it 'has appropriate body text', :aggregate_failures do
      expect(mail.body).to have_text t('users.mailer.unlock_instructions.message')
      expect(mail.body).to have_text t('users.mailer.unlock_instructions.instruction')
      expect(mail.body).to have_link href: user_unlock_url(unlock_token: token)
    end
  end

  describe 'email_changed notification email' do
    let(:user) { create(:user) }
    let(:mail) { Devise::Mailer.email_changed(user) }

    it "sends a notification email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
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

  describe 'password_change notification email' do
    let(:user) { create(:user) }
    let(:mail) { Devise::Mailer.password_change(user) }

    it "sends a instruction email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.password_change.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.password_change.greeting', recipient: user.email)
    end

    it 'has appropriate body text' do
      expect(mail.body).to have_text t('users.mailer.password_change.message')
    end
  end
end
