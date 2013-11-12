class UsersController < ApplicationController
  respond_to :json

  http_basic_authenticate_with name: (ENV['ADAM_MEMORY_INTERNAL_USERNAME'] || 'internal'), password: (ENV['ADAM_MEMORY_INTERNAL_PASSWORD'] || 'abc123'), except: :current

  def current
    respond_with current_user
  end

  def show
    respond_with User.find(params[:id])
  end

  def find_for_message
    message = AdamCommon::Message.from_json params[:message]
    user = User.find_for_message(message)
    respond_with user, status: user ? 200 : 404
  end
end
