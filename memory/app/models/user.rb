require 'ruby_jid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable, :token_authenticatable

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :authentication_token, type: String

  has_many :auth_grants

  has_one :profile
  accepts_nested_attributes_for :profile
  after_initialize { build_profile if profile.nil? }

  attr_accessible :profile_attributes

  before_save :ensure_authentication_token

  def self.find_or_create_for_oauth(oauth_data)
    AuthGrant.find_or_create_for_oauth(oauth_data).user
  end

  def self.find_by_github_user_id(user_id)
    find_by_provider_and_uid :github, user_id
  end

  def self.find_by_twitter_user_id(user_id)
    find_by_provider_and_uid :twitter, user_id
  end

  def self.find_by_provider_and_uid(provider, uid)
    grant = AuthGrant.find_by_provider_and_uid provider, uid
    grant.user if grant
  end

  def self.find_for_message(message)
    bare_jid = RubyJID.new(message.source_address).bare
    profile = Profile.where("jids.address" => bare_jid.to_s).first
    if profile
      profile.user
    elsif bare_jid.domain == ENV['ADAM_ROOT_DOMAIN']
      find bare_jid.node
    end
  rescue Mongoid::Errors::DocumentNotFound
  end

  def social_usernames
    auth_grants.inject({}) do |h, g|
      h[g.provider] = g.username
      h
    end
  end

  def name
    profile.name
  end

  def serializable_hash(options = {})
    {
      id: id,
      authentication_token: authentication_token,
      profile: profile.serializable_hash,
      auth_grants: auth_grants.serializable_hash
    }
  end
end
