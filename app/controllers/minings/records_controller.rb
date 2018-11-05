class Minings::RecordsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index
  end

  def create
    user = EosUser.find_or_create_by!(account: params[:from])
    eos_mining = user.eos_minings.new(
        {
            category: params[:category],
            referrer: params[:referrer],
            from: params[:from],
            to: params[:to],
            quantity: params[:quantity],
            memo: params[:memo],
            transaction_id: params[:transaction_id],
            account: params[:quantity].to_f
        }
    )

    if eos_mining.save
      render json: { code: 0 }
    else
      render json: {code: -1, message: eos_mining.errors.full_messages}
    end
  end
end
