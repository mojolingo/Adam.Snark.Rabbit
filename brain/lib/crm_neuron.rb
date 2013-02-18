require 'pipejump'
require 'erb'
require 'active_support/core_ext/object/blank'

class CRMNeuron
  MATCHER = /^((Find( me)?)|(Who is)) (?<name>[\w\s]*)\??/i
  RESPONSE_TEMPLATE = ERB.new <<-EOF
<%= contact.name %><% if contact.title.present? %>, <%= contact.title %><% end %><% if contact.attributes.keys.include?('organisation_name') && contact.organisation_name %><% if contact.title.present? %> at<% else %> from<% end %> <%= contact.organisation_name %><% end %><% if contact.phone.present? %>
Phone: <%= contact.phone %><% end %><% if contact.email.present? %>
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
    return "Sorry, you have not configured any integrations for contact lookup." unless futuresimple_token
    session = Pipejump::Session.new token: futuresimple_token
    contact = session.contacts.all.find { |contact| contact.name.downcase == name.downcase }
    return "Sorry, I have no record of #{name}." unless contact
    RESPONSE_TEMPLATE.result(binding).strip
  end
end
