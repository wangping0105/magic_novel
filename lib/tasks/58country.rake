namespace :search_home do
  SleepTime = 2

  desc '58同城'
  task :search_58country  => :environment do
    agent = Mechanize.new
    url_arr = [
        "http://sh.58.com/zufang/j2/?minprice=2000_3500&sourcetype=5", # all
        "http://sh.58.com/pudongxinqu/zufang/j2/?minprice=2000_3500&PGTID=0d300008-0058-3fae-c666-61903e91fc7e&ClickID=2",# 浦东 全部
        "http://sh.58.com/pudongxinqu/zufang/0/j2/?minprice=2000_3500&PGTID=0d300008-0058-3de1-0d82-5a55f0a93072&ClickID=1",# 浦东 个人
        "http://sh.58.com/zufang/0/j2/?minprice=2000_3500&PGTID=0d300008-0000-2957-0131-2c24be8dc88c&ClickID=3" # 全部 个人
    ]
    base_url = url_arr.second
    FILE_BEHINE = '' #"_single"
    page = agent.get(base_url)

    # =删除原先的文件
    @file_path = "#{Rails.root.to_s}/public/58country#{FILE_BEHINE}"
    remove_addresses_file(@file_path)

    index = 0
    while(page.present? && index < 7)
      page_pages = page.search(".//*[@id='infolist']/table//tr/td/div/a[1]")
      page_pages.each do |a|
        begin
          page_url = a.attributes['href'].value
          little_page = agent.get(page_url)
          infos = little_page.search(".//*[@id='main']/div[1]/div[2]/div[2]/ul/li")
          price = infos[0].text.gsub(/\t|\r|\n| /,"")
          price_i = infos[0].search("//span[@class='bigpri arial']").text.to_i
          address =  infos[4].search("div[2]/text()").text.gsub(/\t|\r|\n| /,"")
          # 有的页面第4个是地址
          address =  infos[3].search("div[2]/text()").text.gsub(/\t|\r|\n| /,"") if address.blank?
          address =  infos[2].search("div[2]/text()").text.gsub(/\t|\r|\n| /,"") if address.blank?
          puts "%4s=>%9s\n      地址:#{address}\n===="% [price_i, price]

          save_in_file(price_i, address, page_url, price)
          sleep SleepTime
        rescue
          next
        end
      end
      # =下一页的按钮
      next_link = page.search(".//*[@id='infolist']/div[3]/a[@class='next']")[0]
      page = (agent.get(next_link.attributes['href'].text) rescue nil)
      index += 1
    end
  end

  desc '赶集网 '
  task :search_ganjin  => :environment do
    agent = Mechanize.new
    url_arr = [
        "http://sh.ganji.com/fang1/b2000e3500h2m1/",
        "http://sh.ganji.com/fang1/pudongxinqu/b2000e3500h2m1/" # 浦东 全部
    ]
    base_url = url_arr[0]
    FILE_BEHINE = ""
    page = agent.get(base_url)

    # =删除原先的文件
    @file_path = "#{Rails.root.to_s}/public/ganjin#{FILE_BEHINE}"
    remove_addresses_file(@file_path)

    index = 0
    while(page.present? && index < 7)
      page_pages = page.search(".//*[@class='leftBox']/div[@class='listBox']/ul/li/div/a[1]")
      page_pages.each do |a|
        begin
          page_url = a.attributes['href'].value
          little_page = agent.get(page_url)
          infos = little_page.search(".//*[@id='wrapper']//div[@class='basic-info']/ul/li")
          price = infos[0].search(".//*[@class='basic-info-price fl']").text.to_i
          price_info = infos[0].search("./*/text()").text.gsub(/\t|\r|\n| /,"")
          address =  infos.search("./*[@class='addr-area']").text.gsub(/\t|\r|\n| /,"")
          puts "%4s=>%9s\n      地址:#{address}\n===="% [price, price]

          save_in_file(price, address, page_url, price_info)
          sleep SleepTime
        rescue
          next
        end
      end

      # =下一页的按钮
      next_link = page.search(".//*[@id='wrapper']/div[5]/div[3]/div/ul/li/a[@class='next']")[0]
      page = (agent.get(next_link.attributes['href'].text) rescue nil)
      index += 1
    end
  end

  def save_in_file(price, address, page_url, info)
    require 'csv'
    file_path = @file_path
    FileUtils.mkdir_p file_path unless File.exist?(file_path)
    CSV.open("#{file_path}/addresses.csv", "a+") do |csv|
      csv << [price, address, page_url, info]
    end
  end

  def remove_addresses_file(file_path)
    `rm -rf #{file_path}/addresses.csv` if File.exist?("#{file_path}/addresses.csv")
  end
end