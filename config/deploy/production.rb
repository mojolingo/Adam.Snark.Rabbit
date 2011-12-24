set :rails_env, 'staging'

set :user,      'arabbit'
set :deploy_to, '/home/arabbit/application'

set :branch, 'develop'

role :web, "arabbit.mojolingo.com"
role :app, "arabbit.mojolingo.com"
role :db,  "arabbit.mojolingo.com", primary: true
role :ahn, "arabbit.mojolingo.com"
