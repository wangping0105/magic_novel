# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
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
    _hideMessage(data.text)

  # to a user, has a acces_token
  @faye.subscribe "/notifications/#{window.temp_access_token}", (data) ->
    console.log(JSON.stringify(data) + "from faye server")
    _hideMessage(data.text)


_hideMessage = (msg)->
  $("#faye_msg").html(msg)
  $("#faye_msg").show()
  setTimeout (->
    $("#faye_msg").hide()
  ),2000