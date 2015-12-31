set :branch, :master
set :stage, :production

set :app_env, :production

# set :repo_url, 'git@github.com:wangping0105/magic_novel.git' # config/deploy.rb 已经配置了
set :deploy_to, "/dyne/wp_apps/magic_novel_#{fetch :stage}"

set :rvm_ruby_string, :local

server '192.168.10.232', user: 'ikcrm_dev', roles: %w{web app db}, my_property: :my_value
