set :rails_env, "staging"

# Application Settings
set :user,      "arabbit"
set :deploy_to, "/home/arabbit/application"

#set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
#set :branch, defer { current_branch }
set :branch, 'develop'

# Server Roles
role :web, "tincan.mojolingo.com"
role :app, "tincan.mojolingo.com"
role :db,  "tincan.mojolingo.com", primary: true
role :adhearsion, "tincan.mojolingo.com"

