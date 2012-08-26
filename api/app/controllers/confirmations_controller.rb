class ConfirmationsController < ApplicationController
  def show
    email = current_user.profile.confirm_by_token params[:id]
    redirect_to my_profile_path
  end
end
