class Dapps::EosSanguosController < Dapps::ApplicationController
  def index
    @eos_sanguos = EosSanguo.order(trx_time: :desc).page(params[:page])

    if params[:category].present?
      @eos_sanguos = @eos_sanguos.where(category: params[:category])
    end

    if params[:receiver].present?
      @eos_sanguos = @eos_sanguos.where(receiver: params[:receiver])
    end

    if params[:buyer].present?
      @eos_sanguos = @eos_sanguos.where(buyer: params[:buyer])
    end

    if params[:category_id].present?
      @eos_sanguos = @eos_sanguos.where(category_id: params[:category_id])
    end
  end

  def rank
    @eos_sanguos = EosSanguo.select("count(id) c, category_id, category")

    if params[:category].present?
      @eos_sanguos = @eos_sanguos.where(category: params[:category])
    end

    @eos_sanguos = @eos_sanguos.group(:category_id, :category).
        where("trx_time >= ?", Time.now - 9.hour ).
        order("count(id) desc, category_id asc" ).limit(15)
  end
end
