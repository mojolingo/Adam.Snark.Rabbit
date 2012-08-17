class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth request.env["omniauth.auth"]

    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Github", name: user.name
      sign_in_and_redirect user, :event => :authentication
    else
      flash[:error] = "An error ocurred while trying to log you in. Please try later."
      redirect_to root_url
    end
  end

  def twitter
    user = User.find_or_create_for_twitter_oauth request.env["omniauth.auth"]

    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Twitter", name: user.name
      sign_in_and_redirect user, :event => :authentication
    else
      flash[:error] = "An error ocurred while trying to log you in. Please try later."
      redirect_to root_url
    end
  end

  def after_omniauth_failure_path_for(provider)
    root_url
  end
end
