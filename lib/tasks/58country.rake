namespace :_58country do
  desc '58'
  task :search_it  => :environment do
    agent = Mechanize.new
    # base_url = "http://sh.58.com/zufang/j2/?minprice=2000_3500&sourcetype=5"
    base_url = "http://sh.58.com/pudongxinqu/zufang/j2/?minprice=2000_3500&PGTID=0d300008-0058-3fae-c666-61903e91fc7e&ClickID=2"

    # base_url = "http://sh.58.com/zufang/0/j2/?minprice=2000_3500&PGTID=0d300008-0000-2957-0131-2c24be8dc88c&ClickID=3"
    page = agent.get(base_url)
    page_pages = page.search(".//*[@id='infolist']/table//tr/td/div/a[1]")
    page_pages.each do |a|
      begin
        page_url = a.attributes['href'].value
        little_page = agent.get(page_url)
        infos = little_page.search(".//*[@id='main']/div[1]/div[2]/div[2]/ul/li")
        price = infos[0].text.gsub(/\t|\r|\n| /,"")
        price_i = infos[0].search("//span[@class='bigpri arial']").text.to_i
        address =  infos[4].search("div[2]/text()").text.gsub(/\t|\r|\n| /,"")
        puts "%4s=>%9s\n      地址:#{address}\n===="% [price_i, price]
        address_url = "file:///home/wangping/资源列表.html"
        address_page = agent.get(address_url)
        address_page.search(".//*[@id='text_']")[0].set_attribute(:value,address)

        binding.pry
        save_in_file(price_i, address, page_url, price)
      rescue
        next
      end
    end

  end

  def save_in_file(price, address, page_url, info)
    require 'csv'
    file_path = "#{Rails.root.to_s}/public/58country"
    FileUtils.mkdir_p file_path unless File.exist?(file_path)
    FileUtils.rm File.new("#{file_path}addresses.csv") if File.exist?("#{file_path}addresses.csv")
    CSV.open("#{file_path}/addresses.csv", "a+") do |csv|
      csv << [price, address, page_url, info]
    end
  end
end