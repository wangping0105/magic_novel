class UserHome::BooksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :store_location

  def index

  end

  def update

  end

  private

 
end
