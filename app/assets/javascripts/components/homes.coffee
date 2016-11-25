{Row, Col} = antd

@Home = React.createClass
  getInitialState: ->
    data :[]

  componentDidMount: ->
    $.getJSON @props.url, (response) =>
      globalHandleResponse response, =>
        data = response.data
        if response.code == 0
          @setState(data: data)

  componentDidUpdate: ->
    $('#talk_content').scrollTop( $('#talk_content')[0].scrollHeight )

  render: ->
    React.createElement "div", null,
      if !$.isEmptyObject(@state.data)
        $.map @state.data, (user, index)->
          React.createElement "div", {key: index},
            React.createElement "span", {className: 'other_user'},
              user.name
              React.createElement "span", {className: 'nickname'}, user.nickname
              user.created_at

            React.createElement "label", null,
              React.createElement "span", null, user.content
      else
        React.createElement "div", null, "暂无记录"
