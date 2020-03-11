### repo

```shell
git clone ssh://git@admin.vcooline.com:40022/dyne/repos/ikcrm_api.git
```

### Built VcoolineIkcrm

- https://github.com/newrelic/extends_newrelic_rpm

### extra package for system

```shell
sudo apt-get install libxml2-dev libxslt-dev
sudo apt-get install redis-server memcached
```

### set rvm

```shell
cd ikcrm_api
# sudo -i
# rvm use 2.1.1@ikcrm_api --create
# https://rvm.io/workflow/projects/
rvm --create --ruby-version use 2.1.2@ikcrm_api
rvm --create --versions-conf use 2.1.2@ikcrm_api
```

### rspec

transpec: [Transpec](https://github.com/yujinakayama/transpec) is a tool for converting your
specs to the latest RSpec syntax with static and dynamic code analysis.

init

### choose and add gems

* capistrano, rvm-capistrano
* whenever
* database_cleaner
* factory_girl_rails

### deploy

testing env

database: vcooline_ikcrm_testing

# 如何删除git大文件
- https://www.jianshu.com/p/fe3023bdc825s
