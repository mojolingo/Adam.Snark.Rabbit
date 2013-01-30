class UsersController < ApplicationController
  respond_to :json

  http_basic_authenticate_with name: 'internal', password: (ENV['ADAM_INTERNAL_PASSWORD'] || 'abc123')

  def find_for_message
    message = AdamCommon::Message.from_json params[:message]
    user = User.find_for_message(message)
    respond_with user, status: user ? 200 : 404
  end
end
