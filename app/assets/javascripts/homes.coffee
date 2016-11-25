# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#talk_detail_content').bind 'keyup', ->
      if event.keyCode == 13
        $('#talk_content_btn').click()

  $(".nav-tabs li").on "click", ->
    $(".nav-tabs li").removeClass("active")
    $(this).addClass("active")

@initFayeClient= () ->
  console.log("faye 初始化成功!")
  @faye = window.fayeClient

  @orgin_title = document.title
  self = @

  # to all users
  @faye.subscribe "/notifications/broadcast", (data) ->
    console.log(JSON.stringify(data) + "from faye server")
    hideMessage(data.text)

  # to a user, has a acces_token
  @faye.subscribe "/notifications/#{window.temp_access_token}", (data) ->
    console.log(JSON.stringify(data) + "from faye server")
    hideMessage(data.text)

  @faye.subscribe "/talks/broadcast", (data) ->
    console.log(JSON.stringify(data) + "from faye server")
    user = data.user
    hideMessage((user.name + ":" + user.content), false)
    $("#talk_content").append("""
      <div>
        <span class="other_user">
          #{user.name}
          <span class="nickname">#{user.nickname} </span>#{user.created_at}:
        </span>
        <label><span>#{user.content}</span></label>
      </div>
    """)
    $('#talk_content').scrollTop($('#talk_content')[0].scrollHeight)

@send_message= (user_id)->
    content = $("#talk_detail_content").val()
    $.ajax
      url: "/api/homes/talks"
      type: 'get'
      dataType: 'json'
      data: {user_id: user_id, content: content}
      cache: false
      success: ->
        $("#talk_detail_content").val("");
        console.log("发送成功!")
      error: (err)->
        console.error( status, err.toString())

@hideMessage = (msg, count_flag = true)->
  id = guid()
  $("#faye_msg").append('<div id="'+id+'" class="aaa alert alert-message alert-info fade in"><a href="#" class="close">&times;</a><div>'+msg+'</div></div>')
  setTimeout (->
    $("#" + id).remove();
  ), 3000

  if count_flag
    index = $("#msg_count").text();
    if index == ""
      index = 1
    else
      index = parseInt(index) + 1

    $("#msg_count").text(index);