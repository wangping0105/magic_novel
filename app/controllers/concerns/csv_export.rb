class CsvExport
  require 'csv'
  DefaultPath = "#{Rails.root.to_s}/public/books"

  def self.book_csv(books, to_path = DefaultPath )
    books.each do |book|
      # CSV.generate do |csv|
      file_path = to_path

      FileUtils.mkdir_p file_path unless File.exist?(file_path)
      unless File.exist?("#{file_path}/#{book.title}.csv")
        puts "#{book.title}开始导出~"
        book_classification = book.classification.name rescue "其他"
        
        CSV.open("#{file_path}/#{book.title}.csv", "a+") do |csv|
          csv << [book.title, book_classification, book.author.name, book.introduction, book.words, book.status_names, book.book_types_names]
          book.book_chapters.each do |book_chapter|
            csv << [book.title, book_chapter.title, book_chapter.content]
          end
        end

      else
        puts " 存在《#{book.title}》"
      end
    end
  end
end