require 'xmlrpc/client'

# Methods for interacting with Wisecrack (Mojo Lingo's Horde instance)
class Wisecrack
  class << self
    def make_request(method, *args)
      # Because XMLRPC::Client does not deal well with SSL, we force a new
      # object and a new HTTP connection on each request.
      # Yes, this is a little heavy, but oh well.
      client = XMLRPC::Client.new_from_uri 'https://wisecrack.mojolingo.com/rpc/'
      client.user     = Adhearsion.config.punchblock['username']
      client.password = Adhearsion.config.punchblock['password']
      client.call method, *args
    end

    def get_client_by_id(id)
      make_request 'clients/getClient', id
    end
  end
end