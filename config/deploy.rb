# config valid only for current version of Capistrano
lock '3.6.0'


set :application, 'stackclone'
set :repo_url, 'git@github.com:BadAllOff/stackoverflow_clone.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'vendor/bundle', 'public/uploads'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

namespace :sphinx do
  desc 'Reindex sphinx'
  task :reindex do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'ts:index'
        end
      end
    end
  end

  desc 'Stop sphinx'
  task :stop do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'ts:stop'
        end
      end
    end
  end

  desc 'Start sphinx'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'ts:start'
        end
      end
    end
  end

  desc 'Rebuild sphinx'
  task :rebuild do
    on roles(:app) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'ts:rebuild'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
after 'deploy:restart', 'sphinx:reindex'
