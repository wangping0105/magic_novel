namespace :eossanguos do
  desc 'bt 时代'
  task :async  => :environment do
    EossanguosWorker.perform_async
  end
end