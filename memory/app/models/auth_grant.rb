class AuthGrant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: Integer
  field :provider, type: Symbol
  field :info, type: Hash, default: {}
  field :extra, type: Hash, default: {}
  field :credentials, type: Hash, default: {}

  belongs_to :user
  accepts_nested_attributes_for :user

  attr_accessible :uid, :provider, :info, :extra, :credentials, :user_attributes

  def self.find_or_create_for_oauth(oauth_data)
    grant = find_by_provider_and_uid oauth_data.provider, oauth_data.uid
    return grant if grant

    oauth_data[:extra].delete :access_token
    oauth_data[:user_attributes] = {}
    oauth_data[:user_attributes][:profile_attributes] = { name: oauth_data.info.name }
    if oauth_data.info.email
      oauth_data[:user_attributes][:profile_attributes][:email_addresses_attributes] = [
        {address: oauth_data.info.email}
      ]
    end

    create! oauth_data
  end

  def self.find_by_provider_and_uid(provider, uid)
    where(provider: provider, uid: uid).first
  end

  def username
    info['nickname']
  end
end
