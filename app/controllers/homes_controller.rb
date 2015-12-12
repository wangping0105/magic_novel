class HomesController < ApplicationController
  def index
    @books = Book.order("click_count desc").limit(9)
  end

  def show
    render layout: false
  end
end
