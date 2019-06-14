class Dapps::EosKnightsController < Dapps::ApplicationController
  def index
    @eos_knights = EosKnight.order(trx_time: :desc).page(params[:page])

    begin_time = Date.today.at_beginning_of_day - 8.hour
    end_time = Date.today.at_end_of_day - 8.hour
    @eos_knights_today = EosKnight.where(trx_time: begin_time..end_time)

    if params[:category].present?
      @eos_knights = @eos_knights.where(category: params[:category])
    end

    if params[:receiver].present?
      @eos_knights = @eos_knights.where(receiver: params[:receiver])
    end

    if params[:buyer].present?
      @eos_knights = @eos_knights.where(buyer: params[:buyer])
    end

    if params[:category_id].present?
      @eos_knights = @eos_knights.where(category_id: params[:category_id])
    end
  end

  def rank
    @eos_knights = EosKnight.select("count(id) c, category_id, category")

    if params[:category].present?
      @eos_knights = @eos_knights.where(category: params[:category])
    end

    @eos_knights = @eos_knights.group(:category_id, :category).
        where("trx_time >= ?", Time.now - 9.hour ).
        order("count(id) desc, category_id asc" ).limit(15)
  end
end
