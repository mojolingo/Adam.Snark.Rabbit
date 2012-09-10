class Jid < ContactDetails
  embedded_in :profile

  validates_format_of :address, with: Devise.email_regexp

  after_destroy :inform_destroy

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.uuid
  end

  def send_confirmation_instructions
    publish_event 'jid.created', jid: address
  end

  def send_updated_confirmation_instructions
    publish_event 'jid.updated', old_jid: address_was, new_jid: address
  end

  def inform_destroy
    publish_event 'jid.removed', jid: address
  end

  def publish_event(key, payload)
    AMQPConnection.instance.publish payload.to_json, content_type: 'application/json', key: key
  end
end
