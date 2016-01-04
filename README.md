# magic_novel
魔书网，体验极致小说阅读


# c9.io 添加数据库用户
SHOW GRANTS FOR 'root'@'localhost';
DROP USER 'root'localhost'%';
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

# 数据库初始化
rake db:create
rake db:migrate
rake db:seed


注意，图形验证码依赖于 ImageMagic， 没有请加上