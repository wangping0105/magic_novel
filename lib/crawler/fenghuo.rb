module Crawler
  class Fenghuo
    include UtilsHelper
    BOOK_CHAPTER_LIMIT = 25

    class << self
      def get_host
        'http://book.fenghuo.in'
      end

      # http://book.fenghuo.in/toplist_sort.php?sortid=14&xu=3&pno=0 女生
      def get_novels(sortid: 1, xu: 3, pno: 0)
        p '开始！'
        _default_page = ENV['page'].to_i + 1
        binding.pry
        @agent = Mechanize.new
        base_url = "#{get_host}/toplist_sort.php?sortid=#{sortid}&xu=#{xu}&pno=#{pno}"
        _page_page = 5

        (_default_page.._page_page).each do |page_i|
          base_url = "#{base_url}&page=#{page_i}"

          page = @agent.get(base_url)
          all_books = page.links.select{ |l| l.href && l.href.match(/readbook.php/) }
          (0...all_books.size).each do |i|
            process_single_book(all_books[i])

            sleep 2
          end
        end
      end

      def get_novel(book_name)
        book = Book.find_by(title: book_name)
        lastest_download_url = book.lastest_download_url
        return "#{book_name}不存在" unless book && lastest_download_url.present?

        @agent = Mechanize.new
        @book_chapter_exist_count = 0
        page = @agent.get(lastest_download_url)
        chapter_list(book, page)

        puts "#{book_name}下载完毕。。。"
      end

      # 关于章节出错， 链接上一章下一章
      def book_chapter_linked
        Book.find_each do |book|
          prev = nil
          index = 0
          book.book_chapters.order(id: :asc).each{|bc|
            if bc.prev_chapter_id.nil? && prev.present? && bc.id > prev.id
              puts "done #{prev.title} -> #{bc.title}"
              bc.update(prev_chapter_id: prev.id)
              prev.update(next_chapter_id: bc.id)
              index+=1
            else
              prev = bc
            end
          }

          put_logs "!!!!#{book.title}, 问题数量#{index}"
        end
      end

      def update_books
        @agent = Mechanize.new

        Book.find_each do |book|
          @book_chapter_exist_count = 0
          book_chapter = book.book_chapters.last
          if book_chapter.download_url
            puts "begin fetch #{book.title}"

            url = if book_chapter.download_url.match(/http:\/\//)
                    book_chapter.download_url
                  else
                    "#{get_host}/#{book_chapter.download_url}"
                  end

            page = @agent.get(url)
            next_page = page.links.select{ |l| l.href && l.href.match(/read_sql.php|read_sql.asp|read.asp|/) && l.to_s == "下一章"}.first
            save_chapter_form_next_page(book, next_page)
          end
        end
      end

      def update_book(book)
        @agent = Mechanize.new

        @book_chapter_exist_count = 0
        book_chapter = book.book_chapters.last
        if book_chapter.download_url
          puts "begin fetch #{book.title}"

          url = if book_chapter.download_url.match(/http:\/\//)
                  book_chapter.download_url
                else
                  "#{get_host}/#{book_chapter.download_url}"
                end

          page = @agent.get(url)
          next_page = page.links.select{ |l| l.href && l.href.match(/read_sql.php|read_sql.asp|read.asp|/) && l.to_s == "下一章"}.first
          save_chapter_form_next_page(book, next_page)
        end
      end
      private

      def process_single_book(book)
        @book_chapter_exist_count = 0
        chapter_url = "#{get_host}/#{book.href}"
        introduction_url = chapter_url.gsub("readbook", "articleinfo").gsub("aid", "id")

        # 某一本小说
        page = @agent.get(chapter_url)

        book_info = get_book_info(introduction_url)

        book_name = book_info[:book_name]
        book = Book.find_by(title: book_name)

        put_logs("=> 开始小说 #{book_name} ==========================", "info")
        unless book.present?
          Book.transaction do

            book_type = 1 # 转载
            author_name = book_info[:author_name]
            classification_name = book_info[:book_type]
            classification = Classification.find_or_create_by(name: classification_name)
            author = Author.find_or_create_by(name: author_name)

            book = Book.create({
                                   title: book_name,
                                   book_type: book_type,
                                   classification_id: classification.id,
                                   author_id: author.id,
                                   status: book_info[:status],
                                   introduction: book_info[:introduction] || "暂无简介",
                                   words: book_info[:word_count]
                               })
            book_volume = book.book_volumes.new(title: '正文', book_id: book.id)
            book_volume.save
          end
        end

        lastest_download_url = book.lastest_download_url
        if lastest_download_url.present?
          page =  @agent.get(lastest_download_url)
        end

        chapter_list(book, page)

        put_logs("#{book_name}下载完毕。。。", error_type = 'info')
        puts "#{book_name}下载完毕。。。"
      end

      def chapter_list(book, page)
        next_page = page
        while next_page.present?
          url = next_page.try(:uri).to_s
          book.update(lastest_download_url: url)

          links = next_page.links
          all_chapters = links.select{ |l| l.href && l.href.match(/read_sql.php|read_sql.asp|read.asp|/)}

          all_chapters.each do |chapter_link|
            chapter_name = chapter_link.to_s
            if @book_chapter_exist_count > BOOK_CHAPTER_LIMIT
              break
            end

            begin
              chapter_page = chapter_link.click
            rescue
              sleep 5
              chapter_page = chapter_link.click
            end

            title = chapter_page.search(".//*[@id='daohang']//text()").find{|c| c.present?}.to_s
            content = chapter_page.search(".//*[@id='zhengwen']/table/tr/td").children.to_html
            begin
              save_chapter_info(book, chapter_title: title, content: content, download_url: chapter_page.uri.to_s)
            rescue
              put_logs(content, "error_content")
              save_chapter_info(book, chapter_title: title, content: convert_string(content), download_url: chapter_page.uri.to_s)
            end

          end

          if @book_chapter_exist_count > BOOK_CHAPTER_LIMIT
            put_logs("章节存在数量超限 #{@book_chapter_exist_count}, 请人人工核查！", error_type = 'chapter_exist')

            break
          end

          puts url

          next_page = links.find{ |l| l.href && l.href.match(/readbook_next.php/) && l.to_s == "下页"}
          next_page = next_page.click if next_page
        end
      end

      # If can, replace the `chapter_list` method
      def chapter_list_new(book, page)
        chapter_list_page = page
        if chapter_list_page.present?
          url = chapter_list_page.try(:uri).to_s
          book.update(lastest_download_url: url)

          links = chapter_list_page.links

          # this is first chapter
          next_page = links.select{ |l| l.href && l.href.match(/read_sql.php|read_sql.asp|read.asp|/)}.first
          save_chapter_form_next_page(book, next_page)
        end

      end

      def save_chapter_form_next_page(book, next_page)
        chapter_page = nil
        while next_page.present?
          begin
            chapter_page = next_page.click
          rescue
            sleep 5
            chapter_page = next_page.click
          end

          if @book_chapter_exist_count > BOOK_CHAPTER_LIMIT
            put_logs("章节存在数量超限 #{@book_chapter_exist_count}, 请人人工核查！", error_type = 'chapter_exist')

            break
          end

          title = chapter_page.search(".//*[@id='daohang']//text()").find{|c| c.present?}.to_s
          content = chapter_page.search(".//*[@id='zhengwen']/table/tr/td").children.to_html
          begin
            save_chapter_info(book, chapter_title: title, content: content, download_url: chapter_page.uri.to_s)
          rescue
            put_logs(content, "error_content")
            save_chapter_info(book, chapter_title: title, content: convert_string(content), download_url: chapter_page.uri.to_s)
          end

          next_page = chapter_page.links.select{ |l| l.href && l.href.match(/read_sql.php|read_sql.asp|read.asp|/) && l.to_s == "下一章"}.first
        end

        if chapter_page.present?
          book.update(lastest_chapter_id: chapter_page.uri.to_s)
        end
      end

      def is_chapter_exists?(book, chapter_title)
        book.book_chapters.where(title: chapter_title).exists?
      end

      def save_chapter_info(book, chapter_title: , content:, download_url: )
        if book.present?
          unless book.book_chapters.where(title: chapter_title).exists?
            book_volume = book.book_volumes.first
            prev_chpater = book.book_chapters.last
            book_chapter = book.book_chapters.create({
                title: chapter_title,
                content: content,
                download_url: download_url,
                book_volume_id: book_volume.try(:id),
                prev_chapter_id: prev_chpater.try(:id)
              })

            if book_chapter.errors.blank?
              prev_chpater.update(next_chapter_id: book_chapter.id ) if prev_chpater
              puts "#{chapter_title} 章节下载完毕"
            else
              puts("章节下载失败！ #{book_chapter.errors.full_messages}")
            end
          else
            @book_chapter_exist_count += 1
            puts("章节存在！ #{chapter_title}")
          end
        end
      end

      # for fenghuo
      def get_book_info(introduction_url)
        page = @agent.get(introduction_url)

        book_name = page.search(".//*[@id='nav']/ul/text()").first.to_s.gsub(/《|》/,"")
        author_name = page.links.select{|l| l.href && l.href.match(/search_out.php/)}.first.to_s
        book_type = page.links.select{|l| l.href && l.href.match(/sortlist.php/)}.first.to_s

        text_arr = page.search("text()").map{|a| a.to_s unless a.blank?}.compact
        status = text_arr.find{|t| t.match(/状态:/)}.gsub("状态:","") == "已全本" ? 2 : 1 # 完本
        word_count = text_arr.find{|t| t.match(/字数:/)}.gsub("字数:","").to_i

        target_index = 0
        text_arr.each_with_index do |str, i|
          if str.match(/作品简介/)
            target_index = i + 1
          end
        end
        introduction = text_arr[target_index]


        {
            book_name: book_name,
            author_name: author_name,
            book_type: book_type,
            status: status,
            introduction: introduction,
            word_count: word_count
        }
      end

      def convert_string(content)
        content = content.gsub get_regex, ''

        content
      end

      def put_logs(msg, error_type = 'error')
        puts msg

        dir_path = "#{Rails.root.to_s}/public/novels/logs"
        FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
        file = File.new("#{dir_path}/#{Date.today.strftime("%Y%m%d")}_#{error_type}.log", "a+")
        file.puts msg
        file.close
      end

      def save_as_file(dir_name, title, content)
        dir_path = "#{Rails.root.to_s}/public/novels/#{dir_name}"
        FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
        file = File.new("#{dir_path}/#{title}.html", "a+")
        file.puts(content)
      end

      def get_regex
        regex = /[^[\u0000-\uD7FF]|[\uE000-\uFFFF]]|[\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}]/
      end

      def calculate_time(time_i)
        @time_all ||= 0.0
        t_now = Time.now.to_f
        @time_all += ((t_now-time_i.to_i)*1000).round(1)
        ((t_now-time_i.to_i)*1000).round(1)
      end
    end
  end
end