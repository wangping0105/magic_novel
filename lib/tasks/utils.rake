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
    FayeClient.send_message("/notifications/broadcast", {text: "testeste"})
  end
end