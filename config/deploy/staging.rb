set :rails_env, 'staging'

set :user,      'arabbit'
set :deploy_to, '/home/arabbit/application'

set :branch, 'develop'

role :web, "arabbit-staging.mojolingo.com"
role :app, "arabbit-staging.mojolingo.com"
role :db,  "arabbit-staging.mojolingo.com", primary: true
role :ahn, "arabbit-staging.mojolingo.com"
