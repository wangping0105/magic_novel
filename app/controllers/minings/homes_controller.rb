class Minings::HomesController < Minings::ApplicationController
  def index
    @page_title = "Fastwin 挖矿"
  end

  def eoswin
    @page_title = "Eoswin 挖矿"
  end

  def eosdice
    @page_title = "Eosdice 挖矿"
  end
end
