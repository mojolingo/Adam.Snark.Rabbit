require 'json'
require 'virtus'

class AdamCommon::Message
  include Virtus::ValueObject

  attribute :source_type, Symbol
  attribute :source_address, String
  attribute :body, String

  def self.from_json(json)
    new JSON.parse(json)
  end

  def to_json
    JSON.generate attributes
  end
end
