class BlockChain::HomesController < BlockChain::ApplicationController
  def index
    @page_title = '火币网价格'
    params[:quote] ||= 'usdt'
    @huobi_symbols = BlockChain.huobi_symbols
    @huobi_symbols = @huobi_symbols.select{|s| s["quote-currency"] == params[:quote]}.group_by{|s| s['symbol-partition']}
  end

  def show
  end

  # /* GET /market/trade?symbol=ethusdt */
  # {
  #   "status": "ok",
  #   "ch": "market.btcusdt.trade.detail",
  #   "ts": 1489473346905,
  #   "tick": {
  #     "id": 600848670,
  #     "ts": 1489464451000,
  #     "data": [
  #       {
  #         "id": 600848670,
  #         "price": 7962.62,
  #         "amount": 0.0122,
  #         "direction": "buy",
  #         "ts": 1489464451000
  #       }
  #     ]
  #   }
  # }

  def trade
    params[:symbol] ||= "btcusdt"
    render json: fetch_huobi_trade(params[:symbol])
  end

  def kline
    params[:symbol] ||= "btcusdt"
    datas = fetch_huobi_kline(params[:symbol])
    time_now = Time.now
    time_rang = 1.minute
    index = 0
    # time0 open1 close2 min3 max4 vol5 tag6 macd7 dif8 dea9
    data = datas['data'].map do |data|
      _data = [
          (time_now - index * time_rang).strftime("%H:%M"),
          data['open'],
          data['close'],
          data['low'],
          data['high'],
          data['vol'],
          data['amount'],
          data['count'],
          'dif8',
          'dea9'
      ]

      index += 1

      _data
    end.reverse

    render json: { status: 'ok', datas: data }
  end

  private
  def fetch_huobi_trade(symbol)
    url = "https://api.huobipro.com/market/trade?symbol=#{symbol}"
    headers = {
        :content_type => 'application/json',
    }

    response = Timeout::timeout(10){
      RestClient.get(url, headers){ |response, _, _, _| response }
    }

    JSON.parse(response.body)
  end

  # period: 1min, 5min, 15min, 30min, 60min, 1day, 1mon, 1week, 1year
  def fetch_huobi_kline(symbol, period = "1min", size = 150)
    url = "https://api.huobipro.com/market/history/kline?symbol=#{symbol}&period=#{period}&size=#{size}"
    headers = {
        :content_type => 'application/json',
    }

    response = Timeout::timeout(10){
      RestClient.get(url, headers){ |response, _, _, _| response }
    }

    JSON.parse(response.body)
  end
end
