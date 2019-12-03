source 'https://rubygems.org'

gem 'rails',                  '4.2.2'
gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails',             '~> 5.0'
gem 'uglifier',               '>= 1.3.0'
gem 'coffee-rails',           '~> 4.1.0'
gem 'jbuilder',               '~> 2.0'
gem 'simple_form',            '~> 3.2'
gem 'bootstrap-sass',         '~> 3.3.5'
gem 'devise',                 '~> 3.5', '>= 3.5.2'
gem 'haml-rails',             '~> 0.9'
gem 'dotenv-rails',           '~> 2.0.2'
gem 'roo',                    '~> 2.2'
gem 'fog'
gem 's3'
gem 'ffaker',                 '~> 2.1.0'
gem 'draper',                 '~> 2.1'
gem 'datagrid',               '~> 1.4.2'
gem 'active_model_serializers'
gem 'sinatra',                require: false
gem 'rack-cors',              require: 'rack/cors'
gem 'rails-erd'
gem 'phony_rails',            '~> 0.12.11'
gem 'typhoeus'
gem 'foreman',                '~> 0.78.0'
gem 'cancancan',              '~> 1.13', '>= 1.13.1'
gem 'pundit',                 '~> 1.1'
gem 'tinymce-rails',          '~> 4.5.6'
gem 'bootstrap-datepicker-rails', '~> 1.5'

#select2-rails gem is modified in select2.js using gem open to config its dropdown behaviour to only dropdown below
#change enoughRoomAbove = (offset.top - dropHeight) >= $window.scrollTop() to enoughRoomAbove = false,
gem 'select2-rails',          '~> 3.5.9.3'
gem 'devise_token_auth',      '~> 0.1.37'
gem 'omniauth',               '~> 1.3', '>= 1.3.1'
gem 'jquery-validation-rails'
gem 'google-api-client',      '~> 0.10', require: 'google/apis/calendar_v3'
gem 'fullcalendar-rails',     '~> 3.2.0.0'
gem 'momentjs-rails',         '~> 2.17.1'
gem 'kaminari'
gem 'jquery-datatables-rails', '~> 3.4'
gem 'friendly_id',            '~> 5.1.0'
gem 'wicked_pdf',             '~> 1.0', '>= 1.0.6'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
gem 'browser',                '~> 2.1'
gem 'whenever',               '~> 0.9.4'
gem 'thredded',               '~> 0.6.1'
gem 'cocoon',                 '~> 1.2', '>= 1.2.9'
gem 'paper_trail',            '~> 5.2'
gem 'carrierwave',            '~> 1.1.0'
gem 'mini_magick',            '~> 4.5'
gem 'chartkick',              '~> 3.3'
gem 'font-awesome-rails',     '~> 4.7'
gem 'spreadsheet',            '~> 1.1.3'
gem 'apartment',              '~> 1.2'
gem 'dropzonejs-rails',       '~> 0.7.3'
gem 'bourbon',                '~> 4.2'
gem 'neat',                   '~> 1.8'
gem 'sidekiq',                '~> 4.1.0'
gem 'mongoid',                '~> 5.2', '>= 5.2.1'
gem 'where-or',               '~> 0.1.6'
gem 'dotiw',                  '~> 4.0.1'
gem 'text',                   '~> 1.3', '>= 1.3.1'
gem 'acts_as_paranoid',       '~> 0.6.1'
gem 'ancestry',               '~> 3.0', '>= 3.0.5'
gem 'sysrandom',              '~> 1.0', '>= 1.0.5'
gem 'ulid',                   '~> 1.1'
gem 'write_xlsx',             '~> 0.85.7'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails',          '~> 3.4'
  gem 'factory_girl_rails',   '~> 4.5'
  gem 'launchy',              '~> 2.4', '>= 2.4.3'
  gem 'capybara',             '~> 2.15.4'
  gem 'poltergeist',          '~> 1.9.0'
  gem 'shoulda-whenever',     '~> 0.0.2'
  gem 'bullet',               '~> 5.4', '>= 5.4.3'
  gem 'mongoid-rspec',        '~> 3.0'
  gem 'thin',                 '~> 1.7'
end

group :staging, :demo, :production do
  gem 'appsignal', '~> 1.1.9'
  gem 'asset_sync'
end

group :staging, :demo do
  gem 'mail_interceptor', '~> 0.0.7'
end

group :development do
  gem 'letter_opener',        '~> 1.4.1'
  gem 'letter_opener_web',    '~> 1.3', '>= 1.3.4'
  gem 'rubocop',              '~> 0.47.1', require: false
  gem 'capistrano',           '3.9.0'
  gem 'capistrano-rails',     '~> 1.1.1'
  gem 'capistrano-passenger', '~> 0.1.1'
  gem 'capistrano-rvm',       '~> 0.1.2'
  gem 'capistrano-sidekiq',   github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-foreman'
  gem 'rack-mini-profiler', '~> 1.0'
end

group :test do
  gem 'database_cleaner',     '~> 1.5', '>= 1.5.1'
  gem 'guard-rspec',          '~> 4.6'
  gem 'json_spec',            '~> 1.1', '>= 1.1.4'
  gem 'shoulda-matchers'
  gem 'rspec-sidekiq'
  gem 'rspec-activemodel-mocks'
  gem 'timecop',              '~> 0.8.1'
end
