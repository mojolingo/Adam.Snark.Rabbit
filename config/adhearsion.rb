# Centralized way to overwrite any Adhearsion platform or plugin configuration
# - Execute rake adhearsion:config:desc to get the configuration options
# - Execute rake adhearsion:config:show to get the configuration values
#
# To update a plugin configuration you can write either:
#
#    * Option 1
#        Adhearsion.config.<plugin-name> do |config|
#          config.<key> = <value>
#        end
#
#    * Option 2
#        Adhearsion.config do |config|
#          config.<plugin-name>.<key> = <value>
#        end

Adhearsion.config do |config|
  # ******* Configuration for reporter **************

  # The Airbrake/Errbit API key
  config.reporter.api_key = ENV['AHN_REPORTER_API_KEY'] if ENV.has_key?('AHN_REPORTER_API_KEY')

  # Base URL for notification service
  config.reporter.url     = ENV['AHN_REPORTER_URL'] if ENV.has_key?('AHN_REPORTER_URL')


  # ******* Configuration for punchblock **************

  # Autoreconnect in case of failure
  config.punchblock.reconnect_tries = ENV['AHN_PB_RECONNECT_TRIES'] if ENV.has_key?('AHN_PB_RECONNECT_TRIES')

  # Host punchblock needs to connect (where rayo or asterisk are located)
  config.punchblock.host           = ENV['AHN_PB_HOST'] if ENV.has_key?('AHN_PB_HOST')

  # Authentication credentials
  config.punchblock.password       = ENV['AHN_PB_PASSWORD'] if ENV.has_key?('AHN_PB_PASSWORD')

  # Platform punchblock shall use to connect to the Telephony provider. Currently supported values:
  # - :xmpp
  # - :asterisk
  config.punchblock.platform       = ENV['AHN_PB_PLATFORM'].to_sym if ENV.has_key?('AHN_PB_PLATFORM')

  # Port punchblock needs to connect (by default 5038 for Asterisk, 5222 for Rayo)
  config.punchblock.port           = ENV['AHN_PB_PORT'].to_i if ENV.has_key?('AHN_PB_PORT')

  # Authentication credentials
  config.punchblock.username       = ENV['AHN_PB_USERNAME'] if ENV.has_key?('AHN_PB_USERNAME')


  # ******* Configuration for platform **************

  # Adhearsion will accept automatically any inbound call
  config.platform.automatically_accept_incoming_calls = ENV['AHN_PLATFORM_AUTOMATICALLY_ACCEPT_INCOMING_CALLS'] if ENV.has_key?('AHN_PLATFORM_AUTOMATICALLY_ACCEPT_INCOMING_CALLS')

  # Folder to include the own libraries to be used. Adhearsion loads any ruby file located into this folder during the bootstrap
  # process. Set to nil if you do not want these files to be loaded. This folder is relative to the application root folder.
  config.platform.lib                                 = ENV['AHN_PLATFORM_LIB'] if ENV.has_key?('AHN_PLATFORM_LIB')

  # Log configuration
  config.platform.logging

  # A log formatter to apply to all active outputters. If nil, the Adhearsion default formatter will be used.
  config.platform.logging.formatter                   = ENV['AHN_PLATFORM_LOGGING_FORMATTER'] if ENV.has_key?('AHN_PLATFORM_LOGGING_FORMATTER')

  # Supported levels (in increasing severity) -- :trace < :debug < :info < :warn < :error < :fatal
  config.platform.logging.level                       = ENV['AHN_PLATFORM_LOGGING_LEVEL'] if ENV.has_key?('AHN_PLATFORM_LOGGING_LEVEL')

  # An array of log outputters to use. The default is to log to stdout and log/adhearsion.log
  config.platform.logging.outputters                  = ENV['AHN_PLATFORM_LOGGING_OUTPUTTERS'] if ENV.has_key?('AHN_PLATFORM_LOGGING_OUTPUTTERS')

  # Adhearsion application root folder
  config.platform.root                                = ENV['AHN_PLATFORM_ROOT'] if ENV.has_key?('AHN_PLATFORM_ROOT')
end

Adhearsion.router do
  # TODO: DOCUMENT THIS USAGE!!!
  route 'Mojo Lingo Extensions', ExtensionsController, lambda {|call| call.variables[:to] =~ /arabbit@127.0.0.1/ }

  route 'default' do
    puts call.variables.inspect
    answer
    speak "Hi, this is Adam, but you can call me Mr Rabbit. I don't really do much yet, but it's nice to meet you anyway! Bye!"
    hangup
  end
end
