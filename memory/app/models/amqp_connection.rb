class AMQPConnection
  include Singleton

  attr_reader :bunny

  def initialize
    options = {host: 'adam.local', connect_timeout: 10}
    options[:host] = ENV['RAILS_AMQP_HOST'] if ENV.has_key?('RAILS_AMQP_HOST')
    options[:user] = ENV['RAILS_AMQP_USERNAME'] if ENV.has_key?('RAILS_AMQP_USERNAME')
    options[:pass] = ENV['RAILS_AMQP_PASSWORD'] if ENV.has_key?('RAILS_AMQP_PASSWORD')
    @bunny = Bunny.new options
    @bunny.start
  end

  def publish(message, options = {})
    exchange_name = options.delete(:exchange) || ''
    @bunny.exchange(exchange_name).publish(message, options)
  end
end
