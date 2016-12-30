module ErrorCodes
  UNAUTHORIZED = 401 # 无权限
  METHOD_NOT_ALLOWED = 405 # http请求错误
  SERVER_ERROR = 500 # 服务器内部错误

  FAIL_AUTH = 100400 # 认证失败
  AUTH_LOCK = 100500 # 账户冻结
  USER_DESTORY = 100600 # 账户删除

  INVALID_APP = 100000 # access_token 错误
  INVALID_PARAMS = 100406 # 非法参数
  INVALID_USER = 100401 # 无效用户

  RECORD_NOT_FOUND = 100100 # 记录不存在
  ENTITY_NOT_ACCESSED = 100111 # 没有访问权限

  INVALID_PHONE = 200406 # 无效电话
  INVALID_CAPTCHA = 200400 #无效的验证码

  FAIL_SMS = 300000 # 短信发送失败

  ENTITY_VALIDATION = 400100 # 对象校验错误
end
