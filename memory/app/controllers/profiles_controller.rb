class ProfilesController < InheritedResources::Base
  actions :show, :edit, :update

  before_filter :authenticate_user!
  before_filter { params[:id] ||= current_user.profile.id }
end
