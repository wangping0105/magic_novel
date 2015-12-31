## config ikorm deploy

```shell
ssh gdw_dev@115.29.148.211 -p 40022
# type passwd
cat ~/.ssh/id_rsa.pub | ssh gdw_dev@115.29.148.211 -p 40022 'cat >> .ssh/authorized_keys'
```

### config capistrano and unicorn

config Gemfile

```ruby
# Use unicorn as the app server
group :production do
  gem 'unicorn', '~> 4.9.0'
  gem 'unicorn-worker-killer', '~> 0.4.3'
  # gem 'newrelic_rpm', '~> 3.12.0.288'
end

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano3-unicorn', '~> 0.2.1'
  # gem 'sepastian-capistrano3-unicorn', '~> 0.5.1'
  gem 'capistrano-rvm', '~> 0.1.1'
  # gem 'capistrano-sidekiq'
end
```

exec `bundle`

config capistrano and unicorn

```shell
# Capfile

require 'capistrano/rvm'
require 'capistrano3/unicorn'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/passenger'
```

create bellow file and it's example file

```shell
config/app.god
config/logrotate.conf
config/nginx.conf

config/app.god.example
config/logrotate.conf.example
config/nginx.conf.example
```

config `config/unicorn/production.rb`

config `.gitignore` file

```shell
# TODO Comment out these rules if you are OK with secrets being uploaded to the repo
config/database.yml
config/chewy.yml
config/secrets.yml
config/nginx.conf
config/unicorn/*.rb
config/logrotate.conf
config/newrelic.yml
config/app.god

## Environment normalisation:
/.bundle
/vendor/bundle
```

config deploy file

```ruby
# deploy.rb
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(*%W{
  config/database.yml config/secrets.yml
  config/nginx.conf config/unicorn/production.rb
  config/app.god
})

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push(*%W{
  config/unicorn log tmp/pids tmp/cache tmp/sockets
  tmp/upload vendor/bundle public/system
})

set :unicorn_rack_env, -> { fetch(:rails_env) || "deployment" }

set :unicorn_restart_sleep_time, 5


# set :whenever_roles, %w(web app db)
set :whenever_roles, %w(web app db whenever)

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # invoke 'unicorn:restart'
      # invoke 'unicorn:duplicate'
      invoke 'unicorn:legacy_restart'
    end
  end

  desc 'cp assets/images to public/assets'
  before :restart, :cp_assets do
    on roles(:app), in: :sequence, wait: 5 do
      execute :cp, '-R', release_path.join('app/assets/images/*'), release_path.join('public/assets/')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "run rake task on remote server 'cap development deploy:runrake task=stats'"
  task :runrake do
    on roles(:db), in: :groups, limit: 1, wait: 10 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          rake ENV['task']
        end
      end
    end
  end

  desc 'upload setup_config for application'
  task :upload_config do
    on roles(:web), in: :sequence, wait: 5 do
      fetch(:linked_files).each do |file_path|
        unless test "[ -f #{shared_path}/#{file_path} ]"
          upload!("#{file_path}", "#{shared_path}/#{file_path}", via: :scp)
        end
      end
    end
  end

  desc 'update git remote repo url'
  task :update_git_repo do
    on release_roles :all do
      with fetch(:git_environmental_variables) do
        within repo_path do
          current_repo_url = execute :git, :config, :'--get', :'remote.origin.url'
          unless repo_url == current_repo_url
            execute :git, :remote, :'set-url', 'origin', repo_url
            execute :git, :remote, :update

            execute :git, :config, :'--get', :'remote.origin.url'
          end
        end
      end
    end
  end
end
```

```ruby
# deploy/testing.rb

set :branch, :master
set :stage, :testing

set :rails_env, :production

set :deploy_to, "/dyne/apps/#{fetch(:application, :ikorm)}_#{fetch :stage}"

set :port, 40022
server '115.29.148.211:40022', user: 'gdw_dev', roles: %w{web app db whenever}
```

### ready to deploy

```shell
cap -AD

cap testing deploy:check

cap testing deploy:upload_config

cap testing deploy:check

cap testing deploy:deploy

ps aux | grep kill unicorn

# 空服务器 装一个nginx ， 然后下面
# sudo ln -nfs /dyne/apps/ordering_ik_production/shared/config/nginx.conf /opt/nginx/conf.d/ordering_ik_production.conf

sudo /etc/init.d/ngins reload
```

