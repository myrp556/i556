# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
#
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( bootstrap.min.css )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )

Rails.application.config.assets.precompile += %w( banner.css )
Rails.application.config.assets.precompile += %w( home.js )
Rails.application.config.assets.precompile += %w( home.css )
Rails.application.config.assets.precompile += %w( login.css )

Rails.application.config.assets.precompile += %w( users_post.js )

Rails.application.config.assets.precompile += %w( weibos.js )
Rails.application.config.assets.precompile += %w( weibos.css )
