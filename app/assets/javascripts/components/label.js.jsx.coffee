# 这个个demo, 可以使用jsx语法
@Home1 = React.createClass
  getInitialState: ->
    data :[]

  componentDidMount: ->
    $.getJSON @props.url, (response) =>
      globalHandleResponse response, =>
        data = response.data
        @setState(data: data)

  render: ->
    if !$.isEmptyObject(@state.data)
      React.createElement "div", null,
         $.map @state.data, (user, index)->
            `<div key={index}>
              <span className="current_user">
                {user.name}
                <span className="nickname">{user.nickname} </span>{user.created_at}:
              </span>
              <label><span>{user.content}</span></label>
            </div>`
           # 这里面除了代码结构能够更html一样,其他的属性还是得遵循reactjs的语法
    else
      `<div>暂无</div>`
