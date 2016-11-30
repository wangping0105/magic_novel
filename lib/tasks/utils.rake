namespace :utils do
  desc '改变小说类别'
  task :change_classification  => :environment do
    classification = Classification.where("name=?", "科幻").first
    ct1 = Classification.where("name = ?", "玄幻").first

    _count = ct1.books_count + classification.books_count
    ct1.update(books_count: _count)
    classification.update(books_count: 0)

    puts '更新...'
    Book.where(classification_id: classification.id).update_all(classification_id: ct1.id)
    puts '更新完毕'
  end

  desc '从csv上传小说'
  task :upload_csv => :environment do
    CsvImport.book_csv(true)
  end

  desc '全部小说夏哀哉'
  task :download_csv => :environment do
    @books = Book.all
    CsvExport.book_csv(@books)
  end

  desc 'demo'
  task :demo => :environment do
    User.find_each do |u|
      Notification.create(user_id: u.id, title: "欢迎你来到魔书网!", body: "详细信息!")
    end

    FayeClient.send_message("/notifications/broadcast", {text: "欢迎你来到魔书网!"})
  end

  desc '铜价信息'
  task :push_price_about_cu => :environment do
   agent = Mechanize.new
    url_arr = [
        "http://www.cjys.net/"
    ]
    base_url = url_arr.last
    page = agent.get(base_url)

    if page.present?
      th = page.search(".//*[@id='jsxq_view']/tr")[0]
      td = page.search(".//*[@id='jsxq_view']/tr")[1]
      str = ""
      td.children.each_with_index{|c, index|
        str += ("#{th.children[index].text.gsub("  ", "")}: #{c.text}\n")
      }

      data1 = {
        name: "铜价信息",
        content: "\n#{str}",
        nickname: ">",
        created_at: Time.now.strftime("%F %T")
      }
      FayeClient.send_message("/talks/broadcast", {code: 1, user: data1})
      FayeClient.send_message("/notifications/send_msg_to_qq", {notification:{content: "铜价信息:\n#{str}"}})
    end
  end
end