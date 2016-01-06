PagSeguro.configure do |config|
  config.token       = '19A7CA757C2D4857A079CBEF9A7A20EB'
  config.email       = 'rodrigotnoronha@outlook.com'
  config.environment = :sandbox # ou :sandbox. O padrão é production.
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
