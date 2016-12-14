{Row, Col} = antd

@Home = React.createClass
  getInitialState: ->
    url = @props.url
    scrollBottomTest ()->
      old_id = $("#message_id").val()
      if old_id != "wait"
        $("#message_id").val("wait")
        console.log("start get!")
        $.getJSON url + "?message_id=" + old_id, (response) =>
          globalHandleResponse response, =>
            data = response.data
            if response.code == 0
              $("#talk_content").append $.map data, (user, index)->
                """
                  <div>
                    <span class="other_user">
                      #{user.name}
                      <span class="nickname">#{user.nickname}</span>
                      <span class="time">#{user.created_at}</span>
                    </span>
                    <label>#{user.content}</label>
                  </div>
                """

              $("#message_id").val(data[data.length-1].id)
          ,=>
            $("#message_id").val(old_id)

    data :[]

  componentDidMount: ->
    $.getJSON @props.url, (response) =>
      globalHandleResponse response, =>
        data = response.data
        if response.code == 0
          @setState(data: data)
          $("#message_id").val(data[data.length-1].id)

  componentDidUpdate: ->
#    $('#talk_content').scrollTop( $('#talk_content')[0].scrollHeight )

  render: ->
    React.createElement "div", null,
      if !$.isEmptyObject(@state.data)
        $.map @state.data, (user, index)->
          React.createElement "div", {key: index},
            React.createElement "span", {className: 'other_user'},
              user.name
              React.createElement "span", {className: 'nickname'}, user.nickname
              React.createElement "span", {className: 'time'}, user.created_at

            React.createElement "label", { dangerouslySetInnerHTML: {__html: user.content} }
      else
        React.createElement "div", null, "暂无记录"
