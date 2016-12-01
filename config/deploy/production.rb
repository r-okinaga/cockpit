set :stage, :production
set :branch, 'master'
set :rails_env, 'production'
set :keep_releases, 5

server '192.168.0.137', roles: %w(web app db), user: 'rails'
