class Message
  include Virtus

  attribute :source_type, Symbol
  attribute :source_address, String
  attribute :body, String

  def respond_to
    source_address
  end
end
