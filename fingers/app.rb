require 'blather/client'

jid = ENV['ADAM_XMPP_JID']

Blather.logger.info "Connecting as #{jid}"

setup jid, ENV['ADAM_XMPP_PASSWORD']

message do |m|
  Blather.logger.info "Received message \"#{m.body}\" from #{m.from}"
end
