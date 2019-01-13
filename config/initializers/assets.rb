# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( hybird.js hybird.css)

Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'antd', 'fonts')
Rails.application.config.assets.precompile += %w( *.otf *.eot *.svg *.ttf *.woff *.woff2)
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( minings.css minings.js )
Rails.application.config.assets.precompile += %w( dapps.css dapps.js )


