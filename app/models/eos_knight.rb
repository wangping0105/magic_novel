class EosKnight < ApplicationRecord
  EOSPARK_KEY = "a9564ebc3289b7a14551baf8ad5ec60a"

  enum category: {
      material_sale: 0,
      item_sale: 1,
  }

  def get_original_quantity
    if current_fee == 0.03
      limit = 0.0066
    else
      limit = 0.004
    end
    rate = 1 - current_fee

    quantity >= limit ? (quantity/rate).round(4) : (quantity + 0.0001).round(4)
  end

  class << self

    # EosKnight.fetch_data("2019-01-01 00:00:00", repeat_end: false)
    # 获取数据
    def fetch_data(set_time, repeat_end: true, dpage: 1, max_count: 5000)
      module_name = "account"
      action = "get_account_related_trx_info"
      account = "eosknightsio"

      page = dpage
      flag = true
      index = 0
      while flag
        puts '开始。。。。。。'
        resp = sync_eos_transactions(module_name, action, account, page)

        if resp[:errno] == 0
          resp[:data][:trace_list].each do |trace|
            infos = trace[:memo].split(":")
            if infos.first == "eosknights"
              index += 1
              trx_time = Time.parse(trace[:timestamp])

              p trx_time, set_time
              if trx_time < set_time
                puts "达到设定时间，结束！"
                flag = false

                break
              end

              if index >= max_count
                puts "达到最大数量，结束！"
                flag = false

                break
              end

              if EosKnight.find_by(trx_id: trace[:trx_id])
                if repeat_end
                  puts "记录重复，结束！"
                  flag = false

                  break
                else
                  puts "记录重复，跳过！"
                end
              else
                category =if infos[1] == "material-sale"
                  :material_sale
                elsif infos[1] == "item-sale"
                  :item_sale
                end

                eosknights_fee = Setting.find_or_create_by(var: "eosknights_fee", target_type: "System", target_id: 0)
                current_fee = (eosknights_fee.value || 0.03).to_f

                attrs = {
                    block_num: trace[:block_num],
                    data_md5: trace[:data_md5],
                    trx_id: trace[:trx_id],
                    trx_time: trx_time,
                    receiver: trace[:receiver],
                    sender: trace[:sender],
                    code: trace[:code],
                    quantity: trace[:quantity],
                    symbol: trace[:symbol],
                    status: trace[:status],
                    memo: trace[:memo],
                    category: category,
                    category_id: infos[2],
                    sell_id: infos[3],
                    buyer: infos.last,
                    current_fee: current_fee
                }

                EosKnight.create!(attrs)
              end
            end

            print "."
          end
          page +=1
        else
          puts "error"

          # flag = false
        end

        sleep 0.5

      end
    end

    def sync_eos_transactions(module_name, action, account, page=1, size=20, transaction_type=2)
      attrs = {
          module: module_name,
          action: action,
          apikey: EOSPARK_KEY,
          account:account,
          page: page,
          size: size,
          transaction_type: transaction_type,
          sort: "DESC"
      }

      p "https://api.eospark.com/api?#{attrs.to_query}"
      response = RestClient.get("https://api.eospark.com/api?#{attrs.to_query}")

      HashWithIndifferentAccess.new(JSON(response))
    rescue
      {}
    end

    def total_fee(start_at, end_at)
      total = 0.0
      EosKnight.where(trx_time: start_at..end_at).find_each do |eos_knight|
        fee = if eos_knight.quantity > 0.0065
          (eos_knight.quantity/0.97 * 0.03).round(4)
        else
          0.0001
        end

        total += fee
      end

      total
    end
  end
end