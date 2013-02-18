ASR::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'signup', :to => 'devise/registrations#new'
    get 'signin', :to => 'devise/sessions#new', :as => :new_user_session
    get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get '/users/find_for_message', :to => 'users#find_for_message'
  resources :users, only: :show

  resources :profiles, only: [:show, :edit, :update]
  get '/profile', to: 'profiles#show', as: :my_profile
  get '/profile/confirm/:id', to: 'confirmations#show', as: :my_profile_confirm

  get '/me', to: 'users#current'

  root :to => 'static#home'
end
