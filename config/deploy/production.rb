set :branch, :master
set :stage, :production

set :rails_env, :production

# set :repo_url, 'git@github.com:wangping0105/magic_novel.git' # config/deploy.rb 已经配置了
set :deploy_to, "/dyne/wp_apps/magic_novel_#{fetch :stage}"

set :rvm_ruby_string, :local

server '120.55.180.128', user: 'dev', roles: %w{web app db whenever}, my_property: :my_value

# 在 deploy/staging.rb 中设置 server 的时候一定要添加 web app db 三个 role，
# 因为 capistrano-rails 的 precompile migrate 分别依赖于 web db 两个角色，否则是不会自动执行的
