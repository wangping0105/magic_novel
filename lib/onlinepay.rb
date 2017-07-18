class Onlinepay
  def self.create_payment(amount: 1000, currency: "CNY")
    url = "localhost:4000/api/v1/payments"
    attr = {
      "product"=> "test#{Time.now.to_i}",
      "amount"=> amount,
      "currency"=> currency,
      "redirectSuccessUrl"=> "https://your-site.com/success",
      "redirectFailUrl"=> "https://your-site.com/fail",
      "callbackUrl"=> "https://your-site.com/callback",
      "extraReturnParam"=> {
       "email"=> "525399584@qq.com"
      },
      "orderNumber"=> Time.now.to_i
    }
    self.send_data(url, attr)
  end

  def self.create_payout(amount: 1000, currency: "CNY", order_number:, walletToken:)
    url = "localhost:4000/api/v1/payouts"
    attr = {
        "amount"=> amount,
        "currency"=> currency,
        "orderNumber"=> order_number,
        "walletToken"=> walletToken,
        "bankAccount"=> {
            "accountHolder"=> "",
            "accountNumber"=> "",
            "bankCode"=> ""
        },

        "billing"=> {
            "state"=> "",
            "countryCode"=> "",
            "city"=> ""
        }
    }
    self.send_data(url, attr)
  end

  def self.send_data(url, data)
    headers  = {'Authorization' => 'Bearer 846033ed8492b96ca457', :content_type => 'application/json'}

    response = RestClient.post url, data.to_json, headers
    JSON.parse(response)
  end
end
