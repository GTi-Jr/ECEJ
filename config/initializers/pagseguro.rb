PagSeguro.configure do |config|
  config.token       = ENV['PAGSEGURO_TOKEN']
  config.email       = ENV['PAGSEGURO_EMAIL']
  if Rails.env.production?
    config.environment = :production
  else
    config.environment = :sandbox # ou :sandbox. O padrão é production.
  end
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
