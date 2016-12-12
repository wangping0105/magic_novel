# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(".datepicker").datetimepicker({
    closeText: '关闭',
    prevText: '<上月',
    nextText: '下月>',
    currentText: '今天',
    monthNames: ['一月','二月','三月','四月','五月','六月',
                 '七月','八月','九月','十月','十一月','十二月'],
    monthNamesShort: ['一','二','三','四','五','六',
                      '七','八','九','十','十一','十二'],
    dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
    dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
    dayNamesMin: ['日','一','二','三','四','五','六'],
    weekHeader: '周',
    dateFormat: 'yy-mm-dd',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: true,
    yearSuffix: '年'
    showOtherMonths: true,
    selectOtherMonths: true,
    changeMonth: true,
    changeYear: true,
    showSecond: true,
    timeFormat: 'hh:mm:ss'
  });
  $('#talk_detail_content').bind 'keyup', ->
    if event.keyCode == 13
      unless($("#talk_detail_content").val() == "" || $("#talk_detail_content").val() == "\n")
        $('#talk_content_btn').click()
      else
        $("#talk_detail_content").val("")
        hideMessage("消息不能为空!", "error")

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
    hideMessage((user.name + ":" + user.content), "talk_count")
    $("#talk_content").prepend("""
      <div>
        <span class="other_user">
          #{user.name}
          <span class="nickname">#{user.nickname}</span>
          <span class="time">#{user.created_at}</span>
        </span>
        <label>#{user.content}</label>
      </div>
    """)
#    $('#talk_content').scrollTop($('#talk_content')[0].scrollHeight)
    showNotification(user.name+": "+ user.content + "\n\n" + user.created_at)

@send_message= (user_id, content = null)->
  content = (content || $("#talk_detail_content").val() )
  $("#talk_detail_content").val("");
  unless content == ""
    $.ajax
      url: "/api/homes/talks"
      type: 'get'
      dataType: 'json'
      data: {user_id: user_id, content: content}
      cache: false
      success: ->
        console.log("发送成功!")
      error: (err)->
        console.error( status, err.toString())
  else
    @hideMessage("消息不能为空!", "error")

@hideMessage = (msg, count_flag = "msg_count")->
  id = guid()
  $("#faye_msg").append('<div id="'+id+'" class="aaa alert alert-message alert-info fade in"><a href="#" class="close">&times;</a><div>'+msg+'</div></div>')
  setTimeout (->
    $("#" + id).remove();
  ), 3000

  index = $("#" + count_flag).text();
  if index == ""
    index = 1
  else
    index = parseInt(index) + 1
  $("#" + count_flag).text(index);

@showNotification= (text)->
  window.Notification.permission = "granted"

  if window.Notification
    if window.Notification.permission == "granted"
      notification = new Notification('消息提示!', {
        body: text,
        icon: 'https://ruby-china-files.b0.upaiyun.com/user/avatar/9861.jpg!lg'
      })
      setTimeout (->
        notification.close()
      ), 5000
    else
      window.Notification.requestPermission()

  else
    alert('你的浏览器不支持此消息提示功能，请使用chrome内核的浏览器！')
