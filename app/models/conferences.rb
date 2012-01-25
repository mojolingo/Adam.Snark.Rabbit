class Conferences
  include Mongoid::Document
  # room_number and pin are strings so they can accomodate leading zeroes
  field :room_number, type: String
  field :name,        type: String
  field :pin,         type: String
  field :account,     type: String
end