namespace :eossanguos do
  desc 'bt 时代'
  task :async  => :environment do
    EossanguosWorker.perform_async
  end

  # eossanguos:every_day
  task :every_day  => :environment do
    p "beginning"
    trx_time = (Date.today - 1.day).beginning_of_day
    EosSanguo.fetch_data(trx_time, repeat_end: false, max_count: 200000)
  end
end