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
      make_request 'clients.getClient', id
    end

    def get_client_by_name(name)
      # searchClients takes two arrays as params:
      # * list of search strings
      # * list of search fields
      res = make_request 'clients.searchClients',  [name], ['company']

      # The return value is a hash of results.
      # Each search string is the key to an array of records matching the string
      res[name].first rescue nil
    end

    def record_time(options = {})
      unless options.has_key?('client') && options.has_key?('description') && options.has_key?('hours')
        raise ArgumentError, "Must supply client, hours and description"
      end
      make_request 'time.recordTime', options
    end
  end
end
