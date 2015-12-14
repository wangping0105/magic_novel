class HomesController < ApplicationController
  def index
    @books = Book.order("click_count desc").limit(9)
  end

  def show
    require 'csv'
    arr = %w(58country ganjin)
    index = params[:index].to_i
    @info_arr = []

    file_path = "#{Rails.root.to_s}/public/#{arr[index]}"
    CSV.foreach("#{file_path}/addresses.csv") do |row|
      row[2] = "http://sh.ganji.com/#{row[2]}"  if params[:index ]= 1
      @info_arr << row
    end
    @info_arr = @info_arr.sort
    render layout: false
  end
end
