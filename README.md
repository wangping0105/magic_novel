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

# Add c9.io 添加数据库用户 if use
## Run the MySQL interactive shell
$ mysql-ctl cli
https://docs.c9.io/docs/setting-up-mysql

SHOW GRANTS FOR 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');   

# 安装 membercache（可以不装）
