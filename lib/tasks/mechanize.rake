# encoding: utf-8
require 'iconv'
namespace :mechanize do
  desc '爬虫'
  task :demo => :environment do
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
          link = page.links.select{|l| l.to_s == book_name}.first
          _little_page = link.click
          classification_name = _little_page.search(".//span[@class='author']/text()")[0].text[-4..-3]
          introduction =  _little_page.search(".//div[@class='booklistt clearfix']/div[@class='list']/text()")[2].text.gsub(/\r\n\t\t简介：|顽木书友群.+\n/,'')
          classification = Classification.where("name like ?", "%#{classification_name}%").first
          author = Author.find_or_create_by(name: author_name)
          Book.transaction do
            book = Book.create({
              title: book_name,
              classification_id: classification.try(:id),
              book_type: status,
              introduction: introduction,
              author_id: author.id,
              words: word_count
            })
            book.book_volumes.new(title: '正文', book_id: book.id).save
            first_links = _little_page.search(".//div[@class='booklist clearfix']/li//a")[0].attributes['href'].value
            book_first_url = "#{web_url}#{first_links}"
            get_book_details(book_first_url, book_name)
            print '.'
          end
        end
      end
    end

    # get_book_details '莽荒纪', book_first_url
  end

  # 适用于断点续传
  def get_book_details  book_first_url, book_name
    agent = Mechanize.new
    page = agent.get(book_first_url)

    while page.present? do
      title= page.search(".//*[@id='bgdiv']/dl/dt/text()").to_html
      content = page.search(".//*[@id='booktext']").to_html
      conv = Iconv.new("utf-8", "GBK")
      title = conv.iconv(title)
      content = conv.iconv(content).gsub(/番茄小说网|www.fqxsw.com/, "")
      save_in_database(book_name, title, content)
      begin
        page = page.links.find { |l| l.text == '下一页(快捷键:→)' }.click
      rescue
        dir_path = "#{Rails.root.to_s}/public/novels"
        FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
        file = File.new("#{dir_path}/#{Date.today.strftime("%Y%m%d")}_error.log", "w")
        file.write("#{book_name}-#{title}==\n")
        return
      end
    end
    p "#{book_name}全部完成！"
  end


  def save_as_file(dir_name, title, content)
    dir_path = "#{Rails.root.to_s}/public/novels/#{dir_name}"
    FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
    file = File.new("#{dir_path}/#{title}.html", "w")
    file.write(content)
  end

  def save_in_database(book_name, title, content)
    book = Book.find_by(title: book_name)
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

