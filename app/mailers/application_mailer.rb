class ApplicationMailer < ActionMailer::Base
  include SendGrid
  default from: "ecej@ecej2016.com"
  layout 'mailer'
end
