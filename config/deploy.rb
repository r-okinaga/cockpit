# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'cockpit'
set :repo_url, 'git@github.com:r-okinaga/cockpit.git'

set :deploy_to, "/var/www/rails/#{fetch(:application)}"
set :log_Level, :info
set :linked_dirs, %w(log public/assets public/system tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle)

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

SSHKit.config.command_map[:rake] = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'

namespace :deploy do
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end
    task :db_seed do
        on roles(:db) do |host|
            within current_path do
                with rails_env: fetch(:rails_env) do
                    execute :rake, 'db:seed'
                end
            end
        end
    end

    after :finishing, 'deploy:cleanup'
end
