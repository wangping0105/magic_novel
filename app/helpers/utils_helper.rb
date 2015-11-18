module UtilsHelper
  def standard_time(time = Time.now)
    return "" if time.nil?
    time.strftime("%F %T")
  end

  # == 过滤emoji表情
  def filterEmoji(source)
    #    return source if (!containsEmoji(source)) #如果不包含，直接返回
    # 过滤正则
    regex = /\u{0}|\u{A}|\u{D}|[\u{E000}-\u{FFFD}]|[\u{10000}-\u{10FFFF}]|※/
    source.gsub(regex,"")
  end

  # == 检查string是否包含emoji表情
  def containsEmoji(source = "")
    return false if source.blank?
    source.each_codepoint do |a|
      return true if (isEmojiCharactercodePoint(a)) # do nothing，判断到了这里表明，确认有表情字
    end
    false
  end

  # == 检查某个字符是否是emoji
  def isEmojiCharactercodePoint codePoint
    return (codePoint == 0x0) ||
      (codePoint == 0x9) ||
      (codePoint == 0xA) ||
      (codePoint == 0xD) ||
      ((codePoint >= 0xE000) && (codePoint <= 0xFFFD)) ||
      ((codePoint >= 0x10000) && (codePoint <= 0x10FFFF))
    # "ss".gsub /\u{0}\u{A}\u{D}\u{E000}-\u{FFFD}\u{10000}-\u{10FFFF}/,""
  end
end
