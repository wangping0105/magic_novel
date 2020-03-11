RailsAdmin.config do |config|
  config.authorize_with do
    authentication_token = User.encrypt(cookies[:authentication_token])
    @current_user ||= User.find_by(authentication_token: authentication_token)

    redirect_to main_app.root_path unless @current_user.present?
  end

  config.navigation_static_links = {
      '后台首页' => '/minings',
      '控制面板' => '/admin'

  }
  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  config.included_models = [
      "Setting",
      "EosUser",
      "EosKnight",
      "EosMining",
      "Book",
      "BookChapter",
      "BookVolume",
      "BookMark"
  ]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    show
    edit do
      except [

             ]
    end
    # show_in_app
    # bulk_delete
    # delete # 先不允许删除

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end