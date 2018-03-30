class BlockChain
  class << self
    def huobi_symbols
      Rails.cache.fetch("huobi_symbols", expires_in: 1.hour) do
        fetch_huobi_symbols['data']
      end || []
    end

    # {
    #     base-currency: "omg",
    #     quote-currency: "eth",
    #     price-precision: 6,
    #     amount-precision: 4,
    #     symbol-partition: "main"
    # }
    def fetch_huobi_symbols
      url = "https://api.huobipro.com/v1/common/symbols"
      headers = {
          :content_type => 'application/json',
          'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36'
      }

      response = RestClient.get(url, headers){ |response, _, _, _| response }

      parse_response response
    end

    def parse_response(response)
      JSON.parse(response.body)
    end
  end
end