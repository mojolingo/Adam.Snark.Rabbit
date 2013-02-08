require 'pipejump'
require 'erb'

class CRMNeuron
  MATCHER = /^((Find( me)?)|(Who is)) (?<name>[\w\s]*)\??/i
  RESPONSE_TEMPLATE = ERB.new <<-EOF
<%= contact.name %><% if contact.title %>, <%= contact.title %><% if contact.organisation_name %> at<% end %><% else %> from<% end %><% if contact.organisation_name %> <%= contact.organisation_name %><% end %><% if contact.phone %>
Phone: <%= contact.phone %><% end %><% if contact.email %>
Email: <%= contact.email %><% end %>

https://app.futuresimple.com/crm/contacts/<%= contact.id %>
EOF

  def confidence(message)
    MATCHER.match(message.body).nil? ? 0 : 1
  end

  def reply(message)
    match = MATCHER.match message.body
    name = match[:name]
    futuresimple_token = message.user["profile"]["futuresimple_token"]
    session = Pipejump::Session.new token: futuresimple_token
    contact = session.contacts.all.find { |contact| contact.name == name }
    RESPONSE_TEMPLATE.result(binding).strip
  end
end
