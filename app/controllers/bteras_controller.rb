class BterasController < ApplicationController
  include BtearHelper
  skip_before_action :verify_authenticity_token, only: :check

  def index
    @currencies = BtearCurrency.order(top: :desc).order(name: :asc)
    @name_currencies = BtearCurrency.currency_names

    @currencies.each do |c|
      c.rate = cacl_rate(c.current , c.today_first)
    end
    @currencies_topup = @currencies.select{|c| c.top == 1}
    @currencies_default = @currencies.select{|c| c.top != 1}
    @currencies_topup = @currencies_topup.sort_by { |c| c.rate}.reverse
    @currencies_default = @currencies_default.sort_by { |c| c.rate}.reverse

    @currencies = @currencies_topup.concat(@currencies_default)
  end

  def show
    @currency = BtearCurrency.find_by(name: params[:id])
    @currency.update(top: params[:topup])

    redirect_to bteras_path
  end

  def btear_infos
    @currency = BtearCurrency.find(params[:id])

    @currency_infos = BtearInfo.where(currency: @currency.name).order(id: :desc).page(params[[:page]])
    @name_currencies = BtearCurrency.currency_names
  end

  def check
    arr = params[:bteras].split("||")

    arr.each do |values|
      v_arr = values.split(":")
      next if v_arr.last.to_f == 0

      value = Rails.cache.read(v_arr.first).to_f

      if value != v_arr.last.to_f
        betra_currency = BtearCurrency.find_by(name: v_arr[0])
        unless betra_currency
          betra_currency = BtearCurrency.create(name: v_arr[0], max: 0, min: 99999)
        end

        value = v_arr.last.to_f
        betra_currency.current = value
        if betra_currency.max < value
          betra_currency.max = value
        end

        if betra_currency.min > value
          betra_currency.min = value
        end

        if betra_currency.today_first_date != Date.today
          betra_currency.today_first_date = Date.today
          betra_currency.min = 9999999
          betra_currency.max = 0
          betra_currency.today_first = value
        end

        betra_currency.save

        BtearInfo.create(currency: v_arr[0], value: v_arr[1])
        Rails.cache.write(v_arr.first, v_arr.last)
      end
    end

    render json: {status: 'success'}
  end

  def refresh
    # url = 'http://api.btc38.com/v1/getMyTradeList.php'
    # id = "307247"
    # time = Time.now.to_i
    # key = "27fba39eb5f8e04126e8fb8d3e648658"
    # skey = "1c18aecc2930c4bc35b0fde7f14c3f98429521a8d8f0a7a319953d4513228123"
    # attrs = {
    #   key: key,
    #   time:time,
    #   md5: Digest::MD5.hexdigest("#{key}_#{id}_#{skey}_#{time}"),
    #   mk_type:'cny',
    #   coinname: 'xcn'
    # }
    #
    # response = RestClient.post(url, attrs){ |response, _, _, _| response }

    # binding.pry
    @currencies = BtearCurrency.find_each do |a|
      a.update(today_first: a.current)
    end

    redirect_to bteras_path
  end

  private
  def parse_response(response)
    HashWithIndifferentAccess.new(JSON.parse(response))
  end
end