PagSeguro.configure do |config|
  config.token       = Rails.application.secrets.pag_seguro_token
  config.email       = Rails.application.secrets.pag_seguro_email
  config.environment = :sandbox # ou :sandbox. O padrão é production.
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
