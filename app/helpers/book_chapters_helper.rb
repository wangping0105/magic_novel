module BookChaptersHelper
  def book_words_style count
    count = count.to_i
    if count > 1000
      "#{count/1000}K"
    else
      count
    end
  end
end