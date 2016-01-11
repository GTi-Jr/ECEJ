PagSeguro.configure do |config|
  config.token       = Rails.application.secrets.pag_seguro_token
  config.email       = Rails.application.secrets.pag_seguro_email
  if Rails.env.productio?
    config.environment = :production
  else
    config.environment = :sandbox # ou :sandbox. O padrão é production.
  end
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
