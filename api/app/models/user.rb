class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :registerable, :rememberable, :trackable

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

  def self.find_for_github_oauth(oauth_data)
    info = oauth_data.extra.info
    return user if user = where(email: info.email).first
    # else
      create! email: info.email, name: info.name
    # end
  end
end
