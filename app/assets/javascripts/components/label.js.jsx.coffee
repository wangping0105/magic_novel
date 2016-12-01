# 这个个demo, 可以使用jsx语法
@Home1 = React.createClass
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
    if !$.isEmptyObject(@state.data)
      React.createElement "div", null,
         $.map @state.data, (user, index)->
            `<div key={index}>
              <span className="other_user">
                {user.name}
                <span className="nickname">{user.nickname} </span>{user.created_at}:
              </span>
             <label dangerouslySetInnerHTML= {{__html: user.content}}></label>
            </div>`
    else
      `<div>暂无</div>`
