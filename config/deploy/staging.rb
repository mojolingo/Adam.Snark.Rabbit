set :rails_env, 'staging'

set :user,      'arabbit'
set :deploy_to, '/home/arabbit/application'

set :branch, 'develop'

role :web, "staging.arabbit.mojolingo.com"
role :app, "staging.arabbit.mojolingo.com"
role :db,  "staging.arabbit.mojolingo.com", primary: true
role :ahn, "staging.arabbit.mojolingo.com"
