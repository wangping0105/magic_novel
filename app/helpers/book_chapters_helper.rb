module BookChaptersHelper
  def book_words_style count
    count = count.to_i
    if count > 1000
      "#{count/1000}K"
    else
      count
    end
  end

  def get_font_color_and_size
    attrs = {}

    if current_user.present?
      attrs[:color] = current_user.settings(:chapter_font).color
      attrs[:font_size] = current_user.settings(:chapter_font).font_size
    else
      attrs[:color] = "FFFFFF"
      attrs[:font_size] = 16
    end

    attrs
  end
end