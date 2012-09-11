require 'horde_rpc'

# Methods for interacting with Wisecrack (Mojo Lingo's Horde instance)
class Wisecrack
  class << self
    def horde
      # Because XMLRPC::Client does not deal well with SSL, we force a new
      # object and a new HTTP connection on each request.
      # Yes, this is a little heavy, but oh well.
      HordeRPC.new 'https://wisecrack.mojolingo.com/rpc/', Adhearsion.config.punchblock['username'], Adhearsion.config.punchblock['password']
    end

    def method_missing(name, *args, &block)
      if horde.respond_to?(name)
        horde.send name, *args, &block
      else
        super
      end
    end

    def respond_to?(name)
      super || horde.respond_to?(name)
    end
  end
end
