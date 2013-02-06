class CRMNeuron
  MATCHER = /^Find me (?<name>.*)/i

  def confidence(message)
    MATCHER.match(message.body).nil? ? 0 : 1
  end

  def reply(message)
    match = MATCHER.match message.body
    name = match[:name]
    futuresimple_token = message.user["profile"]["futuresimple_token"]
    session = Pipejump::Session.new token: futuresimple_token
    contact = session.contacts.all.find { |contact| contact.name == name }
    "#{contact.name}, #{contact.title} at #{contact.organisation_name}\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com"
  end
end
