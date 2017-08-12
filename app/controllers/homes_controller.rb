class HomesController < ApplicationController
  skip_before_action :store_location, only: [:tab_books]
  before_action :get_lastest_chapter, only: [:index]

  def index
    @classifications = Classification.where('books_count > 0').order(books_count: :desc).limit(5)
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
    # TODO 暂时遗弃
    param! :book_type, String, required: false

    @books = Book.online_books.includes(:classification).book_type(params[:book_type]).order("(click_count/book_chapters_count) desc").limit(9)
  end

  def react_demo
  end

  def uuid
    respond_to do |format|
      format.html{}
      format.pdf{
        res = IdentificationOfMrz.test
        if res[:code] = 200
          res = IdentificationOfMrz.fetch_pdfreport(res[:body]['uid'])

          if res[:code] = 200
            file_bytes_64 = res[:body]['report']
            file = Tempfile.new(['temp1','.pdf'], :encoding => 'ascii-8bit')
            stringIo = StringIO.new(Base64.decode64(file_bytes_64))
            file.binmode
            file.write stringIo.read
            send_file file
          end
        end

        return
      }
    end
  end

  def create_payment
    res = Onlinepay.create_payment(amount: params[:amount], currency: params[:currency])

    if res['processingUrl']
      redirect_to res['processingUrl']
    else
      flash[:danger] = res
      render 'uuid'
    end
  rescue
    flash[:danger] = "Business api error"

    render 'uuid'
  end

  def cache_demo

  end
end
