module MailerSupport
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def last_email_body
    last_email.body.encoded
  end

  def last_sent_url
    URI.extract(last_email_body).first
  end
end

RSpec.configure do |config|
  config.include MailerSupport
end
