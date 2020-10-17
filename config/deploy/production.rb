set :branch, :master
set :stage, :production

set :rails_env, :production

# set :repo_url, 'git@github.com:wangping0105/magic_novel.git' # config/deploy.rb 已经配置了

set :rvm_ruby_string, :local

set :deploy_to, "/home/develop/rails_projects/magic_novel_#{fetch :stage}"
server '121.46.238.155', user: 'develop', roles: %w{web app db whenever}, my_property: :my_value
# set :deploy_to, "/home/dev/rails_projects/magic_novel_#{fetch :stage}"
# server 'magicbooks.cn', user: 'dev', roles: %w{web app db whenever}, my_property: :my_value

# 在 deploy/staging.rb 中设置 server 的时候一定要添加 web app db 三个 role，
# 因为 capistrano-rails 的 precompile migrate 分别依赖于 web db 两个角色，否则是不会自动执行的
