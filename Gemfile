source :rubygems

gem "adhearsion", :git => 'git://github.com/adhearsion/adhearsion.git', :branch => :develop
gem "adhearsion-reporter", :git => 'git://github.com/adhearsion/adhearsion-reporter.git', :branch => :develop

#
# Here are some example plugins you might like to use. Simply
# uncomment them and run `bundle install`.
#

# gem 'adhearsion-asterisk'
# gem 'adhearsion-rails'
# gem 'adhearsion-activerecord'
# gem 'adhearsion-ldap'
gem 'adhearsion-xmpp', :git => 'git@github.com:adhearsion/adhearsion-xmpp.git', :branch => :develop
gem 'punchblock'
# gem 'adhearsion-drb'

gem 'rails', '3.1.3'

gem 'mongoid',  '~> 2.3'
gem 'bson_ext', '~> 1.4'

# Needed to look up extensions
gem 'activeldap'
gem 'ruby-ldap'

# IRC connectivity
gem 'isaac'

gem 'airbrake'

gem 'httparty'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
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

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm'

  # To use debugger
  # gem 'ruby-debug19', :require => 'ruby-debug'

  gem 'hpricot'
  gem 'ruby_parser'
end

gem 'web-app-theme', '~> 0.8.0', :group => [:development, :assets]

group :test, :development do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'mocha'
  gem 'rspec-rails-mocha'
  gem 'jasmine-rails'
  gem 'factory_girl_rails'

  gem 'cucumber-rails'
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
