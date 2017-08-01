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
        "http://m.ccmn.cn/"
    ]
    base_url = url_arr.last
    page = nil
    while(page.nil?)
      begin
        page = agent.get(base_url)
      rescue
        puts "error"
      end
    end

    if page.present?
      div_text = page.search(".//*[@id='content']/ul[1]/div[1]/font")
      title ="#{div_text[0].text}#{div_text[2].text}日价格"
      th = page.search(".//*[@id='content']/ul[1]/table/tr[1]/th")

      str = ""
      (2..4).each do |i|
        td = page.search(".//*[@id='content']/ul[1]/table/tr[#{i}]/td")
        td.each_with_index{|c, index|
          str += ("#{th[index].children.text.strip}: #{c.children.text.strip}\n")
        }
      end

      data1 = {
        name: title,
        content: "\n#{str}",
        nickname: ">",
        created_at: Time.now.strftime("%F %T")
      }
      FayeClient.send_message("/talks/broadcast", {code: 1, user: data1})
      FayeClient.send_message("/notifications/send_msg_to_qq", {notification:{content: "铜价信息:\n#{str}"}})
      user = User.find_by(phone: 15921076830)
      if user
        notification = user.notifications.create(title: title, body: "\n#{str}")
        FayeClient.send_message("/notifications/#{user.api_key.access_token}#{user.id}", { notification: { title: notification.title } })
      end
    end
  end

  desc 'birthdat remind'
  task :some_info_push => :environment do
    birth_dats = [
      {
      name:'爸爸',
      nickname:'老王同学',
      content:'祝你生日快乐~',
      birthday:'1971-10-21'
      },
      {
      name: '妈妈',
      nickname:'老李同学',
      content:'祝你生日快乐~',
      birthday:'1973-12-07'
      },
      {
      name:'媳妇的老公',
      nickname:'小王同学',
      content:'祝你生日快乐~',
      birthday:'1991-01-05'
      },
      {
      name:'媳妇',
      nickname:'小王同学',
      content:'祝你生日快乐~',
      birthday:'1989-09-13'
      }
    ]
    birth_dats.each{|u|
      birth = Date.parse u[:birthday]

      if birth.strftime("%m-%d") == Date.today.strftime("%m-%d")
        str = "#{u[:nickname]},#{u[:content]}\n献给#{u[:birthday]}出生的你"
        FayeClient.send_message("/notifications/send_msg_to_qq", {notification:{content: "#{u[:name]}的生日到啦!\n#{str}"}})
      end
    }

  end

  task :fdemo => :environment do

    t = 0.000000001

    result = 0
    flag = true
    arr = [0, 1, 1]
    i = 3

    while flag
      arr[i] = arr[i-1] + arr[i-2]

      _r = (limit(arr, i-1) - limit(arr, i))
      _r = 0 - _r if _r < 0

      if _r < t
        flag = false
        result = i -1
      end
      i += 1
    end

    puts result, limit(arr, result)
  end

  def limit(arr, n)
    value = arr[n-1].to_d/arr[n]

    puts value

    value
  end

end