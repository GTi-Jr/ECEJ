PagSeguro.configure do |config|
  if Rails.env.production?
    config.environment = :production
    config.token       = ENV['PAGSEGURO_TOKEN']
    config.email       = ENV['PAGSEGURO_EMAIL']
  else
    config.environment = :sandbox # ou :sandbox. O padrão é production.
    config.token       = Rails.application.secrets.pag_seguro_token
    config.email       = Rails.application.secrets.pag_seguro_email

  end
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
