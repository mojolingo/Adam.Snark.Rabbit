source :rubygems

gem "adhearsion", '~> 2.0'
gem "adhearsion-reporter", '~> 2.0'

# gem 'adhearsion-asterisk'
# gem 'adhearsion-rails'
# gem 'adhearsion-activerecord'
# gem 'adhearsion-ldap'
# gem 'adhearsion-drb'
gem 'adhearsion-xmpp', '~> 1.0'
gem 'blather', :git => 'git://github.com/sprsquish/blather.git', :branch => :develop

gem 'rails', '~> 3.2'

gem 'mongoid',  '~> 2.3'
gem 'bson_ext', '~> 1.4'

# Needed to look up extensions
gem 'activeldap', :git => 'git://github.com/mojolingo/activeldap.git'
gem 'ruby-ldap'

# IRC connectivity
gem 'isaac'

gem 'airbrake'

gem 'httparty'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1'
  gem 'coffee-rails', '~> 3.1'
  gem 'uglifier',     '>= 1.0.3'
end

gem 'jquery-rails'

gem 'haml'
gem 'haml-rails'

gem 'inherited_resources'
gem 'simple-navigation'
gem 'simple_form'

# Use unicorn as the web server
# gem 'unicorn'

gem "twitter-bootstrap-rails"

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'

  gem 'debugger'

  gem 'hpricot'
  gem 'ruby_parser'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'mocha'
  gem 'rspec-rails-mocha', :require => false
  gem 'jasmine-rails'
  gem 'factory_girl_rails'

  gem 'cucumber-rails', '~> 1.3'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'capybara'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-rails-assets'
  gem 'guard-jasmine-headless-webkit'
  gem 'ruby_gntp'
end
