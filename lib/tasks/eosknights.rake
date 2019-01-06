namespace :eosknights do
  desc 'bt 时代'
  task :async  => :environment do
    EosknightsWorker.perform_async
  end
end