class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, with: :render_404

  private

  def render_404
    respond_with nil, status: 404
  end
end
