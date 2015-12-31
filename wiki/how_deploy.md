resources

- http://godrb.com/

add `gem 'capistrano', '~> 3.2.0'` to gemfile and exec `bundle`

run below command to install cap config

cap install


config `config/deploy.rb`

```ruby
lock '3.2.1'

set :application, 'ikcrm_api'
set :repo_url, 'ssh://git@admin.vcooline.com:40022/dyne/repos/ikcrm_api.git'

# deploy.rb or stage file (staging.rb, production.rb or else)
set :rvm_type, :auto                     # Defaults to: :auto


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
set :linked_files, %W{config/database.yml config/logrotate.conf config/newrelic.yml config/nginx.conf config/cross_sites.yml config/dalli.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
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
end
```

config development staging create and edit `config/deploy/development.rb`

```ruby
set :stage, :development
set :app_env, :production

set :port, 40022
set :repo_url, 'ssh://git@admin.vcooline.com:40022/dyne/repos/ikcrm_api.git'
set :deploy_to, "/dyne/apps/ikcrm_api_development"

#set :rvm_type, :user
#set :rvm_ruby_version, '2.0.0-p247'
set :rvm_ruby_string, :local

server 'test.api.ikcrm.com', user: 'git', roles: %w{web app db}, my_property: :my_value
```

### config https

- http://nginx.org/cn/docs/http/configuring_https_servers.html
- http://www.21andy.com/new/20100224/1714.html


openssl genrsa -des3 -out server.key 1024

key ikcrmapi12315123

$ cd /usr/local/nginx/conf
$ openssl genrsa -des3 -out server.key 1024
$ openssl req -new -key server.key -out server.csr
$ cp server.key server.key.org
$ openssl rsa -in server.key.org -out server.key
$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

openssl rsa -in server.key -text > private_key.pem
openssl x509 -inform PEM -in server.crt > public_key.pem
