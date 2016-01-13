class ApplicationMailer < ActionMailer::Base
  include SendGrid if Rails.env.production?
  default from: "ecej@ecej2016.com"
  layout 'mailer'
end
