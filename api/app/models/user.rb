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

  embeds_one :github_grant
  accepts_nested_attributes_for :github_grant
  after_initialize { build_github_grant if github_grant.nil? }

  def self.find_or_create_for_github_oauth(oauth_data)
    user = find_by_github_user_id oauth_data.uid
    return user if user
    info = oauth_data.info
    create! email: info.email, name: info.name, github_grant_attributes: oauth_data
  end

  def self.find_by_github_user_id(user_id)
    where('github_grant.uid' => user_id).first
  end

  def github_username
    github_grant.username
  end
end
