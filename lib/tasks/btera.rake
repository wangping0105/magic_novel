namespace :btera do
  desc 'bt 时代'
  task :get_data  => :environment do
    agent = Mechanize.new
    base_url = "http://www.btc38.com/trade.html?btc38_trade_coin_name=zcc"
    page = agent.get(base_url)
  end

  task :refresh => :environment do
    @currencies = BtearCurrency.find_each do |a|
      a.update(today_first: a.current)
    end
  end
end