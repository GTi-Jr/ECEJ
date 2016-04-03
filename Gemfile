source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'

gem 'devise-i18n'

gem 'rufus-scheduler', '~> 3.1', '>= 3.1.10'
# gem for user avatar
gem 'carrierwave'

gem 'mini_magick', '3.8.0'

gem 'fog'

gem 'brazilian-rails'

gem 'wicked'

gem "pagseguro-oficial", "~> 2.4.0"

#gem 'rack-cors', :require => 'rack/cors'

gem 'browser'

gem 'airbrake', '~> 5.0'

gem 'pdfkit'
# Dependencia for wicked_pdf
gem 'wkhtmltopdf-binary'

gem 'google-analytics-rails', '1.0.0'

gem 'kaminari'

#gem for Windows development - comment in linux

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

gem 'bcrypt-ruby', '~> 3.0.0', :require => 'bcrypt'
gem 'bcrypt'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Testing
  gem 'rspec-rails', '~> 3.0'
  gem "factory_girl_rails", "~> 4.0"
  gem 'rubocop', require: false
  gem "bullet"
  gem "better_errors"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem "letter_opener"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'sendgrid'

end
