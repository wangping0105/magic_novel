
namespace :search_home do
  SleepTime = 1

  desc '58同城'
  task :search_58country  => :environment do
    agent = Mechanize.new
    url_arr = [
        "http://sh.58.com/zufang/j2/?minprice=2000_3500&sourcetype=5", # all
        "http://sh.58.com/pudongxinqu/zufang/j2/?minprice=2000_3500&PGTID=0d300008-0058-3fae-c666-61903e91fc7e&ClickID=2",# 浦东 全部
        "http://sh.58.com/pudongxinqu/zufang/0/j2/?minprice=2000_3500&PGTID=0d300008-0058-3de1-0d82-5a55f0a93072&ClickID=1",# 浦东 个人
        "http://sh.58.com/zufang/0/j2/?minprice=2000_3500&PGTID=0d300008-0000-2957-0131-2c24be8dc88c&ClickID=3", # 全部 个人
	"http://sh.58.com/zufang/sub/l236724/j2/?minprice=2500_3000&PGTID=0d300008-0000-267f-2263-45c2c0a43bec&ClickID=1`", #4号线沿线
	"http://sh.58.com/baoshan/zufang/b12j2/?PGTID=0d300008-0182-48c8-60bf-a5320f76e847&ClickID=1",
	"http://sh.58.com/gaojingsh/zufang/j2/?minprice=2000_3200&sourcetype=5" #高境
    ]
    base_url = url_arr.last
    FILE_BEHINE = '' #"_single"
    page = agent.get(base_url)
    p page
    # =删除原先的文件
    @file_path = "#{Rails.root.to_s}/public/hourses/58country#{FILE_BEHINE}"
    remove_addresses_file(@file_path)

    index = 0
    while(page.present? && index < 4)
      page_pages = page.search(".//*[@id='infolist']/table//tr/td/div/a[1]")
      page_pages.each do |a|
        begin
          page_url = a.attributes['href'].value
          little_page = agent.get(page_url)
          infos = little_page.search(".//ul[@class='house-primary-content']/li")

          price = infos.search(".//*[@class='house-price']").text.to_i
          price_info = infos[0].search(".//*[@class='house-price']").text.gsub(/\t|\r|\n| /,"")

          address = infos.find{|i| "地址：" == i.search("[1]").text}
          address = address.search("[2]/text()").text.gsub(/\t|\r|\n| /,"")

          puts "%4s=>%9s\n      地址:#{address}\n===="% [price, price_info]

          save_in_file(price, address, page_url, price_info)
          sleep SleepTime
        rescue
          p '跳过'
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
        "http://sh.ganji.com/fang1/pudongxinqu/b2000e3500h2m1/", # 浦东 全部
        "http://sh.ganji.com/fang1/gaojing/b2000e3200h2m1/"
    ]
    base_url = url_arr[2]
    FILE_BEHINE = ""
    page = agent.get(base_url)

    # =删除原先的文件
    @file_path = "#{Rails.root.to_s}/public/hourses/ganjin#{FILE_BEHINE}"
    remove_addresses_file(@file_path)

    index = 0
    while(page.present? && index < 4)
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
