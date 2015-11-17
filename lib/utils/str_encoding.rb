#!/usr/bin/env ruby -w
# -*- coding: UTF-8 -*-
# ruby utf8 gb2312 gbk gb18030 转换库

#require 'pathname'
#require 'rchardet'

require 'iconv'
if RUBY_VERSION > '1.9'
  Ig = ''
else
  Ig = '//IGNORE'
end
class String
  def togbk
    Iconv.conv("GBK#{Ig}","UTF-8#{Ig}",self)
  end
  def to_gb
    Iconv.conv("GB18030#{Ig}","UTF-8#{Ig}",self)
  end
  def utf8_to_gb
    Iconv.conv("GB18030#{Ig}","UTF-8#{Ig}",self)
  end
  def gb_to_utf8
    Iconv.conv("UTF-8#{Ig}","GB18030#{Ig}",self)
  end
  def to_utf8
    Iconv.conv("UTF-8#{Ig}","GB18030#{Ig}",self)
  end
  alias toutf8 to_utf8
  alias togb to_gb
end
#p '中文'.togbk