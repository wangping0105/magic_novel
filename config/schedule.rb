set :output, {:error => 'log/whenever_error.log', :standard => 'log/whenever_standard.log'}
set :task_log_head, %Q{magicnovel schedule job }

job_type :ruby,  "cd :path && bundle exec ruby :task :output"
job_type :task_logger,  %{cd :path && bundle exec ruby -e 'puts  Time.now.to_s + " :task_log_head **:task**"' :output}


every :day, :at => '10:45am', :roles => [:whenever] do
  task_logger %{utils:push_price_about_cu_superior}
  rake 'utils:push_price_about_cu'
  task_logger %{utils:push_price_about_cu  FINISHED}
end