source :rubygems

gem "adhearsion", :git => 'git://github.com/adhearsion/adhearsion.git', :branch => :develop

#
# Here are some example plugins you might like to use. Simply
# uncomment them and run `bundle install`.
#

# gem 'adhearsion-asterisk'
# gem 'adhearsion-rails'
# gem 'adhearsion-activerecord'
# gem 'adhearsion-ldap'
# gem 'adhearsion-xmpp'
# gem 'adhearsion-drb'

gem 'rails', '3.1.3'

gem 'mongoid',  '~> 2.3'
gem 'bson_ext', '~> 1.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '>= 1.0.3'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

group :development do
  # Deploy with Capistrano
  gem 'capistrano'

  # To use debugger
  # gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'database_cleaner'
end
