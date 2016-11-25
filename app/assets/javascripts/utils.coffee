#
# 首字母大写
#
String.prototype.capitalize = ->
  this.toLowerCase().replace /\b(\w)|\s(\w)/g, (match) ->
    match.toUpperCase()

#
# 将金额转换为3位一个逗号
#
String.prototype.toMoney = ->
  integerPart = this.split('.')[0]
  decimalPart = this.split('.')[1]

  hasMinus = false

  if integerPart.indexOf('-') > -1
    hasMinus = true

    integerPart = integerPart.split('-')[1]

  integers = integerPart.split('').reverse().chunk(3)

  money = ''

  for integer, i in integers
    _integer = [].concat(integer)

    if i isnt integers.length - 1
      _integer.push(',')

    money = "#{_integer.reverse().join('')}#{money}"

  if decimalPart?
    "#{if hasMinus then '-' else ''}#{money}.#{decimalPart}"
  else
    "#{if hasMinus then '-' else ''}#{money}"

if antd.message
  message = antd.message

  $(document).on 'turbolinks:before-cache', ->
    message.destroy()

  notice = (type, msg, delay, callback) ->
    if $.isFunction(delay)
      callback = delay
      delay = 3

    message[type](msg, delay)

    if callback
      setTimeout ->
        callback()
      , delay * 1000

  @successNotice = (msg, delay = 3, callback = null) ->
    notice('success', msg, delay, callback)

  @errorNotice = (msg, delay = 3, callback = null) ->
    notice('error', msg, delay, callback)

  @warningNotice = (msg, delay = 3, callback = null) ->
    notice('warning', msg, delay, callback)

  @globalHandleResponse = (response, success, failure) ->
    console.log(response)
    console.log(success)
    try
      switch parseInt(response.code)
        when 0
          success()
        when 200 then success() if success

        when 401
          errorNotice('认证失败，请重新授权登录')
          failure() if failure
        when 907
        else
          errorNotice(response.message)
          failure() if failure
    catch error
      console.log "Response error: #{error}"

      errorNotice('请求失败')

      failure() if failure