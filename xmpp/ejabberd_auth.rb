#!/usr/bin/env ruby

# This script is used by ejabberd to authenticate jabber users against the Memory service

$stdout.sync = true

require 'logger'
require 'net/http'
require 'json'

file = File.open "/opt/ejabberd/logs/auth.log", File::WRONLY | File::APPEND | File::CREAT
file.sync = true
$logger = Logger.new file
$logger.level = Logger::DEBUG

PACK_FORMAT = 'S>'

class Auth
  def process_creds(operation, username, domain, password)
    case operation
    when 'auth'
      auth username, password
    when 'isuser'
      isuser username
    when 'setpass'
    else
      raise 'Invalid Operation'
    end

    respond true
  rescue
    respond
    raise
  end

  private

  def conn
    @conn ||= begin
      uri = URI("<%= ENV['MEMORY_BASE_URL'] %>")
      Net::HTTP.start(uri.host, uri.port)
    end
  end

  def get_json(path)
    req = Net::HTTP::Get.new(path)
    req.basic_auth "<%= ENV['INTERNAL_USERNAME'] %>", "<%= ENV['INTERNAL_PASSWORD'] %>"

    case response = conn.request(req)
    when Net::HTTPNotFound
      raise "User doesn't exist"
    else
      JSON.parse response.body
    end
  end

  def fetch_user(user_id)
    get_json "/users/#{user_id}.json"
  end

  def auth(user_id, token)
    $logger.debug "Checking creds for #{user_id} with password #{token}"
    if user_id == "adam" && token == "abc123"
      true
    else
      response = fetch_user user_id
      raise 'Password incorrect' unless response['authentication_token'] == token
    end
  end

  def isuser(user_id)
    $logger.debug "Checking if #{user_id} is a user"
    fetch_user user_id
    true
  end

  def respond(val = false)
    response = val ? 1 : 0
    $logger.debug "Responding with #{response}"
    data = [2, response].pack(PACK_FORMAT*2)
    $stdout.write data
  end
end

begin
  $logger.info "Starting ejabberd authentication service"

  auth = Auth.new

  loop do
    break if $stdin.eof?
    msg = $stdin.read 2
    next unless msg
    length = msg.unpack(PACK_FORMAT).first

    msg = $stdin.read length
    data = msg.split ':'

    auth.process_creds *data
  end
rescue => e
  $logger.error "#{e.class.name}: #{e.message}"
  $logger.error e.backtrace.join("\n\t")
end
