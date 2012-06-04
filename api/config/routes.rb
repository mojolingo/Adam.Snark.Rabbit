ASR::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'signup', :to => 'devise/registrations#new'
    get 'signin', :to => 'devise/sessions#new', :as => :new_user_session
    get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root :to => 'static#home'
end
