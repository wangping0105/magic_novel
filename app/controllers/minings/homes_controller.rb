class Minings::HomesController < Minings::ApplicationController
  def index
    @page_title = "Fastwin 挖矿"
    @mining_category = "fastwin"
  end

  def eoswin
    @page_title = "Eoswin 挖矿"
    @mining_category = "eoswin"
  end

  def eosdice
    @page_title = "Eosdice 挖矿"
    @mining_category = "eosdice"
  end

  def eosdicejacks
    @page_title = "EosdiceJacks挖矿"
    @mining_category = "eosdicejacks"
  end

  def endless
    @page_title = "Endless 挖矿"
    @mining_category = "endless"
  end
end
