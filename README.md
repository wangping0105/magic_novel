# magic_novel
魔书网，体验极致小说阅读. 进入首页 [http://magicbooks.cn/](http://magicbooks.cn/), server is in HK.

# c9.io 添加数据库用户
# run the MySQL interactive shell
$ mysql-ctl cli
https://docs.c9.io/docs/setting-up-mysql

SHOW GRANTS FOR 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');   

# 数据库初始化
rake db:create
rake db:migrate
rake db:seed

# 安装 membercache

注意，图形验证码依赖于 ImageMagic， 没有请加上

# add god
- god -c config/app.god
- add .ruby-version file in root
