require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'pdfkit'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ecej2016
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'America/Sao_Paulo'

    config.i18n.default_locale = :'pt-BR'

    config.assets.precompile =  [ '*.js', '*.scss']

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use PDFKit::Middleware, :print_media_type => true
    config.assets.initialize_on_precompile = false

    # Use this to join those files to the project
    Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
    Dir[File.join(Rails.root, "lib", "classes",  "*.rb")].each {|l| require l }
  end
end
