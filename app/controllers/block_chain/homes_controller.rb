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
end
