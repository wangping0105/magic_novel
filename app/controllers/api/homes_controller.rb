class Api::HomesController < ApplicationController
  LIMIT = 15

  def talks
    room = ChatRoom.first
    if params[:user_id]
      messages = room.messages.new(user_id: current_user.id, content: params[:content])
      messages.save
      _content = {
        id: messages.id,
        name: current_user.name,
        content: markdown(params[:content]).html_safe,
        nickname: "sb",
        created_at: Time.now.strftime("%F %T")
      }

      # FayeClient.send_message("/talks/broadcast", {user: _content})
      # FayeClient.send_message("/notifications/#{current_user.api_key.access_token}#{current_user.id}", {notification:_content})

      render json:{ code: 1}
    else
      messages = room.messages.order(id: :desc).includes(:user)
      messages = if params[:message_id]
        messages.where("id < ?", params[:message_id]).limit(LIMIT)
      else
        messages.limit(LIMIT)
      end
      contents = messages.map do |msg|
        _content = {
          id: msg.id,
          name: msg.user.name,
          content: markdown(msg.content).html_safe,
          nickname: "sb",
          created_at: msg.created_at.strftime("%F %T")
        }
      end
      render json:{ code: 0, data: contents }
    end

  end
end