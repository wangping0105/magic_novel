class Api::EmoticonsController < ApplicationController

  def rand_show
    total_count = Emoticon.all_emoticon.count
    arr = []
    (1..14).each{
      _i = rand(total_count)
      arr << rand(_i) unless arr.include?(_i)
    }
    @all_emoticon = Emoticon.all_emoticon.where(id: arr)
  end
end