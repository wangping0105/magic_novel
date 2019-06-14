namespace :eosknights do
  desc 'bt 时代'
  # cap production deploy:runrake task=eosknights:async
  # rake eosknights:async
  task :async  => :environment do
    EosknightsWorker.perform_async
  end
end