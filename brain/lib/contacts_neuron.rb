require 'pipejump'
require 'erb'
require 'active_support/core_ext/object/blank'

class ContactsNeuron
  RESPONSE_TEMPLATE = ERB.new <<-EOF
<%= contact.name %><% if contact.title.present? %>, <%= contact.title %><% end %><% if contact.attributes.keys.include?('organisation_name') && contact.organisation_name %><% if contact.title.present? %> at<% else %> from<% end %> <%= contact.organisation_name %><% end %><% if contact.phone.present? %>
Phone: <%= contact.phone %><% end %><% if contact.email.present? %>
Email: <%= contact.email %><% end %>

https://app.futuresimple.com/crm/contacts/<%= contact.id %>
EOF

  def intent
    'contacts'
  end

  def reply(message, interpretation)
    return {body: "Sorry, I can only help you with that if you login."} unless message.user
    futuresimple_token = message.user["profile"]["futuresimple_token"]
    return {body: "Sorry, you have not configured any integrations for contact lookup."} unless futuresimple_token

    entities = interpretation['outcome']['entities']
    name = entities['contact']['value']

    session = Pipejump::Session.new token: futuresimple_token
    contact = session.contacts.all.find { |contact| contact.name.downcase == name.downcase }
    return {body: "Sorry, I have no record of #{name}."} unless contact
    {body: RESPONSE_TEMPLATE.result(binding).strip}
  end
end
