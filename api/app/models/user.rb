class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable

  ## Database authenticatable
  field :email, type: String, default: ""

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :name, type: String, default: ''

  has_many :auth_grants

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

  def social_usernames
    auth_grants.inject({}) do |h, g|
      h[g.provider] = g.username
      h
    end
  end
end
