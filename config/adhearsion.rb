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
  # The Airbrake/Errbit API key [AHN_REPORTER_API_KEY]
  config.reporter.api_key = "68cd5fc4331903ace2d33b372339b38a"

  # Base URL for notification service [AHN_REPORTER_URL]
  config.reporter.url     = "http://errbit.mojolingo.com"

end

Adhearsion.router do
  # TODO: DOCUMENT THIS USAGE!!!
  route 'Mojo Lingo Extensions', ExtensionsController, lambda {|call| call.variables[:to] =~ /^<sip:\d+@/ }

  route 'default' do
    puts call.variables.inspect
    answer
    speak "Hi, this is Adam, but you can call me Mr Rabbit. I don't really do much yet, but it's nice to meet you anyway! Bye!"
    hangup
  end
end
