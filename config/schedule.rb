set :output, {:error => 'log/whenever_error.log', :standard => 'log/whenever_standard.log'}
set :task_log_head, %Q{magicnovel schedule job }
#
# job_type :ruby,  "cd :path && bundle exec ruby :task :output"
# job_type :task_logger,  %{cd :path && bundle exec ruby -e 'puts  Time.now.to_s + " :task_log_head **:task**"' :output}


# every :day, :at => '10:45am', :roles => [:whenever] do
#   task_logger %{utils:push_price_about_cu&utils:some_info_push superior }
#   rake 'utils:some_info_push'
#   rake 'utils:push_price_about_cu'
#   task_logger %{utils:push_price_about_cu&utils:some_info_push FINISHED}
# end
#
every :day, :at => '1:45am', :roles => [:whenever] do
  # task_logger %{update_books BEGIN}
  rake 'mechanize:update_books'
  # task_logger %{update_books FINISHED}
end

# eospark 网站出问题了
# every :day, :at => '0:30am', :roles => [:whenever] do
#   task_logger %{eossanguos every_day BEGIN}
#   rake 'eossanguos:every_day'
#   task_logger %{eossanguos  every_day FINISHED}
# end

# every :day, :at => '0:35am', :roles => [:whenever] do
#   task_logger %{eosknights every_day BEGIN}
#   rake 'eosknights:async'
#   task_logger %{eosknights  every_day FINISHED}
# end

# every 10.minute, :roles => [:whenever] do
#   task_logger %{eosknights BEGIN}
#   rake 'eossanguos:async'
#   task_logger %{eosknights FINISHED}
# end