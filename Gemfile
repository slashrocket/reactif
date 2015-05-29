source 'https://rubygems.org'

gem 'rails'
gem 'sqlite3'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'sdoc', group: :doc
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'devise'
gem 'nokogiri'
gem 'httparty'
gem 'figaro'
gem 'redic' # gem to connect ohm to redis
gem 'ohm' # gem to use redis to store objects
gem 'active_model_serializers'
gem 'redis-throttle', git: 'git://github.com/andreareginato/redis-throttle.git'
group :production do
  gem 'pg'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'quiet_assets' # Turns off the Rails asset pipeline log
  gem 'bullet' # help reduce sql query speeds
  gem 'lol_dba' # helps scan for better indexing
  gem 'pry' # debugging from console anywhere
  gem 'better_errors' # neat error pages
  gem 'binding_of_caller' # turns debugging at error page
  gem 'annotate' # annotates the fields on the models to remove the need to remember the schema
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'timecop'
  gem 'regressor', git: 'https://github.com/ndea/regressor.git', branch: 'master'
  gem 'shoulda-matchers'
end

group :test do
  gem 'active_mocker'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'vcr'
  gem 'fuubar'
end
