class BlockChain::ApplicationController < ApplicationController
  before_action :default_page_title
  layout 'block_chain'

  def default_page_title
    @page_title = "区块链联盟"
  end
end
