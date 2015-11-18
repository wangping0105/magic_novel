# encoding: utf-8
require 'iconv'

namespace :mechanize do
  desc '爬虫'
  task :get_novels => :environment do
    include UtilsHelper
    p '开始！'
    web_url = "http://www.fqxsw.com"
    agent = Mechanize.new
    base_url = "http://www.fqxsw.com/modules/article/index.php?fullflag=1&page=1"
    page = agent.get(base_url)
    _page_page = page.search( ".//*[@id='pagelink']/a[@class='last']/text()").text.to_i

    (1.._page_page).each do |page_i|
      base_url = "http://www.fqxsw.com/modules/article/index.php?fullflag=1&page=#{page_i}"
      page = agent.get(base_url)
      all_books = page.search(".//ul[@class='articlelist']/li")
      (1...all_books.size).each do |i|
        name_arr = all_books[i].children.select{|c| c.name=='div'}.map{|c| c.text}
        book_name = name_arr.first
        book = Book.find_by(title: book_name)
        unless book.present?
          author_name = name_arr.second
          word_count = name_arr.fourth.to_i*1000
          status = 2 # 完本
          book_type = 1 # 转载
          link = page.links.select{|l| l.to_s == book_name}.first
          _little_page = link.click
          classification_name = _little_page.search(".//span[@class='author']/text()")[0].text[-4..-3]
          introduction =  _little_page.search(".//div[@class='booklistt clearfix']/div[@class='list']/text()")[2].text.gsub(/\r\n\t\t简介：|顽木书友群.+\n/,'')
          classification = Classification.where("name like ?", "%#{classification_name}%").first
          author = Author.find_or_create_by(name: author_name)
          #Book.transaction do
            book = Book.create({
              title: book_name,
              classification_id: classification.try(:id),
              book_type: book_type,
              status: status,
              introduction: introduction,
              author_id: author.id,
              words: word_count
            })
            book.book_volumes.new(title: '正文', book_id: book.id).save
            first_links = _little_page.search(".//div[@class='booklist clearfix']/li//a")[0].attributes['href'].value
            book_first_url = "#{web_url}#{first_links}"
            get_book_details(book_first_url, book_name)
            print '.'
         # end
        end
      end
    end

    # get_book_details '莽荒纪', book_first_url
  end

  desc '抓取单个小说'
  task :single_novel => :environment do
    include UtilsHelper
    book_name = '妖神记'
    author_name = '发飙的蜗牛'
    classification_name = '玄幻'
    agent = Mechanize.new
    base_url = "http://www.fqxsw.com/book/yaoshenji/"
    web_url = "http://www.fqxsw.com/"
    _little_page = agent.get(base_url)
   # classification_name = _little_page.search(".//span[@class='author']/text()")[0].text[-4..-3]
    introduction =  _little_page.search(".//div[@class='booklistt clearfix']/div[@class='list']/text()")[2].text.gsub(/\r\n\t\t简介：|顽木书友群.+\n/,'')
    classification = Classification.where("name like ?", "%#{classification_name}%").first
    author = Author.find_or_create_by(name: author_name)
    Book.transaction do
      book = Book.create({
        title: book_name,
        classification_id: classification.try(:id),
        book_type: 1,
        status: 2,
        introduction: introduction,
        author_id: author.id
      })
      book.book_volumes.new(title: '正文', book_id: book.id).save
      first_links = _little_page.search(".//div[@class='booklist clearfix']/li//a")[0].attributes['href'].value
      book_first_url = "#{web_url}#{first_links}"
      get_book_details(book_first_url, book_name)
    end
  end

  desc 'again 抓取单个小说 from'
  task :single_novel_from_chapter => :environment do
    include UtilsHelper
    book_name = ENV['title']
    book_first_url = ENV['url']
    get_book_details(book_first_url, book_name) unless(book_name.blank? || book_first_url.blank?)
  end

  # 适用于断点续传
  def get_book_details book_first_url, book_name
    agent = Mechanize.new
    page = agent.get(book_first_url)
    flag = true
     # binding.pry
    while page.present? do
      title= page.search(".//*[@id='bgdiv']/dl/dt/text()").to_html rescue nil
      content = page.search(".//*[@id='booktext']").to_html rescue nil
      page.encoding = 'gb2312' if(content.blank? || title.blank?) # 网页的编码
      title= page.search(".//*[@id='bgdiv']/dl/dt/text()").to_html rescue nil
      content = page.search(".//*[@id='booktext']").to_html rescue nil
      if content.blank? && title.blank?
        break
      else
        conv = Iconv.new("utf-8", "GBK")
        title = conv.iconv(title)
        content = conv.iconv(content)
        # content = filterEmoji(content).scrub.force_encoding("UTF-8")
        content = content.gsub get_regex, ''
        #_link = page.links.find {|l| l.text == '(快捷键:←)上一页'}.href
        begin
          save_in_database(book_name, title, content)
          puts "=>#{book_name}-#{title}-#{page.uri.to_s}"
          page = page.links.find { |l| l.text == '下一页(快捷键:→)' }.click
        rescue
          flag = false
          dir_path = "#{Rails.root.to_s}/public/novels/logs"
          FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
          file = File.new("#{dir_path}/#{Date.today.strftime("%Y%m%d")}_error.log", "w")
          msg = "!跳过=%s次,#{book_name}-#{title}-#{page.uri.to_s}\n"
          page_mulu = page.links.find { |l| l.text == '返回章节目录(快捷键:回车)' }.click
          _lin = page_mulu.links.find { |l| l.uri.to_s == page.uri.to_s.gsub("http://www.fqxsw.com","") }
          index = page_mulu.links.index(_lin)
          page = skip_a_page(page_mulu, index, 1, file, msg)
        end
      end
    end
    p "#{book_name}全部完成！" if flag
  end

  def skip_a_page page_mulu, index, i, file, msg
    begin
      page = page_mulu.links[index+(rand(2)+1)*i].click
      return page
    rescue
      p msg%i
      file.puts(msg%i)
      skip_a_page page_mulu, index, (i+1), file, msg
    end
  end

  def save_as_file(dir_name, title, content)
    dir_path = "#{Rails.root.to_s}/public/novels/#{dir_name}"
    FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
    file = File.new("#{dir_path}/#{title}.html", "w")
    file.puts(content)
  end

  def save_in_database(book_name, title, content)
    book = Book.find_by(title: book_name)
    if book
      book_volume = book.book_volumes.first
      prev_chpater = book.book_chapters.last
      book_chapter = book.book_chapters.create(
        {
          title: title,
          content: content,
          book_volume_id: book_volume.try(:id),
          prev_chapter_id: prev_chpater.try(:id)
        })
      prev_chpater.update(next_chapter_id: book_chapter.id ) if prev_chpater
    end
  end

  def get_regex
    regex = /番茄小说网|www.fqxsw.com|<a.+>|<\/a>|[\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}]/
  end
end

