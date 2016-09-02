class ApplicationMailer < ActionMailer::Base
  include SendGrid if Rails.env.production?
  default from: 'naoresponda@sistemaalmej2016.com.br'
  layout 'mailer'
end
