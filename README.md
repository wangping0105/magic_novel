# oauth 登陆
- 本地启动 9000 端口， 然后配置在 config/service.yml里面

# 从服务器同步图片 文件夹
scp -r dev@www.block-lian.com/:ssss ssss

# Magic book
魔书网，体验极致小说阅读.

进入首页 [http://magicbooks.cn/](http://magicbooks.cn/)
 
ps: server is in HK.

# 数据库初始化
- rake db:create
- rake db:migrate
- rake db:seed

# Add god 进程监控
- add .ruby-version file in root
- god -c config/app.god

# Add redis

# 安装 membercache（可以不装）
