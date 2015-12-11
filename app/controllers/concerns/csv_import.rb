class CsvImport
  extend ActiveSupport::Concern
  require 'csv'
  DefaultPath = "#{Rails.root.to_s}/public/books"

  def self.book_csv(skip_check_book = false, from_path = DefaultPath )
    Dir[from_path + '/*.csv'].each do |file_path|
      index, flag, book_title, book = 0, true, "", nil

      # CSV.foreach(file_path, headers: true) do |row|
      CSV.foreach(file_path) do |row|
        if index == 0
          book_title, classification_name, author_name, introduction, words, status, book_types = row
          book = Book.find_by(title: book_title)
          if book.present?
            if !skip_check_book
              put_logs "#{book_title}已经存在", "import_book"
              flag = false
              break
            else
              put_logs "#{book_title}已经存在,开始更新"
            end
          else
            book = add_a_book(book_title, classification_name, author_name, introduction, words, book_types, status)
          end
        else
          book_title, title, content = row
          add_a_chapter(book, title, content)
        end
        index +=1
      end rescue(put_logs "error, file_path:#{file_path}", "import_book")
      put_logs "#{book_title}导入完毕", "import_book" if flag
    end
  end

  def self.add_a_book(book_title, classification_name, author_name, introduction, words, book_types, status)
    book_types = Book.book_types_options.to_h[book_types]
    status = Book.status_options.to_h[status]
    classification = Classification.where("name like ?", "%#{classification_name}%").first
    author = Author.find_or_create_by(name: author_name)
    book = Book.create({
       title: book_title,
       classification_id: classification.try(:id),
       book_type: book_types,
       status: status,
       introduction: introduction,
       author_id: author.id,
       words: words
     })
  end

  def self.add_a_chapter(book, title, content)
    book_chapter = book.book_chapters.find_by(title: title)
    if book.present?
      if book_chapter.blank?
        book_volume = book.book_volumes.first
        prev_chpater = book.book_chapters.last
        chapter_attr = {
          title: title,
          content: content,
          book_volume_id: book_volume.try(:id),
          prev_chapter_id: prev_chpater.try(:id)
        }
        book_chapter = book.book_chapters.create(chapter_attr)
        prev_chpater.update(next_chapter_id: book_chapter.id ) if prev_chpater
        put_logs("#{book.title}, #{title}章节添加完毕！")
      else
        put_logs("#{book.title}, #{title}章节存在！")
      end
    end
  end

  def self.put_logs(msg, error_type = 'import_log')
    dir_path = "#{Rails.root.to_s}/public/novels/logs"
    FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
    file = File.new("#{dir_path}/#{Date.today.strftime("%Y%m%d")}_#{error_type}.log", "a+")
    file.puts msg
    file.close
  end
end