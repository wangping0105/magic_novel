class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::AttachmentHelper
  before_action :set_user, only:[ :show]

  def show
    param! :user_id, Integer, required: false

    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def update
    param! :user, Hash, required: true do |u|
      u.param! :name, String, required: true
    end

    unless current_user.update(user_params)
      raise EntityValidationError.new(current_user)
    else
      update_attachments_by(current_user, {attachment_ids: nil})
    end
  end

  def my_books
    @page_title = "我的书架"
    @collection_books = current_user.collection_books.includes(book:[:classification, book_marks: :book_chapter]).
        joins("left join book_marks bm on book_relations.book_id = bm.book_id").order('book_marks.updated_at desc').distinct

    render_json_data(@collection_books.map{|cb|
      book = cb.book
      book_chapter = book.chapter_of_book_mark_by(current_user)

      {
          book: book.as_json,
          book_chapter: book_chapter.slice(:id, :title),
          newest_chapter: book.newest_chapter_simple
      }
    })
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit([:name, :sex,
      address_attributes: [:detail_address, :phone, :province_id, :city_id, :country_id, :district_id, :id, :address_type]
    ])
  end
end
