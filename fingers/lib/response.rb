require 'json'

class Response
  include Virtus::ValueObject

  attribute :target_type, Symbol
  attribute :target_address, String
  attribute :body, String

  def self.from_json(json)
    new JSON.parse(json)
  end

  def to_json
    JSON.generate attributes
  end
end
