class TwitterGrant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: Integer
  field :provider, type: String
  field :info, type: Hash, default: {}
  field :extra, type: Hash, default: {}
  field :credentials, type: Hash, default: {}

  embedded_in :user

  def username
    info['nickname']
  end
end
