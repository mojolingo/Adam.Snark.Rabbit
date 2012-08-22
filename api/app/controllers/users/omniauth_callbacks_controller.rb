class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    create
  end

  def twitter
    create
  end

  def create
    auth_grant = AuthGrant.find_or_create_for_oauth request.env["omniauth.auth"]

    if auth_grant.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth_grant.provider, name: auth_grant.user.name
      sign_in_and_redirect auth_grant.user, :event => :authentication
    else
      flash[:error] = "An error ocurred while trying to log you in. Please try later."
      redirect_to root_url
    end
  end

  def after_omniauth_failure_path_for(provider)
    root_url
  end
end
