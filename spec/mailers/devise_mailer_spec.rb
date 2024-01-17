require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  xdescribe 'confirmation_instructions email'

  xdescribe 'reset_password_instructions email'

  xdescribe 'unlock_instructions email'

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

  xdescribe 'password_change instruction email' do
    let(:user) { create(:user) }
    let(:mail) { Devise::Mailer.password_change(user) }

    it "sends a instruction email to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from the email address for transmission' do
      expect(mail.from).to eq ['noreply@ococo.net']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq t('users.mailer.reset_password_instruction.subject')
    end

    it 'greets the user by email' do
      expect(mail.body).to have_text t('users.mailer.reset_password_instruction.greeting', recipient: user.email)
    end

    it 'has appropriate body text', :aggregate_failures do
      expect(mail.body).to have_text t('users.mailer.reset_password_instruction.instruction')
      expect(mail.body).to have_text t('users.mailer.reset_password_instruction.instruction_2')
      expect(mail.body).to have_text t('users.mailer.reset_password_instruction.instruction_3')
    end
  end
end
