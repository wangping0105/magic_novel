# config valid only for current version of Capistrano
lock '>=3.4.0'

set :application, 'magic_novel'
set :repo_url, 'git@github.com:wangping0105/magic_novel.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :linked_files, fetch(:linked_files, []).push(*%W{
  config/nginx.conf config/unicorn/production.rb config/database.yml config/secrets.yml config/cross_sites.yml
})


# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, fetch(:linked_dirs, []).push(*%W{
  config/unicorn log tmp/pids tmp/cache tmp/sockets public/www
  vendor/bundle public/system public/books public/zhuangbbq public/assets/kindeditor
})

set :unicorn_rack_env, -> { fetch(:rails_env) || "deployment" }

set :unicorn_restart_sleep_time, 5

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :whenever_roles, %w(web app db whenever)

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
      # invoke 'unicorn:duplicate'
      # invoke 'unicorn:legacy_restart'
    end
  end
  #
  desc 'cp assets/images to public/assets'
  before :restart, :cp_assets do
    on roles(:app), in: :sequence, wait: 5 do
      execute :cp, '-R', release_path.join('app/assets/images/*'), release_path.join('public/assets/')
    end
  end

  after :publishing, :restart
  # after :restart, :kindeditor_assets

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

  desc 'upload books'
  task :upload_books do
    on roles(:web), in: :sequence, wait: 5 do
      Dir.foreach("public/books") do |file|
        file_path = "public/books/#{file}"
        p file_path,file.gsub(/\./,"") == ""
        unless file.gsub(/\./,"") == ""
          upload!("#{file_path}", "#{shared_path}/#{file_path}", via: :scp)
        else
          next
        end

        File.delete("public/books/#{file}")
        puts "删除#{file}"
        save_as_file(file.gsub(/\.csv/,""))
      end
    end
  end

  def save_as_file(content)
    file = File.new("public/novels/have_uploaded.txt", "a+")
    file.print(",#{content}")
  end
end
