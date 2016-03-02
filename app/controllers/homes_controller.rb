class HomesController < ApplicationController
  skip_before_action :store_location, only: [:tab_books]
  def index
    puts UserMailer.hello_world

    @books = Book.online_books.includes(:classification).order("click_count desc").limit(9)
  end

  def show
    require 'csv'
    arr = %w(58country ganjin)
    index = params[:index].to_i
    @info_arr = []

    file_path = "#{Rails.root.to_s}/public/hourses/#{arr[index]}"
    CSV.foreach("#{file_path}/addresses.csv") do |row|
      row[2] = "http://sh.ganji.com/#{row[2]}"  if params[:index ].to_i == 1
      @info_arr << row
    end if File.exist?("#{file_path}/addresses.csv")
    @info_arr = @info_arr.sort

    render layout: false
  end

  def tab_books
    param! :book_type, String, required: false

    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).order("(click_count/book_chapters_count) desc").limit(9)
  end
end
